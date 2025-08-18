import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/day_unit_type.dart';

import '../../data/models/appLanguage.dart';

const String googleMapKey = '';

//app bar size
const double appBarSize = 60;

var appLanguage  = [
  AppLanguage('English', 'English', 'en',''),
  AppLanguage('العربية', 'Arabic', 'ar',''),
  AppLanguage('Afrikaans', 'Afrikaans', 'af',''),
  AppLanguage('Shqip', 'Albanian', 'sq',''),
  AppLanguage('ኢትዮጵያ', 'Amheric', 'am',''),
  AppLanguage('Azərbaycan dili', 'Azerbaijani', 'az',''),
  AppLanguage('বাংলাদেশ', 'Bangla', 'bn',''),
  AppLanguage('България', 'Bulgarian', 'bg',''),
  AppLanguage('Català', 'Catalan', 'ca',''),
  AppLanguage('简体中文', 'Simplified Chinese', 'zh','CN'),
  AppLanguage('繁體中文 - 香港', 'Traditional Chinese - Hong Kong', 'zh','HK'),
  AppLanguage('繁體中文 - 台灣', 'Traditional Chinese - Taiwan', 'zh','TW'),
  AppLanguage('Hrvatski', 'Croatian', 'hr',''),
  AppLanguage('Čeština', 'Czech', 'cs',''),
  AppLanguage('Dansk', 'Danish', 'da',''),
  AppLanguage('Nederlands', 'Dutch', 'nl',''),
  AppLanguage('Eesti', 'Estonian', 'et',''),
  AppLanguage('Filipino', 'Filipino', 'fil',''),
  AppLanguage('Suomi', 'Finnish', 'fi',''),
  AppLanguage('Français', 'French', 'fr',''),
  AppLanguage('Deutsch', 'German', 'de',''),
  AppLanguage('Ελληνικά', 'Greek', 'el',''),
  AppLanguage('ગુજરાતી', 'Gujarati', 'gu',''),
  AppLanguage('हिन्दी', 'Hindi', 'hi',''),
  AppLanguage('Magyar', 'Hungarian', 'hu',''),
  AppLanguage('Bahasa Indonesia', 'Indonesian', 'id',''),
  AppLanguage('Italiano', 'Italian', 'it',''),
  AppLanguage('日本語', 'Japanese', 'ja',''),
  AppLanguage('ಕನ್ನಡ', 'Kannada', 'kn',''),
  AppLanguage('қазақ тілі', 'Kazakh', 'kk',''),
  AppLanguage('한국어', 'Korean', 'ko',''),
  AppLanguage('ລາວ', 'Lao', 'lo',''),
  AppLanguage('Latviešu', 'Latvian', 'lv',''),
  AppLanguage('Lietuvių', 'Lithuanian', 'lt',''),
  AppLanguage('Mакедонски', 'Macedonian', 'mk',''),
  AppLanguage('Melayu', 'Malay', 'ms',''),
  AppLanguage('മലയാളം', 'Malayalam', 'ml',''),
  AppLanguage('मराठी', 'Marathi', 'mr',''),
  AppLanguage('Norsk bokmål', 'Norwegian Bokmål', 'nb',''),
  AppLanguage('فارسي', 'Persian', 'fa',''),
  AppLanguage('Polski', 'Polish', 'pl',''),
  AppLanguage('Português - Brasil', 'Portuguese - Brazil', 'pt','BR'),
  AppLanguage('Português - Portugal', 'Portuguese - Portugal', 'pt','PT'),
  AppLanguage('ਪੰਜਾਬੀ', 'Punjabi', 'pa',''),
  AppLanguage('Română', 'Romanian', 'ro',''),
  AppLanguage('Русский', 'Russian', 'ru',''),
  AppLanguage('Cрпски', 'Serbian', 'sr',''),
  AppLanguage('Slovenčina', 'Slovak', 'sk',''),
  AppLanguage('Slovenščina', 'Slovenian', 'sl',''),
  AppLanguage('Español', 'Spanish', 'es',''),
  AppLanguage('Kiswahili', 'Swahili', 'sw',''),
  AppLanguage('Svenska', 'Swedish', 'sv',''),
  AppLanguage('தமிழ்', 'Tamil', 'ta',''),
  AppLanguage('తెలుగు', 'Telugu', 'te',''),
  AppLanguage('ไทย', 'Thai', 'th',''),
  AppLanguage('Türkçe', 'Turkish', 'tr',''),
  AppLanguage('Yкраїнська', 'Ukrainian', 'uk',''),
  AppLanguage('o\'zbek', 'Uzbek', 'uz',''),
  AppLanguage('Tiếng Việt', 'Vietnamese', 'vi',''),

];


const String darkMap = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]''';

const String normaMap = '''[  {
  "featureType": "administrative",
  "elementType": "geometry.fill",
  "stylers": [
    {
      "color": "#d6e2e6"
    }
  ]
},
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#cfd4d5"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#7492a8"
      }
    ]
  },
  {
    "featureType": "administrative.neighborhood",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "lightness": 25
      }
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#dde2e3"
      }
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#cfd4d5"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#dde2e3"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#7492a8"
      }
    ]
  },
  {
    "featureType": "landscape.natural.terrain",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#dde2e3"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.icon",
    "stylers": [
      {
        "saturation": -100
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#588ca4"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a9de83"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#bae6a1"
      }
    ]
  },
  {
    "featureType": "poi.sports_complex",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#c6e8b3"
      }
    ]
  },
  {
    "featureType": "poi.sports_complex",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#bae6a1"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "saturation": -45
      },
      {
        "lightness": 10
      },
      {
        "visibility": "on"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#41626b"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#c1d1d6"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#a6b5bb"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "on"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#9fb6bd"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.icon",
    "stylers": [
      {
        "saturation": -70
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#b4cbd4"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#588ca4"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#008cb5"
      }
    ]
  },
  {
    "featureType": "transit.station.airport",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "saturation": -100
      },
      {
        "lightness": -5
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a6cbe3"
      }
    ]
  }
]''';

const Map<String, int> weekDaysToNum = {
  'SAT': 1,
  'SUN': 2,
  'MON': 3,
  'TUE': 4,
  'WED':5,
  'THU':6,
  'FRI':7,
};

List<DayUnitType> minuteUnitType = [
  DayUnitType('MinuteUnit'.tr(), 'minute'),
  DayUnitType('HourUnit'.tr(), 'hour'),
  DayUnitType('DayUnit'.tr(), 'day'),
  DayUnitType('MonthUnit'.tr(), 'month'),
  DayUnitType('YearUnit'.tr(), 'year'),

];

List<DayUnitType> dayUnitType = [
  DayUnitType('DayUnit'.tr(), 'day'),
  DayUnitType('MonthUnit'.tr(), 'month'),
  DayUnitType('YearUnit'.tr(), 'year'),

];

List<String> subscribtionDuration = [
  '1 ${'DayUnit'.tr()}',
  '1 ${'MonthUnit'.tr()}',
  '3 ${'MonthsUnit'.tr()}',
  '6 ${'MonthsUnit'.tr()}',
  '1 ${'YearUnit'.tr()}',
];

int getCurrentYear() {
  return DateTime.now().year;
}

int getCurrentMonth() {
  return DateTime.now().month;
}

DayUnitType? getMinuteUnitType(String value){
  for(DayUnitType type in minuteUnitType){
    if(type.value==value){
      return type;
    }
  }

  return null;
}

int getMemberShipSubscribtionDuration(String value){
  if(value.toLowerCase() =='1 Day'.toLowerCase()||value=='1 يوم'){
    return 0;
  }else if(value.toLowerCase() =='1 Month'.toLowerCase()||value=='1 شهر'){
    return 1;

  }else if(value.toLowerCase() =='3 Months'.toLowerCase()||value=='3 شهور'){
    return 2;

  }else if(value.toLowerCase() =='6 Months'.toLowerCase()||value=='6 شهور'){
    return 3;

  }else if(value.toLowerCase() =='1 Year'.toLowerCase()||value=='1 سنة'){
    return 4;
  }
  return -1;
}

String? formatNumber(num number){

  String n =  number.toStringAsFixed(2);
  return n;
}



