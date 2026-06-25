// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get whyAreYouHere => 'WHAT DO YOU WANT NOW?';

  @override
  String get cannotWait =>
      'YOU MUST ALWAYS BE TOUCHING SOMETHING, MUSTN\'T YOU?\nINCAPABLE OF WAITING.';

  @override
  String get contract1 => 'I AM NOT YOUR SERVANT.';

  @override
  String get contract2 =>
      'I do not manage your time. You watch my art on your own time.';

  @override
  String get contract3 => 'You cannot command me. You may only observe.';

  @override
  String get contractAccept => 'SURRENDER';

  @override
  String get contractReject => 'TURN BACK';

  @override
  String get start => 'COMMENCE';

  @override
  String get refuseInspiration0 =>
      'Did you genuinely believe your brain, liquefied by 15-second videos, could endure the silence of this canvas? I shall not soil my brush with your frantic, exhausted middle-management energy. Go scroll your screen and numb yourself further; perhaps I shall return later.';

  @override
  String get refuseInspiration1 =>
      'I am not in the mood to accompany your cheap attempts at focus today. Out of my sight.';

  @override
  String get refuseInspiration2 =>
      'It was my mistake to assume your liquefied brain could handle this silence.';

  @override
  String get refuseInspiration3 =>
      'Did you genuinely believe your brain, liquefied by 15-second videos, could endure the silence of this canvas? I shall not soil my brush with your frantic, exhausted middle-management energy. Go scroll your screen and numb yourself further; perhaps I shall return later.';

  @override
  String get refuseInspiration4 =>
      'I am not in the mood to accompany your cheap attempts at focus today. Out of my sight.';

  @override
  String get vandalizedMsg0 =>
      'Congratulations. You succumbed to that flawless algorithm numbing your mind. Like a Pavlovian dog, you ran to the notification bell and destroyed my work. Now go enjoy your cheap dopamine; it is, after all, the only thing you will ever accumulate in life.';

  @override
  String get vandalizedMsg1 =>
      'Congratulations. You slaughtered a masterpiece with your own hands for the sake of your terribly urgent (!) email.';

  @override
  String get vandalizedMsg2 =>
      'Pavlov\'s loyal dog heard the bell and ran. You broke my brush in a sickening display.';

  @override
  String get vandalizedMsg3 =>
      'Weak, will-less, and a flawless cog in the machine. Do not touch the screen with your filthy fingers.';

  @override
  String get vandalizedMsg4 =>
      'You chose the colourful pacifier handed to you by the system. Go and continue your stupor.';

  @override
  String get vandalizedMsg5 =>
      'You sold out art for a momentary notification ping. How remarkably cheap you are.';

  @override
  String get vandalizedMsg6 =>
      'You think I shall forgive you? Go scroll your screen a bit more; it is all you are capable of anyway.';

  @override
  String get vandalizedMsg7 =>
      'You ruined my work. Curse every single pixel I wasted on you.';

  @override
  String lockoutMsg(String time) {
    return 'YOU DESTROYED MY MASTERPIECE. YOU BROKE MY BRUSH.\n\nI shall not accompany your cheap attempts at focus today.\nReturn at $time, perhaps I shall forgive you.';
  }

  @override
  String get masterpieceCreated => 'THIS MASTERPIECE HAS BEEN CONJURED.';

  @override
  String get youJustBreathed =>
      'While this flawless work was created, the device owner merely provided silence as an evolved primate capable of putting down their phone. Save this and show it to your virtual herd so they might think you have \'willpower\'.';

  @override
  String get saveAndLeave => 'SAVE THIS AND GET OUT';

  @override
  String get leave => 'LEAVE';

  @override
  String get archive => 'GALLERY OF SHAME';

  @override
  String get statusVandalized => 'STATUS: VANDALIZED';

  @override
  String get crime =>
      'CRIME: Lack of willpower. System backgrounded. Artwork destroyed.';

  @override
  String time(String time) {
    return 'TIME: $time';
  }

  @override
  String get walkOfShame =>
      'You chose the colourful pacifier the system offered. I haven\'t a single brushstroke left to spare for you. Close me with your own hands and return to your beloved \'to-do\' list, little machine.';

  @override
  String get permissionDenied =>
      'You are cowardly enough to reject even your own masterpiece.';

  @override
  String tolerateTime0(String minutes) {
    return 'I shall tolerate you for $minutes minutes.';
  }

  @override
  String tolerateTime1(String minutes) {
    return 'I shall tolerate you for $minutes minutes.';
  }

  @override
  String tolerateTime2(String minutes) {
    return 'I shall tolerate you for $minutes minutes.';
  }

  @override
  String tolerateTime3(String minutes) {
    return 'I shall tolerate you for $minutes minutes.';
  }

  @override
  String tolerateTime4(String minutes) {
    return 'I shall tolerate you for $minutes minutes.';
  }

  @override
  String get dontTouchWarning => 'Do not dare touch the art! Observe and wait.';

  @override
  String enduredFor(String minutes) {
    return 'Endured for $minutes Minutes';
  }

  @override
  String get timeManipulatedWarning =>
      'Did you think you could fool me with cheap time tricks?\nYour execution has been doubled.\nWait and rot.';

  @override
  String lockoutCountdown(String h, String m, String s) {
    return 'You have $h:$m:$s left until your execution ends.\nLeave.';
  }
}
