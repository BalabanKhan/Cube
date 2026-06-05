import 'package:flutter/material.dart';
import '../../features/onboarding/domain/cult_manifesto.dart';
import '../theme/app_theme.dart';

class DeadScreen extends StatefulWidget {
  final String? customMessage;
  const DeadScreen({super.key, this.customMessage});

  @override
  State<DeadScreen> createState() => _DeadScreenState();
}

class _DeadScreenState extends State<DeadScreen> {
  late String _message;
  bool _messageInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_messageInitialized) {
      _message = widget.customMessage ?? CultManifesto.getRandomDeathScreen(context);
      _messageInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Kilit: Geri tuşu çalışmaz
      child: Scaffold(
        backgroundColor: AppTheme.oledBlack,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text(
              _message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.murderRed,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
