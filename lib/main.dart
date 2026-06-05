import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cubism/l10n/app_localizations.dart';

import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/canvas/presentation/canvas_screen.dart';
import 'core/theme/app_theme.dart';

import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:ntp/ntp.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    PlatformDispatcher.instance.onError = (error, stack) {
      runApp(DiagnosticApp(error: error.toString(), stack: stack.toString()));
      return true;
    };
  final prefs = await SharedPreferences.getInstance();
  
  DateTime realTime = DateTime.now().toUtc();
  bool timeManipulated = false;
  try {
    final ntpTime = await NTP.now(timeout: const Duration(seconds: 3));
    realTime = ntpTime.toUtc();
    final localTime = DateTime.now().toUtc();
    if (realTime.difference(localTime).inMinutes.abs() > 5) {
      timeManipulated = true;
    }
  } catch (_) {}

  // Force Kill Detection
  final isDrawing = prefs.getBool('is_drawing') ?? false;
  if (isDrawing) {
    prefs.setBool('is_drawing', false);
    final penaltyEnd = realTime.add(const Duration(hours: 3));
    prefs.setString('lockout_end_time', penaltyEnd.toIso8601String());
    
    // Save to Archive
    final List<String> savedList = prefs.getStringList('archive_failures') ?? [];
    final failureData = {
      'time': realTime.toIso8601String(),
      'elapsedSeconds': 0, // Force kill means we don't know exactly when, assume 0 for maximum shame
      'targetSeconds': prefs.getDouble('target_duration') ?? 300.0,
      'imagePath': null, // No image on force kill
    };
    savedList.add(jsonEncode(failureData));
    await prefs.setStringList('archive_failures', savedList);
  }

  // Time Manipulation Penalty
  final lockoutTimeString = prefs.getString('lockout_end_time');
  if (timeManipulated && lockoutTimeString != null) {
    final lockoutEnd = DateTime.parse(lockoutTimeString);
    if (realTime.isBefore(lockoutEnd)) {
      // User is locked out and manipulated time! Double the penalty.
      final doubledPenalty = realTime.add(const Duration(hours: 6));
      prefs.setString('lockout_end_time', doubledPenalty.toIso8601String());
      prefs.setBool('time_manipulated_flag', true);
    }
  }

    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          realTimeProvider.overrideWithValue(realTime),
        ],
        child: const CultApp(),
      ),
    );
  }, (error, stack) {
    runApp(DiagnosticApp(error: error.toString(), stack: stack.toString()));
  });
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());
final realTimeProvider = Provider<DateTime>((ref) => throw UnimplementedError());

class CultApp extends ConsumerWidget {
  const CultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final realTime = ref.watch(realTimeProvider);
    
    final lockoutTimeString = prefs.getString('lockout_end_time');
    bool isLockedOut = false;
    DateTime? lockoutEnd;
    final timeManipulatedFlag = prefs.getBool('time_manipulated_flag') ?? false;
    
    if (lockoutTimeString != null) {
      lockoutEnd = DateTime.parse(lockoutTimeString);
      if (realTime.isBefore(lockoutEnd)) {
        isLockedOut = true;
      } else {
        prefs.remove('lockout_end_time');
        prefs.remove('time_manipulated_flag');
      }
    }
    
    final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;

    Widget initialScreen;
    if (isLockedOut) {
      initialScreen = LockoutScreen(unlockTime: lockoutEnd!, isManipulated: timeManipulatedFlag);
    } else if (!hasCompletedOnboarding) {
      initialScreen = const OnboardingScreen();
    } else {
      initialScreen = const CanvasScreen();
    }

    return MaterialApp(
      title: 'Cubism Cult',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.brutalistTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
      ],
      home: initialScreen,
    );
  }
}

class LockoutScreen extends StatefulWidget {
  final DateTime unlockTime;
  final bool isManipulated;
  const LockoutScreen({super.key, required this.unlockTime, this.isManipulated = false});

  @override
  State<LockoutScreen> createState() => _LockoutScreenState();
}

class _LockoutScreenState extends State<LockoutScreen> {
  late Duration _remaining;
  late Stream<int> _timer;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Stream.periodic(const Duration(seconds: 1), (i) => i);
  }

  void _updateRemaining() {
    // We don't have realTime dynamically ticking, but local clock is fine for the countdown delta
    _remaining = widget.unlockTime.difference(DateTime.now().toUtc());
    if (_remaining.isNegative) _remaining = Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.oledBlack,
      body: StreamBuilder<int>(
        stream: _timer,
        builder: (context, snapshot) {
          _updateRemaining();
          
          if (_remaining.inSeconds <= 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const CanvasScreen()),
              );
            });
            return const SizedBox.shrink();
          }

          final h = _remaining.inHours.toString().padLeft(2, '0');
          final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
          final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isManipulated)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Text(
                        "Beni ucuz zaman hileleriyle kandırabileceğini mi sandın?\nİnfazın iki katına çıkarıldı.\nBekle ve çürü.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.clinicalWhite,
                          height: 1.5,
                        ),
                      ),
                    ),
                  Text(
                    "İnfazın bitmesine $h:$m:$s kaldı.\nGit.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.murderRed,
                      height: 1.5,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DiagnosticApp extends StatelessWidget {
  final String error;
  final String stack;
  
  const DiagnosticApp({super.key, required this.error, required this.stack});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[900],
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("SİSTEM ÇÖKTÜ (Diagnostic Screen)", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text("Error:\n$error", style: const TextStyle(color: Colors.yellow, fontFamily: 'monospace')),
                const SizedBox(height: 16),
                Text("Stack Trace:\n$stack", style: const TextStyle(color: Colors.white70, fontFamily: 'monospace', fontSize: 10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
