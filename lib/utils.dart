import 'dart:convert';

import 'dart:io';

bool isValidEmail(input) {
  return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(input);
}



String? getStringImage(File? file){
  if(file == null){
    return null;
  }
  return base64Encode(file.readAsBytesSync());
}
