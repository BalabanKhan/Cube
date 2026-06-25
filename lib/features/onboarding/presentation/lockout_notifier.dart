import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ntp/ntp.dart';
import '../../../core/db/app_database.dart';
import '../../../core/constants/app_constants.dart';

enum LockoutStatus { loading, locked, unlocked }

class LockoutState {
  final LockoutStatus status;
  final DateTime? lockoutEnd;
  final bool isManipulated;

  const LockoutState({
    this.status = LockoutStatus.loading,
    this.lockoutEnd,
    this.isManipulated = false,
  });

  LockoutState copyWith({
    LockoutStatus? status,
    DateTime? lockoutEnd,
    bool? isManipulated,
  }) {
    return LockoutState(
      status: status ?? this.status,
      lockoutEnd: lockoutEnd ?? this.lockoutEnd,
      isManipulated: isManipulated ?? this.isManipulated,
    );
  }
}

class LockoutNotifier extends AsyncNotifier<LockoutState> {
  @override
  Future<LockoutState> build() async {
    return _checkLockoutStatus();
  }

  Future<LockoutState> _checkLockoutStatus() async {
    final db = AppDatabase.instance;
    DateTime realTime = DateTime.now().toUtc();
    bool timeManipulated = false;

    try {
      final ntpTime = await NTP.now(timeout: const Duration(seconds: AppConstants.ntpTimeoutSeconds));
      realTime = ntpTime.toUtc();
      final localTime = DateTime.now().toUtc();
      if (realTime.difference(localTime).inMinutes.abs() > AppConstants.maxTimeDriftMinutes) {
        timeManipulated = true;
      }
    } catch (_) {}

    final lockoutTimeString = await db.getValue('lockout_end_time');
    final timeManipulatedFlagStr = await db.getValue('time_manipulated_flag');
    bool hasManipulatedFlag = timeManipulatedFlagStr == 'true';

    if (lockoutTimeString != null) {
      final lockoutEnd = DateTime.parse(lockoutTimeString);
      if (realTime.isBefore(lockoutEnd)) {
        if (timeManipulated && !hasManipulatedFlag) {
          // Double the penalty
          final doubledPenalty = realTime.add(const Duration(hours: AppConstants.timeManipulationPenaltyHours));
          await db.setValue('lockout_end_time', doubledPenalty.toIso8601String());
          await db.setValue('time_manipulated_flag', 'true');
          return LockoutState(
            status: LockoutStatus.locked,
            lockoutEnd: doubledPenalty,
            isManipulated: true,
          );
        }
        return LockoutState(
          status: LockoutStatus.locked,
          lockoutEnd: lockoutEnd,
          isManipulated: hasManipulatedFlag,
        );
      } else {
        await db.removeValue('lockout_end_time');
        await db.removeValue('time_manipulated_flag');
      }
    }
    
    return const LockoutState(status: LockoutStatus.unlocked);
  }

  Future<void> applyPenalty() async {
    final db = AppDatabase.instance;
    DateTime realTime = DateTime.now().toUtc();
    try {
      final ntpTime = await NTP.now(timeout: const Duration(seconds: AppConstants.ntpTimeoutSeconds));
      realTime = ntpTime.toUtc();
    } catch (_) {}

    final penaltyEnd = realTime.add(const Duration(hours: AppConstants.forceKillPenaltyHours));
    await db.setValue('lockout_end_time', penaltyEnd.toIso8601String());
    
    state = AsyncData(LockoutState(
      status: LockoutStatus.locked,
      lockoutEnd: penaltyEnd,
      isManipulated: false,
    ));
  }
}

final lockoutProvider = AsyncNotifierProvider<LockoutNotifier, LockoutState>(() {
  return LockoutNotifier();
});
