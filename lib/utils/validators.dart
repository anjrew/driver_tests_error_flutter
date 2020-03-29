import 'package:validators/validators.dart';

bool isValidURL(String string) {

  final bool hasProtocal = string.startsWith('http') 
  || string.startsWith('ftp') 
  || string.startsWith('mailto') 
  || string.startsWith('file') 
  || string.startsWith('data')
  || string.startsWith('irc');
  return isURL(string) && hasProtocal;
}

bool isIPAddress(String str) {
  final List<String> arr = str.split('.');
  final List<bool> test = arr.map((v) => isNumeric(v)).toList();
  final bool hasNonNum = test.contains(false);  
  return isURL(str) && !hasNonNum;
}


bool isNumeric(String s) {
 if (s == null) {
   return false;
 }
 return double.tryParse(s) != null;
}