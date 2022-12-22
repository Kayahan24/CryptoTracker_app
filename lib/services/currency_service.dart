import 'dart:async';
import 'dart:convert';

import 'package:cryptmark/models/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchTry() async {
  final response = await http.get(Uri.parse(
      'https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/usd/try.json'));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<euro> fetchEuro() async {
  final response = await http.get(Uri.parse(
      'https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/usd/eur.json'));

  if (response.statusCode == 200) {
    return euro.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class CurrencyHome extends StatefulWidget {
  const CurrencyHome({super.key});

  @override
  State<CurrencyHome> createState() => _CurrencyHomeState();
}

class _CurrencyHomeState extends State<CurrencyHome> {
  late Future<Album> futureTry;
  late Future<euro> futureEuro;

  @override
  void initState() {
    super.initState();
    futureTry = fetchTry();
    futureEuro = fetchEuro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
