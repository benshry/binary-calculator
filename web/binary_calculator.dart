import 'dart:html';
import 'dart:math';
import 'package:unittest/unittest.dart';

void main() {
  
  /*
   * Unit Tests.
   */
  test('binary_to_decimal tests', () {
    expect(binary_to_decimal('0'), equals(0));
    expect(binary_to_decimal('1'), equals(1));
    expect(binary_to_decimal('10'), equals(2));
    expect(binary_to_decimal('11'), equals(3));
    expect(binary_to_decimal('0011'), equals(3)); // leading zeros
    expect(binary_to_decimal('0000'), equals(0)); // all zeros
  });
  
  test('is_binary_string tests', () {
    expect(string_is_binary('0'), equals(true));
    expect(string_is_binary('1'), equals(true));
    expect(string_is_binary('101'), equals(true));
    expect(string_is_binary(''), equals(false));
    expect(string_is_binary('a'), equals(false));
    expect(string_is_binary('101a'), equals(false));
    expect(string_is_binary('10a1'), equals(false));
  });
  
  test('decimal_to_binary tests', () {
    expect(decimal_to_binary(0), equals('0'));
    expect(decimal_to_binary(1), equals('1'));
    expect(decimal_to_binary(2), equals('10'));
    expect(decimal_to_binary(3), equals('11'));
    expect(decimal_to_binary(5), equals('101'));
    expect(decimal_to_binary(64), equals('1000000'));
    expect(decimal_to_binary(-0), equals('0'));
    expect(decimal_to_binary(-1), equals('-1'));
    expect(decimal_to_binary(-64), equals('-1000000'));
  });
  
  test('plus tests', () {
    expect(plus('1', '1'), equals('10'));
  });
  
  test('minus tests', () {
    expect(minus('1', '1'), equals('0'));
    expect(minus('1', '10'), equals('-1'));
  });
  
  test('times tests', () {
    expect(times('1', '0'), equals('0'));
    expect(times('1', '1'), equals('1'));
    expect(times('1', '10'), equals('10'));
    expect(times('10', '10'), equals('100'));
  });
  
  test('divide tests', () {
    expect(()=>divide('1', '0'), throwsStateError);
    expect(divide('1', '1'), equals('1'));
    expect(divide('100', '10'), equals('10'));
    expect(divide('101', '10'), equals('10'));
  });
  
  /*
   * Event Handlers.
   */
  querySelector("#button-equals")
    ..onClick.listen(update);
}

/*
 * Updates the screen.
 */
void update(MouseEvent event) {
  var text = querySelector("#screen").value;
}

/*
 * Checks if a string is composed of bits.
 */
bool string_is_binary(binary_string) {
  if (binary_string.length == 0) {
    return false;
  }
  for (var i = 0; i < binary_string.length; i++) {
    if (binary_string[i] != '0' && binary_string[i] != '1') {
      return false;
    }
  }
  return true;
}

/*
 * Converts a binary string to a decimal integer.
 * TODO(bshryock): handle negatives?
 */
int binary_to_decimal(String binary_string) {
  if (!string_is_binary(binary_string)) {
    throw new StateError('Binary string contains invalid characters.');
  }
  var multiplier = pow(2, binary_string.length - 1);
  var sum = 0;
  for (var i = 0; i < binary_string.length; i++) {
    sum = sum + (multiplier * int.parse(binary_string[i]));
    multiplier /= 2;
  }
  return sum.toInt();
}

/*
 * Converts a decimal integer to a binary string.
 * Algorithm from http://goo.gl/2BEwAL
 */
String decimal_to_binary(int number) {
  if (number == 0) {
    return '0';
  }
  
  var negative = number < 0;
  if (negative) {
    number *= -1;
  }
  
  var output = '';
  while (number > 0) {
    var bit = number % 2;
    number = number ~/ 2;
    output = bit.toString() + output;
  }
  
  if (negative) {
    output = '-' + output;
  }
  
  return output;
}

/*
 * Adds two binary strings together.
 */
String plus(b_string1, b_string2) {
  int dec_result = binary_to_decimal(b_string1) + binary_to_decimal(b_string2);
  return decimal_to_binary(dec_result);
}

/*
 * Subtracts two binary strings.
 */
String minus(b_string1, b_string2) {
  int dec_result = binary_to_decimal(b_string1) - binary_to_decimal(b_string2);
  return decimal_to_binary(dec_result);
}  
  
/*
 * Multiplies two binary strings.
 */
String times(b_string1, b_string2) {
  int dec_result = binary_to_decimal(b_string1) * binary_to_decimal(b_string2);
  return decimal_to_binary(dec_result);
}

/*
 * Divides two binary strings.
 * Note: performs integer division.
 */
String divide(b_string1, b_string2) {
  if (b_string2 == '0') {
    throw new StateError('Can not divide by 0.');
  }
  int dec_result = binary_to_decimal(b_string1) ~/ binary_to_decimal(b_string2);
  return decimal_to_binary(dec_result);
}