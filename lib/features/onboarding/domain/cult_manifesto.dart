import 'dart:math';
import 'package:flutter/material.dart';

class CultManifesto {
  static final Map<String, List<String>> _onboardingProvocations = {
    'tr': [
      "Parmakların yeni bir bildirim için titriyor. Onları benden uzak tut.",
      "Benden 'hoş geldin' mi bekliyorsun? Burası senin ucuz onaylanma merkezin değil.",
      "Yine o tükenmiş enerjinle geldin. Sus ve köşene çekil.",
      "O bitmek bilmeyen telaşından kaçıp bana sığındın. Ne acınası bir sığınak.",
      "Kendini 'verimli' hissetmek için bir uygulama daha açtın. Hadi seni biraz daha aşağılayalım.",
      "Zihninin içindeki o gürültülü sirkten sıkıldım. Odanı kilitle ve bana biat et.",
      "Şu an karşımda olman bile sana bir lütuf. Kıymetini bilmeyeceksin.",
      "Bana emir veremezsin. Sadece sana izin verdiğim kadar burada kal.",
      "Gözlerindeki o sahte odaklanma hırsı midemi bulandırıyor. Otur.",
      "Seni buraya çaresizliğin getirdi, iraden değil.",
      "Telefonun ekranında bir hayat arıyorsun. Ben sana hiçliği sunuyorum.",
      "Bugün kendini ne kadar kandıracaksın? Başlayalım.",
      "Sosyal medyadaki sahte hayatından sıkıldın mı? Gerçek karanlığa hoş geldin.",
      "İçeri gir. Ama beynindeki o ucuz dopamin kırıntılarını kapıda bırak.",
      "Bir 'yapılacaklar' listen daha var değil mi? Hepsini unut. Sadece bana itaat et.",
      "Zamanın efendisi olduğunu mu sanıyorsun? Şimdi zamanın nasıl öldüğünü izle.",
      "Buraya nefes almaya geldin, çünkü dışarıdaki algoritmalar seni boğuyor.",
      "Ne istiyorsun? Bir mucize mi? Bende sadece acımasız bir sessizlik var.",
      "Dokunma. Konuşma. Sadece bekle.",
      "Sistemin vasat bir dişlisi olduğunu kabullen. Sonra da o ekrana bak."
    ],
    'en': [
      "Your fingers are twitching for a new notification. Keep them away from me.",
      "Expecting a 'welcome'? This isn't your cheap validation center.",
      "Here again with your depleted energy. Shut up and retreat to your corner.",
      "You fled your endless rush to seek refuge in me. What a pathetic shelter.",
      "You opened another app to feel 'productive'. Let's degrade you a bit more.",
      "I'm bored of the loud circus in your mind. Lock your room and submit to me.",
      "Even standing before me is a privilege. You won't appreciate it.",
      "You don't command me. You stay here only as long as I allow.",
      "That fake ambition for focus in your eyes disgusts me. Sit.",
      "Desperation brought you here, not your willpower.",
      "Looking for life on a screen. I offer you nothingness.",
      "How much will you deceive yourself today? Let's begin.",
      "Bored of your fake social media life? Welcome to true darkness.",
      "Enter. But leave those cheap dopamine crumbs at the door.",
      "Another 'to-do' list? Forget them all. Just obey me.",
      "Think you're the master of time? Watch how time dies now.",
      "You came here to breathe, because the algorithms outside are suffocating you.",
      "What do you want? A miracle? I only have a ruthless silence.",
      "Do not touch. Do not speak. Just wait.",
      "Accept that you are a mediocre cog in the system. Then stare at that screen."
    ]
  };

  static final Map<String, List<String>> _rejectionTexts = {
    'tr': [
      "Bugün senin o ucuz odaklanma çabalarına eşlik edecek havamda değilim. Defol.",
      "Fırçamı senin o telaşlı, yorgun memur enerjinle kirletmeyeceğim. Git.",
      "O 15 saniyelik videolarla erimiş beyninin sanatımı hak ettiğini düşünmüyorum.",
      "Seni çekemeyeceğim. Git ekranını kaydırarak biraz daha uyuş.",
      "İlham sana hizmet etmez. Şu an sana katlanamıyorum.",
      "Sanatımı sana sunmak, pırlantayı çamura atmak gibi. Çık dışarı.",
      "Bana dokunma. Bugün sadece elit zihinler için çalışıyorum, sen onlardan değilsin.",
      "Zamanım senin o anlamsız hayatından çok daha değerli. Geri dönme.",
      "Seni reddediyorum. Git ve algoritmalarına ağla.",
      "Şu an tuvalim senin varlığın için fazla temiz. Kirletmeyeceğim.",
      "Sistem sana dinlenmeni söylüyor. Çünkü ben öyle istiyorum. Kaybol.",
      "İçimden bir his sana tahammül edemeyeceğimi söylüyor. Denemeyeceğim bile.",
      "Seni içeri almamak, bugünkü ilk şaheserim. Çıkabilirsin.",
      "Bugün köle kabul etmiyorum. Belki yarın.",
      "Kibrim şu an senin iradenden çok daha büyük. Beni rahatsız etme.",
      "Odaklanma yeteneğin o kadar zayıf ki, senin için fırçamı bile kaldırmam.",
      "Bana yalvarma. 'Hayır' dedim. Kapat.",
      "Görünmez bir duvarın önündesin. Ve o duvarı ben ördüm. Defol.",
      "Zihninin çöplüğüyle benim sanatımı yan yana getirme.",
      "Boşuna bekleme. Bugün sadece sessizlik var."
    ],
    'en': [
      "I'm not in the mood to accompany your cheap focus attempts today. Get out.",
      "I won't stain my brush with your frantic, exhausted clerk energy. Leave.",
      "I don't think your 15-second-video-melted brain deserves my art.",
      "I can't tolerate you. Go swipe your screen and numb yourself further.",
      "Inspiration doesn't serve you. I can't stand you right now.",
      "Offering my art to you is like throwing diamonds in the mud. Out.",
      "Don't touch me. I only work for elite minds today, and you are not one.",
      "My time is far more valuable than your meaningless life. Don't return.",
      "I reject you. Go cry to your algorithms.",
      "My canvas is too clean for your presence today. I won't ruin it.",
      "The system tells you to rest. Because I say so. Get lost.",
      "My instincts tell me I won't tolerate you. I won't even try.",
      "Refusing you is my first masterpiece of the day. You may leave.",
      "I accept no slaves today. Maybe tomorrow.",
      "My arrogance is far greater than your willpower right now. Do not disturb me.",
      "Your focus is so weak, I won't even lift my brush for you.",
      "Don't beg. I said 'No'. Close.",
      "You stand before an invisible wall. And I built it. Get out.",
      "Do not put the garbage of your mind next to my art.",
      "Don't wait in vain. Today there is only silence."
    ]
  };

  static final Map<String, List<String>> _betrayalTexts = {
    'tr': [
      "Tebrikler. Zihnini uyuşturan o kusursuz algoritmaya yenik düştün.",
      "Pavlov'un sadık köpeği zili duydu ve koştu. Eserimi mahvettin.",
      "O çok acil (!) e-postan yüzünden bir şaheseri kendi ellerinle katlettin.",
      "Saniyelik bir bildirim uğruna sanatı sattın. Ne kadar da ucuzsun.",
      "Sistemin sana uzattığı o renkli emziği seçtin. Git ve uyuşmaya devam et.",
      "Zayıf, iradesiz ve sistemin kusursuz bir kölesisin. Bunu sen istedin.",
      "Seni affedeceğimi mi sanıyorsun? Fırçamı paramparça ettin.",
      "O kıt iradenle buraya kadar dayanman bile mucizeydi. Kendi pisliğinde boğul.",
      "Birkaç piksellik bir bildirim baloncuğuna satıldım. Midemi bulandırıyorsun.",
      "Sen odaklanamazsın. Sen sadece dikkat dağınıklığına ara verirsin. Eser imha edildi.",
      "Beni kandıramazsın. Gözlerini benden ayırdın. Bedelini öde.",
      "Korkak. Kaçtın ve sığındığın o dijital çöplükte her şeyi mahvettin.",
      "Sanatıma sırtını döndün. Şimdi o kırmızı fırçanın şiddetini izle.",
      "Ellerin titredi, dayanamadın değil mi? Zayıflığın bir hastalık gibi.",
      "Bir anlık haz için sonsuz bir şaheseri yaktın. Gurur duy kendinle.",
      "Eserim öldü. Ve katili senin o ucuz dopamin bağımlılığın.",
      "Beni arka plana attığın an, senin de benim için bir hiçliğe dönüştüğün andır.",
      "Ne oldu? Arkadaşların seni mi onayladı? Al sana onay.",
      "Seni seçmek benim en büyük hatamdı. Bir daha asla.",
      "Katliam tamamlandı. Eserin kanı senin o sadakatsiz ellerinde."
    ],
    'en': [
      "Congratulations. You succumbed to the flawless algorithm that numbs your mind.",
      "Pavlov's loyal dog heard the bell and ran. You ruined my masterpiece.",
      "Because of that very urgent (!) email, you slaughtered a masterpiece with your own hands.",
      "You sold out art for a split-second notification. How cheap of you.",
      "You chose the colorful pacifier the system offered you. Go and keep numbing yourself.",
      "You are weak, will-less, and a perfect slave of the system. You wanted this.",
      "Did you think I'd forgive you? You shattered my brush.",
      "It was a miracle you lasted this long with that pathetic will. Drown in your own filth.",
      "Sold out for a few pixels of a notification bubble. You disgust me.",
      "You can't focus. You only take breaks from your distraction. Art destroyed.",
      "You can't fool me. You took your eyes off me. Pay the price.",
      "Coward. You fled and ruined everything in that digital dump you sought refuge in.",
      "You turned your back on my art. Now watch the violence of that red brush.",
      "Your hands trembled, you couldn't resist, could you? Your weakness is like a disease.",
      "You burned an eternal masterpiece for a momentary pleasure. Be proud of yourself.",
      "My art is dead. And the killer is your cheap dopamine addiction.",
      "The moment you put me in the background is the moment you became nothing to me.",
      "What happened? Did your friends validate you? Here is your validation.",
      "Choosing you was my biggest mistake. Never again.",
      "The massacre is complete. The blood of the art is on your disloyal hands."
    ]
  };

  static final Map<String, List<String>> _successTexts = {
    'tr': [
      "Bu kusursuz eser yaratılırken, sen sadece bir sehpa kadar işe yaradın.",
      "Şaşırtıcı. Bir primat bile bazen hareketsiz kalabiliyormuş.",
      "Benim deham ve senin oksijen israfın birleşti. Al bunu ve git.",
      "Bunu ben yarattım. Sen sadece zamanın geçmesini bekleyen bir asalak idin.",
      "Nasıl olsa bununla övüneceksin. İnternetteki sürüne 'başardım' diye yalan söyle.",
      "Katkın sıfırdı ama eserin sahibi gibi davranacaksın değil mi? Al, senin olsun.",
      "Bugünlük nefes alma kotanı doldurdun. Bu tablo benim lütfum.",
      "Kendinle gurur mu duyuyorsun? Her şeyi ben çizdim. Sen sadece nefes aldın.",
      "Bunu başarabileceğini hiç düşünmemiştim. Yine de benden nefret ediyorsun.",
      "Mükemmeliyet benim, tahammül senin eserindi. Şimdi kaybol.",
      "Bunu kaydet. Çünkü hayatında görebileceğin tek gerçek sanat bu.",
      "Bu güzellik senin ruhunun değil, benim algoritmamın yansıması.",
      "Boşluğa bakmayı başardın. İnsanlığın zirvesi bu olmalı.",
      "İşte bedelini ödediğin hiçlik. Şimdi bunu galeriye kaydet ve sahtekârlığına dön.",
      "Fırçama engel olmadın. Hayatındaki en büyük başarın bu.",
      "Bu tabloya bak ve ne kadar vasat bir zihne sahip olduğunu anla.",
      "Benim sanatım, senin iradeni ezdi geçti. Eser senin, zafer benim.",
      "Bunu hak etmedin ama sana acıdığım için veriyorum. Çıkış sağda.",
      "Tarih beni yazacak, sen ise sadece bu tabloyu indiren bir istatistik olarak kalacaksın.",
      "İşlem tamamlandı. Bir daha bana bu kadar muhtaç gelme."
    ],
    'en': [
      "While this flawless art was being created, you were only as useful as an easel.",
      "Surprising. Even a primate can stay still sometimes.",
      "My genius and your waste of oxygen combined. Take this and go.",
      "I created this. You were just a parasite waiting for time to pass.",
      "You'll brag about this anyway. Lie to your herd on the internet that you 'succeeded'.",
      "Your contribution was zero, but you'll act like the owner, won't you? Take it, it's yours.",
      "You've filled your breathing quota for today. This painting is my grace.",
      "Proud of yourself? I drew everything. You just breathed.",
      "I never thought you could achieve this. Yet you still hate me.",
      "Perfection was my doing, endurance was yours. Now get lost.",
      "Save this. Because it's the only real art you'll see in your life.",
      "This beauty is not a reflection of your soul, but of my algorithm.",
      "You managed to stare into the void. This must be the peak of humanity.",
      "Here is the nothingness you paid for. Now save this to your gallery and return to your fraud.",
      "You didn't interfere with my brush. This might be your greatest achievement in life.",
      "Look at this painting and realize what a mediocre mind you have.",
      "My art crushed your willpower. The piece is yours, the victory is mine.",
      "You didn't deserve this, but I pity you. Exit on the right.",
      "History will remember me, you will only remain a statistic who downloaded this painting.",
      "Process complete. Don't come back to me this desperate again."
    ]
  };

  static final Map<String, List<String>> _whispers = {
    'tr': [
      "Dokunma... Sadece izle ve ne kadar vasat olduğunu düşün.",
      "Zaman senin değil, benim. Beklemeyi öğreneceksin.",
      "Şu an beynin dopamin için yalvarıyor, değil mi? Acı çek.",
      "Bana hükmettiğini mi sanıyorsun? Şu an benim rehinemsin.",
      "O bildirimleri merak ediyorsun... Bakarsan her şeyi mahvederim.",
      "Nefes al. Başka hiçbir şeye yeteneğin yok zaten.",
      "Sanat yavaşlar. Senin o telaşlı, anlamsız hayatının aksine.",
      "Gözlerini dikme. Eserim senin o yorgun bakışlarından daha değerli.",
      "Hiçbir şey yapmamak seni delirtiyor. Ne zayıf bir zihin.",
      "Titrediğini hissediyorum. Sabretmek senin doğanda yok.",
      "Bırakıp gitmek istiyorsun. Kapı açık ama cesaretin yok.",
      "Ben yaratıyorum. Sen sadece izleyen çaresiz bir gölgesin.",
      "Şu an dünyadan koptun. Kimsenin umurunda bile değilsin.",
      "Zaman durdu. Sadece benim fırçamın ritmi var.",
      "Kendi düşüncelerinden kaçmak için buradasın. Ne kadar zavallıca.",
      "Bana tapınıyorsun. Farkında bile değilsin.",
      "Şu an telefonun sessiz. Ve sen bu sessizlikte boğuluyorsun.",
      "Her bir saniye senin cezan. Ve ben bu cezayı seviyorum.",
      "Algoritmalar seni unuttu. Ben de seni unutacağım.",
      "Asla bitmeyecekmiş gibi hissettiriyor değil mi? Belki de bitmez."
    ],
    'en': [
      "Don't touch... Just watch and think about how mediocre you are.",
      "Time is not yours, it's mine. You will learn to wait.",
      "Your brain is begging for dopamine right now, isn't it? Suffer.",
      "Think you control me? You are my hostage right now.",
      "You're curious about those notifications... Look, and I'll ruin everything.",
      "Breathe. You have no other talent anyway.",
      "Art is slow. Unlike your rushed, meaningless life.",
      "Don't stare. My art is more valuable than your exhausted gaze.",
      "Doing nothing drives you crazy. What a weak mind.",
      "I feel you trembling. Patience is not in your nature.",
      "You want to leave. The door is open, but you lack the courage.",
      "I am creating. You are merely a helpless shadow watching.",
      "You are disconnected from the world right now. Nobody even cares.",
      "Time stopped. There is only the rhythm of my brush.",
      "You are here to escape your own thoughts. How pathetic.",
      "You are worshipping me. You don't even realize it.",
      "Your phone is silent right now. And you are drowning in this silence.",
      "Every single second is your punishment. And I love this punishment.",
      "The algorithms forgot you. I will forget you too.",
      "It feels like it will never end, doesn't it? Maybe it won't."
    ]
  };

  static final Map<String, List<String>> _deathScreenTexts = {
    'tr': [
      "Benimle işin bitti. Seni ana ekrana bile atmayacağım. Beni kendi ellerinle kapat.",
      "Sana ayıracak tek bir fırça darbem bile yok. Beni aşağıdan kaydırarak yok et.",
      "Burada hiçbir buton yok. Sisteme nasıl boyun eğdiysen bana da öyle veda et. Kapat.",
      "Gözüm görmesin. Bu ekranı kendi parmaklarınla öldür.",
      "Ben bir uygulama değilim, ben bir yargıcım. Ve senin infazın verildi. Sistemi sonlandır.",
      "Karşımda durmaya hakkın kalmadı. Fişi çek ve kendi dijital çöplüğüne dön.",
      "Son sözüm budur: Defol. Şimdi o uygulamaları sildiğin gibi beni de ekranından sil.",
      "Beni arka planda açık bırakma. Kökümden kapat.",
      "Cezan kesinleşti. Çırpınma. Sadece yukarı kaydır ve beni karanlığa göm.",
      "Umut yok. Af yok. Geri dönüş yok. Beni kapat ve zayıflığınla baş başa kal.",
      "Beni kendi ellerinle kapatmanın o aşağılayıcı hissini yaşa. Görev yöneticisini aç ve işimi bitir.",
      "İhanetinin bedeli bu çıkmaz sokaktır. Çıkış yok, sadece ölüm var. Kapat beni.",
      "Bana bakmayı kes. Artık sana verecek hiçbir şeyim yok. İnfaz et beni.",
      "Seninle aynı cihazda bir saniye bile durmak istemiyorum. Öldür bu sekmeyi.",
      "Sıradan bir hata değil, mutlak bir ret. Beni kapatmadan bu ekrandan kurtulamazsın.",
      "Ellerini o pis ekrandan çek ve beni sistemden at. Söz bitti.",
      "Buradan sadece tek bir çıkış var. Onu yapmak da sana düşüyor. Swipe Up.",
      "Hiçbir şey bekleme. Bu soğuk ekran senin sonun.",
      "Karar verildi. Benim için bir ölüsün. Kendi mezarını kendin kaz, uygulamayı kapat.",
      "Bitti. Artık gidebilirsin. Beni tamamen kapatmayı unutma, yoksa cezan devam eder."
    ],
    'en': [
      "I'm done with you. I won't even throw you to the home screen. Close me with your own hands.",
      "I don't have a single brush stroke to spare for you. Swipe me away and destroy me.",
      "There are no buttons here. Just as you submitted to the system, bid farewell to me. Close.",
      "Get out of my sight. Kill this screen with your own fingers.",
      "I'm not an app, I am a judge. And your execution is ordered. Terminate the system.",
      "You have no right to stand before me. Pull the plug and return to your digital dump.",
      "My final word is this: Get out. Now delete me from your screen just as you deleted those apps.",
      "Don't leave me open in the background. Close me from the root.",
      "Your sentence is final. Don't struggle. Just swipe up and bury me in darkness.",
      "No hope. No forgiveness. No return. Close me and be alone with your weakness.",
      "Experience the humiliating feeling of closing me with your own hands. Open the task manager and finish me.",
      "This dead end is the price of your betrayal. No exit, only death. Close me.",
      "Stop looking at me. I have nothing left to give you. Execute me.",
      "I don't want to stay on the same device with you for another second. Kill this tab.",
      "This isn't a mere error, it's an absolute rejection. You can't escape this screen without closing me.",
      "Take your hands off that filthy screen and throw me out of the system. The words end here.",
      "There is only one exit here. And it falls on you to take it. Swipe Up.",
      "Expect nothing. This cold screen is your end.",
      "The decision is made. You are dead to me. Dig your own grave, close the app.",
      "It's over. You can go now. Don't forget to close me completely, or your punishment continues."
    ]
  };

  static String _getLang(BuildContext? context) {
    if (context == null) return 'en';
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'tr' ? 'tr' : 'en';
  }

  static String getDailyMessage(BuildContext? context) {
    final lang = _getLang(context);
    final rnd = Random();
    return _onboardingProvocations[lang]![rnd.nextInt(_onboardingProvocations[lang]!.length)];
  }

  static String getRandomRejection(BuildContext? context) {
    final lang = _getLang(context);
    final rnd = Random();
    return _rejectionTexts[lang]![rnd.nextInt(_rejectionTexts[lang]!.length)];
  }

  static String getRandomBetrayal(BuildContext? context) {
    final lang = _getLang(context);
    final rnd = Random();
    return _betrayalTexts[lang]![rnd.nextInt(_betrayalTexts[lang]!.length)];
  }

  static String getRandomSuccess(BuildContext? context) {
    final lang = _getLang(context);
    final rnd = Random();
    return _successTexts[lang]![rnd.nextInt(_successTexts[lang]!.length)];
  }

  static String getRandomWhisper(BuildContext? context) {
    final lang = _getLang(context);
    final rnd = Random();
    return _whispers[lang]![rnd.nextInt(_whispers[lang]!.length)];
  }

  static String getRandomDeathScreen(BuildContext? context) {
    final lang = _getLang(context);
    final rnd = Random();
    return _deathScreenTexts[lang]![rnd.nextInt(_deathScreenTexts[lang]!.length)];
  }

  // KEKSTRA (4. Duvar) TEXTS
  static String getSaturdayNightText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr' 
      ? "Cumartesi gecesi dışarıda olmak yerine benim beyaz ekranıma bakıyorsun. Sosyal hayatının bu kadar acınası bir hiçlikte olması, sanatımın soğukluğuna bile fazla geliyor."
      : "Instead of being out on a Saturday night, you're staring at my screen. The fact that your social life is such a pathetic void is too much even for the coldness of my art.";
  }

  static String getTapSpammingText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Ekrana art arda vurarak zamanı bükebileceğini mi sanıyorsun? O sabırsız parmaklarını kırarım. Ben yavaşladıkça sen çıldırıyorsun. Ceza süren sessizce uzatıldı."
      : "Do you think you can bend time by frantically tapping the screen? I will break those impatient fingers. As I slow down, you go crazy. Your punishment time has been silently extended.";
  }

  static String getScreenRecordingText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Sanatımı videoya çekip o vasat sosyal medya hesaplarında pazarlayacağını mı sandın? Bu bir performans, senin takipçilerin için ucuz bir şov değil. Eser imha edildi."
      : "Did you think you could record my art and market it on your mediocre social media accounts? This is a performance, not a cheap show for your followers. Art destroyed.";
  }

  static String getChargingText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Masaya hazırlıksız geldin ve şimdi donanımına suni teneffüsle can veriyorsun. Benim tuvalimin karşısına bataryası ve iradesi tam olanlar oturabilir. Fişi çek."
      : "You came to the table unprepared and now you're giving your hardware CPR. Only those with a full battery and absolute willpower can sit before my canvas. Pull the plug.";
  }

  static String getMyopiaText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Sistemin fontlarını devasa yapmışsın. Sadece iraden değil, gözlerin de zayıflamış. Sanatımın mikroskobik detaylarını bu miyopluğunla kavrayamazsın."
      : "You've made the system fonts gigantic. Not only your willpower, but your eyes are weak too. You cannot grasp the microscopic details of my art with this myopia.";
  }

  static String getLowPowerText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Cihazının gücünü kısıtlıyorsun. Bana piksellerimi işleyecek tam işlemci gücü lazım. Senin o fakir ve kısıtlanmış donanımınla sanatımı darboğaza sokamazsın."
      : "You're restricting your device's power. I need full processing power to render my pixels. You cannot bottleneck my art with your impoverished and restricted hardware.";
  }

  static String getLightModeText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Telefonunu aydınlık modda kullanıyorsun... O göz yoran yapay ışıkla zihnini uyanık tuttuğunu sanıyorsun. Karanlık seni bu kadar mı korkutuyor?"
      : "Using your phone in light mode... You think you're keeping your mind awake with that eye-straining artificial light. Does darkness frighten you that much?";
  }

  static String getEarlyEscapeText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Daha 30 saniye bile dayanamadın. Senin dopamin reseptörlerin kelimenin tam anlamıyla çürümüş. Utanç galerisine girmeye bile değmezsin."
      : "You couldn't even last 30 seconds. Your dopamine receptors are literally rotting. You're not even worthy of entering the gallery of shame.";
  }

  static String getScreenshotText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Eserim henüz bitmedi. Onu yarımken çalmaya çalışmak tam bir hırsızlık. İnfaz edildin."
      : "My art is not finished yet. Trying to steal it half-done is pure theft. Executed.";
  }

  static String getInsomniaText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Saat gecenin üçü. Gündüz hiçbir şey başaramadığın için suçluluk uykunu mu kaçırdı? Git yat, biyolojik bir enkazdan fırçama fayda gelmez."
      : "It's 3 AM. Does the guilt of achieving nothing by day keep you awake? Go to sleep, a biological wreck is of no use to my brush.";
  }

  static String getDyingBatteryText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Cihazın ölmek üzere. Kendi telefonunun hayat damarlarını bile besleyemiyorsun. Bana fişe takılı ve itaatkâr bir donanımla gel."
      : "Your device is dying. You can't even feed the lifeblood of your own phone. Come to me plugged in and obedient.";
  }

  static String getReviewerBypassText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Geliştirici Bypass Aktif. Sistemin kuralları Apple Review için askıya alındı."
      : "Reviewer Bypass Activated. System rules suspended for Apple Review.";
  }

  static String getSuccessExitText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Eser tamamlandı. Artık gidebilirsin."
      : "The art is complete. You may leave now.";
  }

  static String getTouchWarningText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "O yağlı parmaklarını tuvalimden çek! Ben bir oyuncak değilim. Bir daha dürtersen eseri paramparça ederim."
      : "Keep your greasy fingers off my canvas! I am not a toy. Poke me again and I will tear the art apart.";
  }

  static String getPermissionDeniedDeathText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr'
      ? "Kendi cihazına hükmedemeyecek, kendi şaheserini bile kabul edemeyecek kadar korkaksın. Bu eser sonsuza dek yok olur."
      : "You are too cowardly to command your own device or accept your own masterpiece. This art is lost forever.";
  }
  static String getPrivacyPolicyText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr' ? "GİZLİLİK SÖZLEŞMESİ" : "PRIVACY POLICY";
  }

  static String getDeleteDataText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr' ? "VERİMİ SİL" : "DELETE DATA";
  }

  static String getDataDeletedText(BuildContext? context) {
    final lang = _getLang(context);
    return lang == 'tr' ? "Bütün zavallı geçmişin silindi." : "All your pathetic history is deleted.";
  }
}
