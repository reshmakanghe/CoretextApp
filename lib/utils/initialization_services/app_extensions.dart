// import 'package:easy_localization/easy_localization.dart';

// extension CurrencyFormatter on String {
//   String setCurrencyFormatter() {
//     // NumberFormat formatter =
//     //     NumberFormat.currency(symbol: "₹ ", locale: "en_IN", decimalDigits: 2);

//     String returnValue = formatter
//         .format((double.tryParse(this) != null ? double.parse(this) : 0.0));

//     if (returnValue.contains("-₹")) {
//       returnValue = returnValue.replaceAll("-₹", "₹ -");
//     }
//     return returnValue;
//   }

//   DateTime? getDateInRequiredFormat({required String requiredFormat}) {
//     if (isEmpty) {
//       return null;
//     }
//     String? parsingDateString;

//     if (contains("T") || contains("Z")) {
//       DateTime parsingDate = DateTime.parse(this);
//       parsingDateString = DateFormat(requiredFormat).format(parsingDate);
//     }
//     try {
//       DateTime dateTime =
//           DateFormat(requiredFormat).parse(parsingDateString ?? this);
//       return dateTime;
//     } catch (e) {
//       return null;
//     }
//   }

//   String? getDateInAppDefaultFormat(
//       {String? inputDateFormat, String? requiredDateFormat}) {
//     if (isEmpty) {
//       return "";
//     }
//     DateTime? inputDate;
//     if (inputDateFormat != null) {
//       inputDate = DateFormat(inputDateFormat).parse(this);
//     } else {
//       inputDate = DateTime.parse(this);
//     }
//     if (requiredDateFormat != null) {
//       return DateFormat(requiredDateFormat).format(inputDate);
//     }

//     return DateFormat("dd-MM-yyyy").format(inputDate);
//   }
// }

// extension DateFormatterAndCalculator on DateTime {
//   bool checkDateIsAfter({required DateTime? dateValue}) {
//     if (dateValue == null) {
//       return false;
//     }
//     return isAfter(dateValue);
//   }

//   String? parseDateIn({required String requiredFormat}) {
//     return DateFormat(requiredFormat).format(this);
//   }
// }

// extension DoubleExtension on dynamic {
//   double getDoubleValue() {
//     return double.tryParse(toString()) != null
//         ? (double.parse(toString()).isNaN ? 0.0 : double.parse(toString()))
//         : 0.0;
//   }
// }
