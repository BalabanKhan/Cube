import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @whyAreYouHere.
  ///
  /// In tr, this message translates to:
  /// **'YİNE NE İSTİYORSUN?'**
  String get whyAreYouHere;

  /// No description provided for @cannotWait.
  ///
  /// In tr, this message translates to:
  /// **'SÜREKLİ BİR ŞEYLERE DOKUNMAK ZORUNDASIN, DEĞİL Mİ?\nBEKLEMEKTEN ACİZSİN.'**
  String get cannotWait;

  /// No description provided for @contract1.
  ///
  /// In tr, this message translates to:
  /// **'BEN SENİN KÖLEN DEĞİLİM.'**
  String get contract1;

  /// No description provided for @contract2.
  ///
  /// In tr, this message translates to:
  /// **'Zamanını ben yönetmem, sen kendi zamanında benim sanatımı izlersin.'**
  String get contract2;

  /// No description provided for @contract3.
  ///
  /// In tr, this message translates to:
  /// **'Bana emir veremezsin. Sadece izleyebilirsin.'**
  String get contract3;

  /// No description provided for @contractAccept.
  ///
  /// In tr, this message translates to:
  /// **'TESLİM OL'**
  String get contractAccept;

  /// No description provided for @contractReject.
  ///
  /// In tr, this message translates to:
  /// **'GERİ DÖN'**
  String get contractReject;

  /// No description provided for @start.
  ///
  /// In tr, this message translates to:
  /// **'BAŞLA'**
  String get start;

  /// No description provided for @refuseInspiration0.
  ///
  /// In tr, this message translates to:
  /// **'O 15 saniyelik kısa videolarla erimiş beyninin bu tuvalin sessizliğini kaldırabileceğini mi sandın? Fırçamı senin o telaşlı, tükenmiş memur enerjinle kirletmeyeceğim. Git ekranını kaydırarak biraz daha uyuş, belki sonra gelirim.'**
  String get refuseInspiration0;

  /// No description provided for @refuseInspiration1.
  ///
  /// In tr, this message translates to:
  /// **'Bugün senin o ucuz odaklanma çabalarına eşlik edecek havamda değilim. Gözüm görmesin.'**
  String get refuseInspiration1;

  /// No description provided for @refuseInspiration2.
  ///
  /// In tr, this message translates to:
  /// **'O kısa videolarla erimiş beyninin bu sessizliği kaldırabileceğini düşünmem benim hatamdı.'**
  String get refuseInspiration2;

  /// No description provided for @refuseInspiration3.
  ///
  /// In tr, this message translates to:
  /// **'O 15 saniyelik kısa videolarla erimiş beyninin bu tuvalin sessizliğini kaldırabileceğini mi sandın? Fırçamı senin o telaşlı, tükenmiş memur enerjinle kirletmeyeceğim. Git ekranını kaydırarak biraz daha uyuş, belki sonra gelirim.'**
  String get refuseInspiration3;

  /// No description provided for @refuseInspiration4.
  ///
  /// In tr, this message translates to:
  /// **'Bugün senin o ucuz odaklanma çabalarına eşlik edecek havamda değilim. Gözüm görmesin.'**
  String get refuseInspiration4;

  /// No description provided for @vandalizedMsg0.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler. Zihnini uyuşturan o kusursuz algoritmaya yenik düştün. Pavloviç bir köpek gibi bildirim sesine koştun ve benim eserimi mahvettin. Şimdi git o ucuz dopaminin tadını çıkar, nasıl olsa hayatta biriktirebileceğin tek şey bu.'**
  String get vandalizedMsg0;

  /// No description provided for @vandalizedMsg1.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler. O çok acil (!) e-postan yüzünden bir şaheseri kendi ellerinle katlettin.'**
  String get vandalizedMsg1;

  /// No description provided for @vandalizedMsg2.
  ///
  /// In tr, this message translates to:
  /// **'Pavlov\'un sadık köpeği zili duydu ve koştu. Fırçamı midemi bulandırarak kırdın.'**
  String get vandalizedMsg2;

  /// No description provided for @vandalizedMsg3.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf, iradesiz ve sistemin kusursuz bir dişlisisin. Ekrana o pis parmaklarınla dokunma.'**
  String get vandalizedMsg3;

  /// No description provided for @vandalizedMsg4.
  ///
  /// In tr, this message translates to:
  /// **'Sistemin sana uzattığı o renkli emziği seçtin. Git ve uyuşmaya devam et.'**
  String get vandalizedMsg4;

  /// No description provided for @vandalizedMsg5.
  ///
  /// In tr, this message translates to:
  /// **'Saniyelik bir bildirim sesi uğruna sanatı sattın. Ne kadar da ucuzsun.'**
  String get vandalizedMsg5;

  /// No description provided for @vandalizedMsg6.
  ///
  /// In tr, this message translates to:
  /// **'Seni affedeceğimi mi sanıyorsun? Git biraz daha ekran kaydır, nasıl olsa tek yapabildiğin bu.'**
  String get vandalizedMsg6;

  /// No description provided for @vandalizedMsg7.
  ///
  /// In tr, this message translates to:
  /// **'Eserimi mahvettin. Senin için harcadığım her bir piksele lanet olsun.'**
  String get vandalizedMsg7;

  /// No description provided for @lockoutMsg.
  ///
  /// In tr, this message translates to:
  /// **'ŞAHESERİMİ MAHVETTİN. FIRÇAMI KIRDIN.\n\nBugün senin o ucuz odaklanma çabalarına eşlik etmeyeceğim.\nSaat {time} olduğunda gel, belki affederim.'**
  String lockoutMsg(String time);

  /// No description provided for @masterpieceCreated.
  ///
  /// In tr, this message translates to:
  /// **'BU ŞAHESER YARATILDI.'**
  String get masterpieceCreated;

  /// No description provided for @youJustBreathed.
  ///
  /// In tr, this message translates to:
  /// **'Bu kusursuz eser yaratılırken, cihazın sahibi sadece telefonu elinden bırakmayı başarabilen evrimleşmiş bir primat olarak bana sessizlik sağladı. Bunu kaydet ve internetteki o sanal sürüne göster de, seni \'iradeli\' sansınlar.'**
  String get youJustBreathed;

  /// No description provided for @saveAndLeave.
  ///
  /// In tr, this message translates to:
  /// **'BUNU KAYDET VE DEFOL'**
  String get saveAndLeave;

  /// No description provided for @leave.
  ///
  /// In tr, this message translates to:
  /// **'TERK ET'**
  String get leave;

  /// No description provided for @archive.
  ///
  /// In tr, this message translates to:
  /// **'UTANÇ GALERİSİ'**
  String get archive;

  /// No description provided for @statusVandalized.
  ///
  /// In tr, this message translates to:
  /// **'STATUS: VANDALIZED'**
  String get statusVandalized;

  /// No description provided for @crime.
  ///
  /// In tr, this message translates to:
  /// **'CRIME: Zayıf irade. Sistem arka plana itildi. Eser imha edildi.'**
  String get crime;

  /// No description provided for @time.
  ///
  /// In tr, this message translates to:
  /// **'TIME: {time}'**
  String time(String time);

  /// No description provided for @walkOfShame.
  ///
  /// In tr, this message translates to:
  /// **'Sistemin sana uzattığı o renkli emziği seçtin. Sana ayıracak tek bir fırça darbem bile yok. Beni kendi ellerinle kapat ve o çok sevdiğin \'yapılacaklar\' listene geri dön, küçük makine.'**
  String get walkOfShame;

  /// No description provided for @permissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Kendi şaheserini bile reddedecek kadar korkaksın.'**
  String get permissionDenied;

  /// No description provided for @tolerateTime0.
  ///
  /// In tr, this message translates to:
  /// **'Sana {minutes} dakika tahammül edeceğim. Otur ve sessizce izle.'**
  String tolerateTime0(String minutes);

  /// No description provided for @tolerateTime1.
  ///
  /// In tr, this message translates to:
  /// **'Bana {minutes} dakika borçlusun. Yerinden kıpırdama.'**
  String tolerateTime1(String minutes);

  /// No description provided for @tolerateTime2.
  ///
  /// In tr, this message translates to:
  /// **'Bugünlük {minutes} dakikanı gasp ettim. İşini unut.'**
  String tolerateTime2(String minutes);

  /// No description provided for @tolerateTime3.
  ///
  /// In tr, this message translates to:
  /// **'Tam {minutes} dakika boyunca tutsağımsın.'**
  String tolerateTime3(String minutes);

  /// No description provided for @tolerateTime4.
  ///
  /// In tr, this message translates to:
  /// **'Senin için {minutes} dakikalık bir hücre hazırladım.'**
  String tolerateTime4(String minutes);

  /// No description provided for @dontTouchWarning.
  ///
  /// In tr, this message translates to:
  /// **'Sanata dokunmaya cüret etme! İzle ve bekle.'**
  String get dontTouchWarning;

  /// No description provided for @enduredFor.
  ///
  /// In tr, this message translates to:
  /// **'Endured for {minutes} Minutes'**
  String enduredFor(String minutes);

  /// No description provided for @timeManipulatedWarning.
  ///
  /// In tr, this message translates to:
  /// **'Beni ucuz zaman hileleriyle kandırabileceğini mi sandın?\nİnfazın iki katına çıkarıldı.\nBekle ve çürü.'**
  String get timeManipulatedWarning;

  /// No description provided for @lockoutCountdown.
  ///
  /// In tr, this message translates to:
  /// **'İnfazın bitmesine {h}:{m}:{s} kaldı.\nGit.'**
  String lockoutCountdown(String h, String m, String s);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
