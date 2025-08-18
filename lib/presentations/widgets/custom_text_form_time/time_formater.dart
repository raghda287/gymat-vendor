import 'dart:math';

import 'package:flutter/services.dart';

class TimeTextFormatter extends TextInputFormatter {
  static const _maxChars = 5;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newVal = newValue.text;
    if(newValue.text.length==2){
      int value = int.parse(newValue.text.replaceAll(':', ''));
      if(value>12){
        newVal = '12';
      }
    }else if(newVal.length==5){
      String spl = newVal.split(':').last;
      int value = int.parse(spl);
      if(value>59){
        newVal = '${newVal.split(':').first}:00';
      }
    }
    var text = _format(newVal, ':');
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String seperator) {
    value = value.replaceAll(seperator, '');
    var newString = '';

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      newString += value[i];
      if ((i == 1) && i != value.length - 1) {
        newString += seperator;
      }
    }

    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}