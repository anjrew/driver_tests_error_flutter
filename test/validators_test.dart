// Import the test package and Counter class
import 'package:dismay_app/utils/validators.dart';
import 'package:test/test.dart';

void main() {
  group('Test Ip validator', () {
    test('Correct IP should work', () {
      expect(isIPAddress('192.168.1.1'), true);
      expect(isIPAddress('77.183.209.42'), true);
    });
    test('IP with letters should not work', () {
      expect(isIPAddress('dafssdv'), false);
    });
    test('IP with incorrect format should not work', () {
      expect(isIPAddress('123.321.1'), false);
    });
    test('IP with incomplete url should not work', () {
      expect(isIPAddress('www.gooogle.com'), false);
    });
  });

  group('Test URL validator works', () {
    test('Correct google url should work', () {
      expect(isValidURL('https://www.google.com/webhp?hl=en&sa=X&ved=0ahUKEwicmO2K1L3oAhVailwKHWoLBvQQPAgH'),true);
    });
    test('Without protocal should not work', () {
      expect(isValidURL('www.google.com/webhp?hl=en&sa=X&ved=0ahUKEwicmO2K1L3oAhVailwKHWoLBvQQPAgH'),false);
    });
    test('IP should not work', () {
      expect(isValidURL('123.321.123.123'), false);
    });
    test('Without proper http works', () {
      expect(isValidURL('htts://www.google.com/webhp?hl=en&sa=X&ved=0ahUKEwicmO2K1L3oAhVailwKHWoLBvQQPAgH'), false);
    });
    test('Rubbish should not work', () {
      expect(isValidURL('fdsvdsvd'), false);
    });
  });

   group('Test isNumeric', () {
    test('A number should work', () {
      expect(isNumeric('1234123'),true);
    });
    test('A number with dots should not work', () {
      expect(isNumeric('12.34.123'), false);
      expect(isNumeric('32412.34234.234123'), false);
    });
    test('Letters should not work', () {
      expect(isNumeric('Oppps'), false);
    });
  });
}
