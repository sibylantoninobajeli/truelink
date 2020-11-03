
// A simple example of localizing a Flutter app written with the
// Dart intl package (see https://pub.dartlang.org/packages/intl).
//
// Spanish and English (locale language codes 'en' and 'es') are
// supported.

// The pubspec.yaml file must include flutter_localizations and the
// Dart intl packages in its dependencies section. For example:
//
// dependencies:
//   flutter:
//   sdk: flutter
//  flutter_localizations:
//    sdk: flutter
//  intl: 0.15.1
//  intl_translation: 0.15.0

// If you run this app with the device's locale set to anything but
// English or Spanish, the app's locale will be English. If you
// set the device's locale to Spanish, the app's locale will be
// Spanish.

import 'dart:async';
import 'package:flutter/material.dart';
import 'custom_localizations_static_map.dart' as static_loc;
import '../globals.dart' as globals;
import 'custom_localizations_base_class.dart';
import 'package:flutter/cupertino.dart';

//import 'package:intl/intl.dart';

// This file was generated in two steps, using the Dart intl tools. With the
// app's root directory (the one that contains pubspec.yaml) as the current
// directory:
//
// flutter pub get
// ../../Documents/FlutterSDK/flutter/bin/flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/main.dart
// ../../Documents/FlutterSDK/flutter/bin/flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/custom_localizations.dart lib/l10n/intl_*.arb
//
// The second command generates intl_messages.arb and the third generates
// messages_all.dart. There's more about this process in
// https://pub.dartlang.org/packages/intl.
//import 'package:flutter_app_test_ios/l10n/messages_all.dart';


class CustomLocalizations extends CustomLocalizationsBaseClass{
  CustomLocalizations(locale):super(locale);


  static CustomLocalizations of(BuildContext context) {
    return Localizations.of<CustomLocalizations>(
        context, CustomLocalizations);
  }

  messaggioRegBirthdayErrMex(int val) {
    return static_loc.localizedValues[locale.languageCode]['regBirthdayErrMex'].replaceFirst("{p1}", val.toString());
  }

  messaggioFiledMustContainXCharAdv(int val) {
    return static_loc.localizedValues[locale.languageCode]['filedMustContainXCharAdv'].replaceFirst("{p1}", val.toString());
  }

  messaggioMinCharsLengthMex(name) {
    return static_loc.localizedValues[locale.languageCode]['minCharsLengthMex'].replaceFirst("{p1}", name);
  }


  messaggioAttesaPubblicazioneVideoExtra(name) {
    return static_loc.localizedValues[locale.languageCode]['infoPublishExtraVideoMex'].replaceFirst("{p1}", name);
  }


  messaggioAttesaPubblicazione(name) {
    return static_loc.localizedValues[locale.languageCode]['infoPublishWaitMex'].replaceFirst("{p1}", name);
  }


messaggioPuntiUtente(name) {
    return static_loc.localizedValues[locale.languageCode]['puntiUtenteMessage'].replaceFirst("{p1}", name);
  }


  messaggioBenvenuto(name) {
    return static_loc.localizedValues[locale.languageCode]['greetingMessage'].replaceFirst("{p1}", name);





/*
    return Intl.message(
        "Hello $name!",
        name: "greetingMessage",
        args: [name],
        desc: "Greet the user as they first open the application",
        examples: const {'name': "Emily"});*/
  }

  messaggioMinUsernameLengthMex(charLimit) {
    return static_loc.localizedValues[locale.languageCode]['minUsernameLengthMex']
        .replaceFirst("{p1}", charLimit);
  }



    radarLocationMessage(location) {
    return static_loc.localizedValues[locale.languageCode]['radar_location'].replaceFirst("{p1}", location);
  }



}


class CustomLocalizationsDelegate extends LocalizationsDelegate<CustomLocalizations> {
  //const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['it', 'en'].contains(locale.languageCode);

  @override
  Future<CustomLocalizations> load(Locale locale) async {
    final String _methodName="load";
    globals.localLog(runtimeType.toString()+"::"+_methodName, "load $locale");

    CustomLocalizations locs=  CustomLocalizations(locale);

    globals.localLog(runtimeType.toString()+"::"+_methodName, "Load ${locale.languageCode} "+locs.title);
    return locs;
  }


  @override
  bool shouldReload(CustomLocalizationsDelegate old) => false;
}


class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}



