import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionModel {
  final String id;
  final int timestamp;
  TimeOfDay? startAt;
  TimeOfDay? endAt;

  SessionModel({required this.timestamp, this.startAt, this.endAt})
      : id = DateTime.now().millisecondsSinceEpoch.toString();

  String getDayName() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.E().format(dateTime);
  }

  String getMonth() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.MMMM().format(dateTime);
  }

  int getYear() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return dateTime.year;
  }

  String getDayWithNumber() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String dayNumber = DateFormat.d().format(dateTime);
    String dayName = DateFormat.E().format(dateTime);
    return '$dayName $dayNumber';
  }
}
