import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../onboarding/domain/cult_manifesto.dart';

class HardwarePenaltyService {
  ScreenshotCallback? _screenshotCallback;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  /// Starts listening to active hardware events (battery charging, screenshot, screen recording)
  void startListeners({
    required BuildContext context,
    required bool Function() canTriggerPenalty,
    required void Function(String) onPenalty,
  }) {
    if (kIsWeb) return;

    // Battery Listener
    _batteryStateSubscription = Battery().onBatteryStateChanged.listen((BatteryState state) {
      if (!context.mounted) return;
      if (canTriggerPenalty() && state == BatteryState.charging) {
        onPenalty(CultManifesto.getChargingText(context));
      }
    });

    // Screenshot Listener
    _screenshotCallback = ScreenshotCallback();
    _screenshotCallback?.addListener(() {
      if (canTriggerPenalty()) {
        onPenalty(CultManifesto.getScreenshotText(context));
      }
    });

    // Screen Record Listener
    ScreenProtector.addListener(() {
      if (canTriggerPenalty()) {
        onPenalty(CultManifesto.getScreenRecordingText(context));
      }
    }, (bool isCaptured) {
      if (isCaptured && canTriggerPenalty()) {
        onPenalty(CultManifesto.getScreenRecordingText(context));
      }
    });
  }

  void stopListeners() {
    _screenshotCallback?.dispose();
    ScreenProtector.removeListener();
    _batteryStateSubscription?.cancel();
  }

  /// Checks static hardware/context conditions on startup
  /// Returns a penalty message if a violation is found, otherwise null
  Future<String?> checkStartupPenalties(BuildContext context) async {
    final now = DateTime.now();

    // Social Life Corpse
    if ((now.weekday == DateTime.friday || now.weekday == DateTime.saturday) && now.hour >= 22) {
      return CultManifesto.getSaturdayNightText(context);
    }

    // Myopia Abuse
    if (MediaQuery.textScalerOf(context).scale(14) > 16) {
      return CultManifesto.getMyopiaText(context);
    }

    if (!kIsWeb) {
      final battery = Battery();

      final isSaveMode = await battery.isInBatterySaveMode;
      if (!context.mounted) return null;
      if (isSaveMode) {
        return CultManifesto.getLowPowerText(context);
      }

      final level = await battery.batteryLevel;
      if (!context.mounted) return null;
      if (level < 15) {
        return CultManifesto.getDyingBatteryText(context);
      }
    }

    return null;
  }
}
