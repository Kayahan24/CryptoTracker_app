import 'package:cryptmark/models/argument_model.dart';
import 'package:cryptmark/pages/calculate_page.dart';
import 'package:cryptmark/pages/coin_detail_page.dart';
import 'package:cryptmark/pages/market_page.dart';
import 'package:cryptmark/pages/watchlist_page.dart';
import 'package:flutter/material.dart';

const String homeRoute = '/';
const String watchlistRoute = 'watchlist';
const String coindetailRoute = 'coindetail';
const String searchRoute = 'search';

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homeRoute:
      return MaterialPageRoute(builder: (_) => const MarketPage());
    case searchRoute:
      return MaterialPageRoute(builder: (_) => const CalculatePage());
    case watchlistRoute:
      return MaterialPageRoute(builder: (_) => const WatchlistPage());
    case coindetailRoute:
      final args = settings.arguments as Arguments;
      return MaterialPageRoute(
          builder: (_) => CoinDetail(
              coinDetail: args.coinDetail, previousPage: args.previousPage));

    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(child: Text('Adres bulunamad─▒ ${settings.name}')),
              ));
  }
}
