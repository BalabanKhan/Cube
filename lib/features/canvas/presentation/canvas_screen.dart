import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../domain/hardware_penalty_service.dart';
import 'package:cubism/l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/presentation/dead_screen.dart';
import 'canvas_painter.dart';
import 'cubism_paths.dart';
import 'cubism_generator.dart';
import '../../archive/presentation/archive_screen.dart';
import '../../onboarding/presentation/onboarding_screen.dart';
import '../../onboarding/domain/cult_manifesto.dart';

class CanvasScreen extends ConsumerStatefulWidget {
  const CanvasScreen({super.key});

  @override
  ConsumerState<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends ConsumerState<CanvasScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _isStarted = false;
  bool _isVandalized = false;
  bool _isFinished = false;
  bool _isSaving = false;

  String? _vandalizedText;
  String _successMessage = "";
  
  ui.Image? _bakedImage;
  int _bakedCount = 0;
  bool _isBaking = false;
  
  ui.FragmentShader? _shader;
  late Ticker _ticker;
  double _targetDurationSeconds = 300.0;
  double _time = 0.0;
  int _touchCount = 0;
  Timer? _praiseTimer;
  
  int _franticTapCount = 0;
  DateTime _lastFranticTapTime = DateTime.now();
  final HardwarePenaltyService _hardwarePenaltyService = HardwarePenaltyService();
  
  final List<CubismElement> _elements = [];
  List<CubismElement> _plannedElements = [];
  final Random _rnd = Random();
  
  bool _reviewerBypassActive = false;
  int _bypassTapCount = 0;
  
  final List<Path> _loadedPaths = [];
  final GlobalKey _globalKey = GlobalKey();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadShader();
    _loadSvgPaths();
    
    _hardwarePenaltyService.startListeners(
      context: context,
      canTriggerPenalty: () => _isStarted && !_isFinished && !_isVandalized && !_reviewerBypassActive,
      onPenalty: (message) => _triggerVandalism(message),
    );
    
    _ticker = createTicker((elapsed) {
      if (!mounted) return;
      if (!_isStarted || _isFinished || _isVandalized) return;
      
      final elapsedSeconds = elapsed.inMicroseconds / 1000000.0;
      
      setState(() {
        _time = elapsedSeconds;
      });

      if (_plannedElements.isEmpty) return;

      final totalSeconds = _targetDurationSeconds;
      if (elapsedSeconds >= totalSeconds) {
        setState(() {
          _elements.clear();
          for (var el in _plannedElements) {
            el.progress = 1.0;
            _elements.add(el);
          }
        });
        _finishArt();
        return;
      }

      final N = _plannedElements.length;
      final double progressMultiplier = (elapsedSeconds / totalSeconds) * N;
      final activeIndex = progressMultiplier.floor();
      final activeProgress = progressMultiplier - activeIndex;

      _checkAndBake(activeIndex);

      setState(() {
        _elements.clear();
        for (int i = _bakedCount; i < N; i++) {
          if (i < activeIndex) {
            _plannedElements[i].progress = 1.0;
            _elements.add(_plannedElements[i]);
          } else if (i == activeIndex) {
            _plannedElements[i].progress = activeProgress;
            _elements.add(_plannedElements[i]);
          } else {
            break;
          }
        }
      });
    });
  }

  Future<void> _checkAndBake(int activeIndex) async {
    if (_isBaking) return;
    final threshold = (activeIndex ~/ 20) * 20;
    if (threshold > _bakedCount) {
      _isBaking = true;
      final size = _globalKey.currentContext?.size ?? MediaQuery.of(context).size;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      if (_bakedImage != null) {
        canvas.drawImage(_bakedImage!, Offset.zero, Paint());
      }
      
      final elementsToBake = _plannedElements.sublist(_bakedCount, threshold);
      for(var e in elementsToBake) {
        e.progress = 1.0;
      }
      
      CubismPainter(elementsToBake).paint(canvas, size);
      
      final picture = recorder.endRecording();
      final img = await picture.toImage(size.width.toInt(), size.height.toInt());
      
      if (mounted) {
        setState(() {
          _bakedImage = img;
          _bakedCount = threshold;
        });
      }
      _isBaking = false;
    }
  }

  Future<void> _loadShader() async {
    try {
      final program = await ui.FragmentProgram.fromAsset('shaders/canvas_noise.frag');
      if (!mounted) return;
      setState(() {
        _shader = program.fragmentShader();
      });
    } catch (e) {
      debugPrint("Shader load error: $e");
    }
  }
  
  Future<void> _loadSvgPaths() async {
    final pathRegex = RegExp(r'<path[^>]*d="([^"]+)"');
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      final svgPaths = manifestMap.keys.where((String key) => key.startsWith('assets/svgs/') && key.endsWith('.svg')).toList();
      
      for (var path in svgPaths) {
        try {
          final svgString = await rootBundle.loadString(path);
          final match = pathRegex.firstMatch(svgString);
          if (match != null) {
            final d = match.group(1);
            if (d != null) {
              _loadedPaths.add(parseSvgPathData(d));
            }
          }
        } catch (e) {
          debugPrint("Error loading SVG: $path");
        }
      }
    } catch (e) {
      debugPrint("Error reading AssetManifest: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    _praiseTimer?.cancel();
    _audioPlayer.dispose();
    _hardwarePenaltyService.stopListeners();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isStarted || _isVandalized || _isFinished) return;
    
    // Test amaçlı: Web sürümünde sekme değiştirildiğinde cezalandırmayı es geç.
    if (kIsWeb) return;
    
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      if (_time < 30) {
        _triggerVandalism(CultManifesto.getEarlyEscapeText(context));
      } else {
        _triggerVandalism();
      }
    }
  }



  Future<void> _saveFailure() async {
    final currentContext = _globalKey.currentContext;
    if (currentContext == null) return;
    final renderObject = currentContext.findRenderObject();
    if (renderObject == null || renderObject is! RenderRepaintBoundary) return;
    final RenderRepaintBoundary boundary = renderObject;

    try {
      if (kIsWeb) return; 
      
      await Future.delayed(const Duration(milliseconds: 150)); 
      if (!mounted) return;
      
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('is_drawing', false);

      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/vandalism_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(path);
        await file.writeAsBytes(byteData.buffer.asUint8List());

        final List<String> savedList = prefs.getStringList('archive_failures') ?? [];
        
        final failureData = {
          'time': DateTime.now().toUtc().toIso8601String(),
          'imagePath': path,
          'elapsedSeconds': _time,
          'targetSeconds': _targetDurationSeconds,
        };
        
        savedList.add(jsonEncode(failureData));
        if (savedList.length > 30) {
          final oldFailure = jsonDecode(savedList.removeAt(0));
          final oldImagePath = oldFailure['imagePath'];
          if (oldImagePath != null) {
            final oldFile = File(oldImagePath);
            if (oldFile.existsSync()) oldFile.deleteSync();
          }
        }
        
        await prefs.setStringList('archive_failures', savedList);
      }
    } catch (e) {
      debugPrint("Error saving failure: $e");
    }
  }

  Future<void> _triggerVandalism([String? customMsg]) async {
    final selectedMsg = customMsg ?? CultManifesto.getRandomBetrayal(context);

    WakelockPlus.disable();
    
    await _saveFailure();
    
    if (!mounted) return;

    setState(() {
      _isVandalized = true;
      _isStarted = false;
      _vandalizedText = selectedMsg;
    });
    
    if (_ticker.isActive) {
      _ticker.stop();
    }
    _praiseTimer?.cancel();
    
    try {
      await _audioPlayer.play(AssetSource('sounds/vandalism.wav'));
    } catch (e) {
      debugPrint("Audio play failed: $e");
    }
    
    final prefs = await SharedPreferences.getInstance();
    final endTime = DateTime.now().toUtc().add(const Duration(hours: 3));
    await prefs.setString('lockout_end_time', endTime.toIso8601String());
    
    if (!kIsWeb) {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 1000, amplitude: 255);
      } else {
        HapticFeedback.heavyImpact();
      }
    }
    
  }

  void _handleCanvasTouch() {
    if (!_isStarted || _isFinished || _isVandalized) return;
    
    _touchCount++;
    if (_touchCount == 1) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.dontTouchWarning,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.murderRed, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          backgroundColor: AppTheme.oledBlack,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      );
    } else {
      _triggerVandalism();
    }
  }

  void _handleStart() async {
    final penaltyMessage = await _hardwarePenaltyService.checkStartupPenalties(context);
    if (!mounted) return;
    
    if (penaltyMessage != null) {
      _goToDeadScreen(customMessage: penaltyMessage);
      return;
    }

    if (_rnd.nextDouble() < 0.15) { // 15% rejection rate
       _goToDeadScreen(customMessage: CultManifesto.getRandomRejection(context));
       return;
    }

    if (_loadedPaths.isEmpty) {
      _loadedPaths.addAll(CubismPaths.allPaths); 
    }

    final targetMinutes = 5 + _rnd.nextInt(56); 
    final size = _globalKey.currentContext?.size ?? MediaQuery.of(context).size;
    
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('is_drawing', true);
      prefs.setDouble('target_duration', targetMinutes * 60.0);
    });

    setState(() {
      _touchCount = 0;
      _plannedElements = CompositionGenerator.generatePlannedComposition(size, targetMinutes, _loadedPaths);
      _elements.clear();
      _targetDurationSeconds = targetMinutes * 60.0;
      _isStarted = true;
    });
    
    if (!_ticker.isActive) {
      _ticker.start();
    }
    WakelockPlus.enable();
    
    _praiseTimer?.cancel();
    final whisperIntervalMs = (_targetDurationSeconds * 1000 ~/ 6);
    _praiseTimer = Timer.periodic(Duration(milliseconds: whisperIntervalMs), (timer) {
      if (!mounted || !_isStarted || _isFinished || _isVandalized) {
        timer.cancel();
        return;
      }
      
      final msg = CultManifesto.getRandomWhisper(context);
      
      HapticFeedback.lightImpact();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.oledBlack.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      );
    });
  }
  
  void _finishArt() {
    WakelockPlus.disable();
    if (_ticker.isActive) {
      _ticker.stop();
    }
    _praiseTimer?.cancel();
    
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('is_drawing', false);
    });

    final successMsg = CultManifesto.getRandomSuccess(context);

    setState(() {
      _isStarted = false;
      _isFinished = true;
      _successMessage = successMsg;
    });
  }



  Future<void> _exportAndExit() async {
    if (_isSaving) return;

    final currentContext = _globalKey.currentContext;
    if (currentContext == null) return;
    final renderObject = currentContext.findRenderObject();
    if (renderObject == null || renderObject is! RenderRepaintBoundary) return;
    final RenderRepaintBoundary boundary = renderObject;

    final successMsg = CultManifesto.getSuccessExitText(context);
    final permissionDeniedDeathText = CultManifesto.getPermissionDeniedDeathText(context);
    final permissionDeniedText = AppLocalizations.of(context)!.permissionDenied;

    setState(() { _isSaving = true; });
    
    try {
      if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
        Permission targetPermission = defaultTargetPlatform == TargetPlatform.iOS 
            ? Permission.photosAddOnly 
            : Permission.storage;
            
        var status = await targetPermission.status;
        if (!status.isGranted) {
          status = await targetPermission.request();
        }
        
        if (status.isPermanentlyDenied) {
          if (!mounted) return;
          _goToDeadScreen(customMessage: permissionDeniedDeathText);
          return;
        }

        if (!status.isGranted) {
           if (!mounted) return;
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text(
                 permissionDeniedText,
                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.clinicalWhite),
               ),
               backgroundColor: AppTheme.oledBlack,
               behavior: SnackBarBehavior.floating,
               shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
             ),
           );
           return;
        }
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null && !kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/Cubism_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(byteData.buffer.asUint8List());
        final result = await ImageGallerySaverPlus.saveFile(file.path);
        if (!mounted) return;
        
        if (result['isSuccess'] == true) {
          // Success
        }
      }
      
      if (!mounted) return;
      _goToDeadScreen(customMessage: successMsg);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() { _isSaving = false; });
      }
    }
  }
  
  void _goToDeadScreen({String? customMessage}) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DeadScreen(customMessage: customMessage),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppTheme.oledBlack,
      body: Stack(
        children: [
          GestureDetector(
            onTapDown: (_) {
               final now = DateTime.now();
               if (now.difference(_lastFranticTapTime).inSeconds > 3) {
                 _franticTapCount = 1;
               } else {
                 _franticTapCount++;
               }
               _lastFranticTapTime = now;

               if (_franticTapCount >= 5 && _isStarted && !_isFinished && !_isVandalized) {
                  _franticTapCount = 0;
                  _targetDurationSeconds += 60;
                  HapticFeedback.heavyImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(CultManifesto.getTapSpammingText(context)),
                      backgroundColor: AppTheme.murderRed,
                      duration: const Duration(seconds: 4),
                    ),
                  );
               } else {
                 _handleCanvasTouch();
               }
            },
            onPanDown: (_) {
              if (_isStarted && !_isFinished && !_isVandalized) {
                HapticFeedback.heavyImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(CultManifesto.getTouchWarningText(context)),
                    backgroundColor: AppTheme.murderRed,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            behavior: HitTestBehavior.translucent,
            child: RepaintBoundary(
              key: _globalKey,
              child: Stack(
                children: [
                if (_shader != null)
                  SizedBox.expand(
                    child: CustomPaint(
                      painter: ShaderBackgroundPainter(shader: _shader!, time: _time),
                    ),
                  ),
                  
                if (_elements.isNotEmpty || _bakedImage != null)
                  SizedBox.expand(
                    child: CustomPaint(
                      painter: CubismPainter(_elements, bakedImage: _bakedImage),
                    ),
                  ),

                if (_isVandalized)
                  Container(
                    color: AppTheme.murderRed,
                    child: SafeArea(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _vandalizedText ?? '',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppTheme.oledBlack,
                                  backgroundColor: AppTheme.clinicalWhite,
                                ),
                              ),
                              const SizedBox(height: 40),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.oledBlack,
                                  foregroundColor: AppTheme.clinicalWhite,
                                  side: const BorderSide(color: AppTheme.clinicalWhite, width: 2),
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                ),
                                onPressed: _goToDeadScreen, 
                                child: Text(l10n.leave),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Reviewer Bypass
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      _bypassTapCount++;
                      if (_bypassTapCount >= 10 && !_reviewerBypassActive) {
                        setState(() {
                          _reviewerBypassActive = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(CultManifesto.getReviewerBypassText(context)),
                            backgroundColor: Colors.green[900],
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const SizedBox(width: 50, height: 50),
                  ),
                ),
                  
                if (_isFinished)
                  Positioned(
                    bottom: 20,
                    right: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: AppTheme.oledBlack,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.masterpieceCreated,
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppTheme.clinicalWhite, fontSize: 20),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _successMessage,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "CUBISM CULT",
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppTheme.murderRed),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "ENDURED FOR ${(_targetDurationSeconds ~/ 60)} MINUTES",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.clinicalWhite),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.clinicalWhite,
                                foregroundColor: AppTheme.oledBlack,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              ),
                              onPressed: _exportAndExit,
                              child: _isSaving 
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppTheme.oledBlack))
                                  : Text(l10n.saveAndLeave),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),

          if (!_isStarted && !_isVandalized && !_isFinished)
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _handleStart,
                      child: Text(l10n.start, style: Theme.of(context).textTheme.displayLarge),
                    ),
                    const SizedBox(height: 60),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ArchiveScreen()));
                      },
                      child: Text(l10n.archive, style: Theme.of(context).textTheme.bodyLarge?.copyWith(decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ),
            ),
            
          if (!_isStarted && !_isVandalized && !_isFinished)
            Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const PrivacyScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                child: Container(
                  width: 24,
                  height: 24,
                  color: AppTheme.clinicalWhite,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
