import 'package:flutter/material.dart';

class Album {
  final double id;
  final String title;

  const Album({
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['try'],
      title: json['date'],
    );
  }
}

class euro {
  final double eur;
  final String eurtitle;

  const euro({
    required this.eur,
    required this.eurtitle,
  });

  factory euro.fromJson(Map<String, dynamic> json) {
    return euro(
      eur: json['eur'],
      eurtitle: json['date'],
    );
  }
}
