import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

final iso8601Format = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ");

DateTime fromIso8601(String str) {
  return iso8601Format.parse(str);
}

int now() {
  return DateTime.now().millisecondsSinceEpoch;
}

DateTime yesterday() {
  DateTime today = DateTime.now();
  return today.subtract(const Duration(days: 1));
}

DateTime before(DateTime datetime, Duration duration) {
  return datetime.subtract(duration);
}

DateTime after(DateTime datetime, Duration duration) {
  return datetime.add(duration);
}

DateTime dateline(DateTime date) {
  return time(date, 0, 0);
}

DateTime time(DateTime d, int hour, int minute) {
  return DateTime(d.year, d.month, d.day, hour, minute);
}

String yMMMd(DateTime datetime) {
  return (DateFormat.yMMMd()).format(datetime);
}

// ignore: non_constant_identifier_names
String Hm(DateTime datetime) {
  return (DateFormat.Hm()).format(datetime);
}

String datetime(BuildContext context, DateTime dt) {
  DateTime ago = delta(dt);
  Locale locale = Localizations.localeOf(context);
  String lang = locale.languageCode;
  return format(lang, dt, ago);
}

String format(String lang, DateTime dt, DateTime ago) {
  if (ago.isBefore(yearago)) {
    return DateFormat.yMMMd(lang).format(dt);
  } else if (ago.isBefore(twodayago)) {
    return DateFormat.MMMd(lang).format(dt);
  } else {
    return timeago.format(ago, locale: lang);
  }
}

DateTime delta(DateTime dt) {
  int ago = now() - dt.millisecondsSinceEpoch;
  return DateTime.now().subtract(Duration(milliseconds: ago));
}

DateTime get twodayago {
  return DateTime.now().subtract(const Duration(days: 2));
}

DateTime get yearago {
  return DateTime.now().subtract(const Duration(days: 365));
}

DateTime get fiveminuteago {
  return DateTime.now().subtract(const Duration(minutes: 5));
}

String monthDay(int millsec) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millsec);
  int month = dateTime.month;
  int day = dateTime.day;
  return '$month/$day';
}
