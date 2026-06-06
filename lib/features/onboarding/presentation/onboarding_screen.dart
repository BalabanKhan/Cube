import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cubism/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/presentation/dead_screen.dart';
import '../../canvas/presentation/canvas_screen.dart';
import '../domain/cult_manifesto.dart';

enum OnboardingState {
  blackVoid,
  provocation,
  vandalized,
  contract
}

class VandalismPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final int seed = 42; 
    
    // Basit bir pseudo-random generator (fixed seed için)
    double nextDouble(int i) => ((seed * i * 1103515245 + 12345) & 0x7FFFFFFF) / 0x7FFFFFFF;

    void drawBrushStroke(Offset start, Offset end, Color color, double baseWidth, int bristles, int seedOffset) {
      final double distance = (end - start).distance;
      final int segments = (distance / 8).ceil();
      final Offset direction = (end - start) / distance;
      final Offset normal = Offset(-direction.dy, direction.dx);

      for (int i = 0; i < bristles; i++) {
        final int currentSeed = seedOffset + i * 100;
        
        final double bristleOffsetAmount = (nextDouble(currentSeed) - 0.5) * baseWidth;
        final Offset startPos = start + (normal * bristleOffsetAmount);
        
        final Path path = Path();
        path.moveTo(startPos.dx, startPos.dy);
        
        for (int j = 1; j <= segments; j++) {
          final double t = j / segments;
          final Offset basePos = start + (end - start) * t;
          
          final double segmentJitter = (nextDouble(currentSeed + j * 2) - 0.5) * (baseWidth * 0.3);
          final Offset targetPos = basePos + (normal * bristleOffsetAmount) + (normal * segmentJitter);
          
          path.lineTo(targetPos.dx, targetPos.dy);
        }

        final paint = Paint()
          ..color = color.withValues(alpha: 0.2 + nextDouble(currentSeed + 2) * 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = baseWidth * (0.05 + nextDouble(currentSeed + 3) * 0.25)
          ..strokeJoin = StrokeJoin.miter
          ..strokeCap = StrokeCap.square;
          
        canvas.drawPath(path, paint);
      }
    }

    // Red stroke
    drawBrushStroke(
      Offset(-50, size.height * 0.25),
      Offset(size.width + 50, size.height * 0.15),
      AppTheme.murderRed,
      120.0,
      18,
      100,
    );

    // Black stroke
    drawBrushStroke(
      Offset(20, size.height * 0.65),
      Offset(size.width - 20, size.height * 0.7),
      AppTheme.oledBlack,
      60.0,
      12,
      200,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  OnboardingState _state = OnboardingState.blackVoid;
  Timer? _provocationTimer;
  Timer? _contractTimer;
  String _dynamicContractText = "";

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dynamicContractText.isEmpty) {
      _dynamicContractText = CultManifesto.getDailyMessage(context);
    }
  }

  void _startSequence() {
    _provocationTimer = Timer(const Duration(seconds: 10), () {
      if (!mounted) return;
      setState(() {
        _state = OnboardingState.provocation;
      });

      _contractTimer = Timer(const Duration(seconds: 5), () {
        if (!mounted || _state == OnboardingState.vandalized) return;
        setState(() {
          _state = OnboardingState.contract;
        });
      });
    });
  }

  @override
  void dispose() {
    _provocationTimer?.cancel();
    _contractTimer?.cancel();
    super.dispose();
  }

  void _handleTap() async {
    if (_state == OnboardingState.contract || _state == OnboardingState.vandalized) {
      return;
    }

    setState(() {
      _state = OnboardingState.vandalized;
    });
    
    _provocationTimer?.cancel();
    _contractTimer?.cancel();

    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 800, amplitude: 255);
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void _acceptContract() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    if (!mounted) return;
    // Brutalist transition (mechanical and fast)
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const CanvasScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(parent: animation, curve: Curves.easeInExpo);
          return FadeTransition(opacity: curve, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200), 
      ),
    );
  }

  void _rejectContract() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const DeadScreen(),
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
      backgroundColor: _state == OnboardingState.vandalized 
          ? AppTheme.clinicalWhite 
          : AppTheme.oledBlack,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: Stack(
          children: [
            SizedBox.expand(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                switchInCurve: Curves.easeInExpo,
                switchOutCurve: Curves.easeOutExpo,
                child: _buildContent(l10n),
              ),
            ),
            if (_state == OnboardingState.contract)
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
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    switch (_state) {
      case OnboardingState.blackVoid:
        return const SizedBox.shrink(key: ValueKey('void'));
      case OnboardingState.provocation:
        return Center(
          key: const ValueKey('provocation'),
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 15.0),
            child: Text(
              l10n.whyAreYouHere,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      case OnboardingState.vandalized:
        return Stack(
          key: const ValueKey('vandalized'),
          children: [
            SizedBox.expand(
              child: CustomPaint(
                painter: VandalismPainter(),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  l10n.cannotWait,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.oledBlack,
                    backgroundColor: AppTheme.clinicalWhite,
                  ),
                ),
              ),
            ),
          ],
        );
      case OnboardingState.contract:
        return Padding(
          key: const ValueKey('contract'),
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _dynamicContractText, 
                style: Theme.of(context).textTheme.displayMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _rejectContract,
                    child: Text(l10n.contractReject),
                  ),
                  TextButton(
                    onPressed: _acceptContract,
                    child: Text(l10n.contractAccept, style: const TextStyle(color: AppTheme.murderRed)),
                  ),
                ],
              )
            ],
          ),
        );
    }
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppTheme.oledBlack,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () {
                // Future Privacy Policy link logic can go here
              },
              child: Text(CultManifesto.getPrivacyPolicyText(context), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.clinicalWhite)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(CultManifesto.getDataDeletedText(context)),
                      backgroundColor: AppTheme.murderRed,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text(CultManifesto.getDeleteDataText(context), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.murderRed)),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.contractReject, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
