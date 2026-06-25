import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cubism/l10n/app_localizations.dart';

import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/onboarding/presentation/lockout_notifier.dart';
import 'features/canvas/presentation/canvas_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/db/app_database.dart';
import 'core/constants/app_constants.dart';

import 'dart:async';
import 'dart:ui';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  PlatformDispatcher.instance.onError = (error, stack) {
    runApp(DiagnosticApp(error: error.toString(), stack: stack.toString()));
    return true;
  };

  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase.instance;

  // Force Kill Detection
  final isDrawingStr = await db.getValue('is_drawing');
  final isDrawing = isDrawingStr == 'true';
  
  if (isDrawing) {
    await db.setValue('is_drawing', 'false');
    
    DateTime realTime = DateTime.now().toUtc();
    final penaltyEnd = realTime.add(const Duration(hours: AppConstants.forceKillPenaltyHours));
    await db.setValue('lockout_end_time', penaltyEnd.toIso8601String());
    
    // Save to Archive (keeping archive in SharedPreferences for now, or SQLite. We'll use prefs for simplicity as it's non-critical)
    final List<String> savedList = prefs.getStringList('archive_failures') ?? [];
    final failureData = {
      'time': realTime.toIso8601String(),
      'elapsedSeconds': 0, 
      'targetSeconds': prefs.getDouble('target_duration') ?? 300.0,
      'imagePath': null,
    };
    savedList.add(jsonEncode(failureData));
    await prefs.setStringList('archive_failures', savedList);
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const CultApp(),
    ),
  );
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

class CultApp extends ConsumerWidget {
  const CultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockoutStateAsync = ref.watch(lockoutProvider);

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
      home: lockoutStateAsync.when(
        data: (state) {
          if (state.status == LockoutStatus.locked) {
            return LockoutScreen(
              unlockTime: state.lockoutEnd!, 
              isManipulated: state.isManipulated
            );
          }
          final prefs = ref.read(sharedPreferencesProvider);
          final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;
          
          if (!hasCompletedOnboarding) {
            return const OnboardingScreen();
          }
          return const CanvasScreen();
        },
        loading: () => const Scaffold(backgroundColor: AppTheme.oledBlack),
        error: (err, stack) => DiagnosticApp(error: err.toString(), stack: stack.toString()),
      ),
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
            // Trigger refresh via provider
            WidgetsBinding.instance.addPostFrameCallback((_) {
               // Invalidate provider to re-evaluate lockout state
               ProviderScope.containerOf(context).invalidate(lockoutProvider);
            });
            return const SizedBox.shrink();
          }

          final h = _remaining.inHours.toString().padLeft(2, '0');
          final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
          final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
          
          final l10n = AppLocalizations.of(context);

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isManipulated && l10n != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Text(
                        l10n.timeManipulatedWarning,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.clinicalWhite,
                          height: 1.5,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                       .fadeIn(duration: 500.ms)
                       .then(delay: 2.seconds)
                       .tint(color: AppTheme.murderRed, duration: 300.ms),
                    ),
                  if (l10n != null)
                    Text(
                      l10n.lockoutCountdown(h, m, s),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.murderRed,
                        height: 1.5,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                     ).animate(key: ValueKey(s))
                      .shimmer(duration: 800.ms, color: AppTheme.clinicalWhite.withValues(alpha: 0.5))
                     .scaleXY(begin: 0.98, end: 1.0, duration: 200.ms, curve: Curves.easeOutBack),
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
