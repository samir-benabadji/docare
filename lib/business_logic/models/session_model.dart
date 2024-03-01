import 'package:flutter/material.dart';

class SessionModel {
  final String id;
  final String day;
  TimeOfDay? startAt;
  TimeOfDay? endAt;

  SessionModel({required this.day, this.startAt, this.endAt}) : id = DateTime.now().millisecondsSinceEpoch.toString();
}
