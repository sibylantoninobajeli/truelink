import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:truelink/screens/home_screen.dart';
import 'package:truelink/screens/product_check_screen.dart';
import 'globals.dart' as globals;
import 'package:truelink/screens/intro/intro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:truelink/localization/custom_localizations.dart';
import 'package:http/io_client.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
        /*GraphQLProvider(
        client: graphQLConfiguration.client,
        child: CacheProvider(child: MyApp()),
      ),*/
        TrueLinkApp());
  });
}

HttpClient client = new HttpClient()
  ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
IOClient ioClient = new IOClient(client);

class TrueLinkApp extends StatefulWidget {
  TrueLinkApp();

// This widget is the home page of your application. It is stateful, meaning
// that it has a State object (defined below) that contains fields that affect
// how it looks.

// This class is the configuration for the state. It holds the values (in this
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".

  @override
  _TrueLinkApp createState() => _TrueLinkApp();
}

class _TrueLinkApp extends State<TrueLinkApp> {
  bool firstAccess = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //globals.authStateProvider.subscribe(this);
    // permette di mostrare le Status Icons del telefono
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    globals.getCheckIsFirstAccess().then((isFirst) {
      setState(() {
        firstAccess = isFirst;
      });
    });

    if ((!globals.isRelease) && globals.resetDeviceStoredUser) {
      globals.clearPref();
    } else {
      globals.getPrivateRsaKeys();
      globals.getPublicRsaKeys();
    }

    //initUniLinks();
    //globals.authStateProvider.checkLogin();
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('it', 'IT'), // Italian
        // ... other locales the app supports
      ],
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        CustomLocalizationsDelegate(),
        const FallbackCupertinoLocalisationsDelegate(),

        GlobalMaterialLocalizations
            .delegate, // serve pr fare funzionare il form registration
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        //globals.localLog(runtimeType.toString()+"::"+_methodName, "localeResolutionCallback>Device locale  "+locale.languageCode+' '+locale.countryCode);
        globals.languageCode = locale.languageCode;

        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            //if (needDebug) globals.localLog(runtimeType.toString()+"::"+_methodName,  'returning '+supportedLocale.languageCode);
            return supportedLocale;
          }
        }
        //if (needDebug) globals.localLog(runtimeType.toString()+"::"+_methodName,  'returning '+supportedLocales.first.languageCode);
        return supportedLocales.first;
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: ProductCheckPage(title: 'TRuelink demo page'),

      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        // Shown when launched with plain intent.
        //'/': (BuildContext _context) => _screen,
        /*
        '/': (BuildContext _context) =>(globals.authStateProvider.getCurrAuthState()==AuthState.VERIFYING)
            ?
        Container(
            color: Colors.white,
            child: Stack( children: <Widget>[_bkgImg,new CircularProgressIndicator()])
        )
        :((globals.authStateProvider.getCurrAuthState()==AuthState.LOGGED_OUT)?Intro():_screen),
*/
        '/': (BuildContext _context) => firstAccess ? Intro() : HomeScreen(),
        '/intro': (BuildContext _context) => Intro(),
        '/home': (BuildContext _context) => HomeScreen(),
        '/principal': (BuildContext _context) => ProductCheckPage(),
        // Shown when launched with known deep link.
        '/reg': (BuildContext _context) =>
            Scaffold(body: new Center(child: new Text('Invite'))),
      },
    );
  }
}
