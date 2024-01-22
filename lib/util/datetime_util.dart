import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

int now() {
  return DateTime.now().toUtc().millisecondsSinceEpoch;
}

DateTime dt(int unixtime) {
  return DateTime.fromMillisecondsSinceEpoch(unixtime * 1000);
}

DateTime yesterday() {
  DateTime today = DateTime.now().toUtc();
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
  return DateTime.now().toUtc().subtract(Duration(milliseconds: ago));
}

DateTime get twodayago {
  return DateTime.now().toUtc().subtract(const Duration(days: 2));
}

DateTime get yearago {
  return DateTime.now().toUtc().subtract(const Duration(days: 365));
}

DateTime get fiveminuteago {
  return DateTime.now().toUtc().subtract(const Duration(minutes: 5));
}

String monthDay(int millsec) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millsec);
  int month = dateTime.month;
  int day = dateTime.day;
  return '$month/$day';
}
