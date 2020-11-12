/**
 * @author Randy J. Fortier
 * Code gotten from class
 */

String toOrdinal(number) {
  if ((number >= 10) && (number <= 19)) {
    return number.toString() + 'th';
  } else if ((number % 10) == 1) {
    return number.toString() + 'st';
  } else if ((number % 10) == 2) {
    return number.toString() + 'nd';
  } else if ((number % 10) == 3) {
    return number.toString() + 'rd';
  } else {
    return number.toString() + 'th';
  }
}

String toMonthName(monthNum) {
  switch (monthNum) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return 'Error';
  }
}

String toDateString(DateTime date) {
  return '${toMonthName(date.month)} ${toOrdinal(date.day)}';
}

// Checks to see if a string is a valid number
// function obtained from
// https://www.codegrepper.com/code-examples/dart/checking+if+a+value+is+numeric+in+dart
bool isNumeric(String result) {
  if (result == null) {
    return false;
  }
  return double.tryParse(result) != null;
}

String formatDate(date) {
  return '${toMonthName(date.month)} ' + '${date.day}, ${date.year} ';
}
