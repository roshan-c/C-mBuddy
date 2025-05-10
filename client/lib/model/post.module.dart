// ignore_for_file: avoid_print

import 'package:flutter/src/widgets/basic.dart';
import 'package:rebeal/model/user.module.dart';

class LogModel {
  String? key;
  String? notes;
  late String createdAt;
  UserModel? user;
  int? intensity_rating;
  int? duration_minutes;
  String? location;
  bool was_partner_involved = false;
  List<String>? custom_tags;

  LogModel({
    this.key,
    required this.createdAt,
    this.notes,
    this.user,
    this.intensity_rating,
    this.duration_minutes,
    this.location,
    this.was_partner_involved = false,
    this.custom_tags,
  });

  toJson() {
    return {
      "key": key,
      "notes": notes,
      "createdAt": createdAt,
      "user": user == null ? null : user!.toJson(),
      "intensity_rating": intensity_rating,
      "duration_minutes": duration_minutes,
      "location": location,
      "was_partner_involved": was_partner_involved,
      "custom_tags": custom_tags,
    };
  }

  LogModel.fromJson(Map<dynamic, dynamic> map) {
    key = map['key'];
    notes = map['notes'];
    createdAt = map['createdAt'];
    user = map['user'] != null ? UserModel.fromJson(map['user']) : null;
    intensity_rating = map['intensity_rating'];
    duration_minutes = map['duration_minutes'];
    location = map['location'];
    was_partner_involved = map['was_partner_involved'] ?? false;
    if (map['custom_tags'] != null) {
      custom_tags = List<String>.from(map['custom_tags']);
    } else {
      custom_tags = null;
    }
  }
}
