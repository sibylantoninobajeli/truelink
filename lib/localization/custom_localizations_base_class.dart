import 'custom_localizations_static_map.dart' as static_loc;
import 'package:flutter/material.dart';
class CustomLocalizationsBaseClass {
CustomLocalizationsBaseClass(this.locale);
final Locale locale;
  String get title {return static_loc.localizedValues[locale.languageCode]['title']; }
  String get chooserProductCheckMex {return static_loc.localizedValues[locale.languageCode]['chooserProductCheckMex']; }
String get tutorial1Mex1 {return static_loc.localizedValues[locale.languageCode]['tutorial1Mex1']; }
String get tutorial1Mex2 {return static_loc.localizedValues[locale.languageCode]['tutorial1Mex2']; }
String get tutorial1Mex3 {return static_loc.localizedValues[locale.languageCode]['tutorial1Mex3']; }
}