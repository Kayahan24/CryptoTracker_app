import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptmark/models/argument_model.dart';
import 'package:cryptmark/routing/router.dart';
import 'package:cryptmark/pages/home_page.dart';
import 'package:cryptmark/widgets/empty_watchlist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/theme_model.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  List<String> currentWatchlist = [];

  // Get watchlist from SharedPreferences
  Future<void> getWatchlistFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? watchlist = prefs.getStringList('watchlist');

    if (watchlist != null) {
      setState(() {
        currentWatchlist = watchlist;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Get watchlist from SharedPreferences
    getWatchlistFromSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: currentWatchlist.length < 1
                  ? const EmptyWatchlist()
                  : SingleChildScrollView(
                      child: DataTable(
                          dataRowHeight: 60,
                          columnSpacing: 0,
                          horizontalMargin: 0,
                          columns: <DataColumn>[
                            DataColumn(
                              label: Container(
                                width: width * .1,
                                child: Text(
                                  '#',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeNotifier.isDark
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontSize: 11),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                                width: width * .1,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Coin'.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeNotifier.isDark
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontSize: 11),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                                width: width * .2,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Fiyat'.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeNotifier.isDark
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontSize: 11),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                                width: width * .2,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '24S'.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeNotifier.isDark
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontSize: 11),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                                width: width * .4,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Piyasa Degeri'.toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: themeNotifier.isDark
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                          fontSize: 11),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(currentWatchlist.length,
                              (i) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: themeNotifier.isDark
                                                ? Colors.white
                                                : Colors.grey.shade600,
                                            fontSize: 11),
                                      ),
                                    ), onTap: (() {
                                  Navigator.pushNamed(context, coindetailRoute,
                                      arguments: Arguments(
                                          json.decode(currentWatchlist[i]),
                                          'watchlist'));
                                })),
                                DataCell(
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          CachedNetworkImage(
                                            imageUrl:
                                                '${json.decode(currentWatchlist[i])['image']}',
                                            width: 20,
                                            height: 20,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Color.fromARGB(255,
                                                                116, 255, 3))),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            '${json.decode(currentWatchlist[i])['symbol']}'
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: themeNotifier.isDark
                                                    ? Colors.white
                                                    : Colors.grey.shade900,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ), onTap: (() {
                                  Navigator.pushNamed(context, coindetailRoute,
                                      arguments: Arguments(
                                          json.decode(currentWatchlist[i]),
                                          'watchlist'));
                                })),
                                DataCell(
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '\$${NumberFormat("#,##0.00", "en_US").format(json.decode(currentWatchlist[i])['current_price'].toDouble())}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: themeNotifier.isDark
                                                ? Colors.white
                                                : Colors.grey.shade900,
                                            fontSize: 13),
                                      ),
                                    ), onTap: (() {
                                  Navigator.pushNamed(context, coindetailRoute,
                                      arguments: Arguments(
                                          json.decode(currentWatchlist[i]),
                                          'watchlist'));
                                })),
                                DataCell(
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          json
                                                      .decode(
                                                          currentWatchlist[
                                                              i])[
                                                          'price_change_percentage_24h_in_currency']
                                                      .toDouble() <=
                                                  0
                                              ? const Icon(
                                                  Icons.arrow_drop_down,
                                                  size: 20,
                                                  color: Colors.red)
                                              : const Icon(
                                                  Icons.arrow_drop_up,
                                                  size: 20,
                                                  color: Colors.green,
                                                ),
                                          Text(
                                            '${json.decode(currentWatchlist[i])['price_change_percentage_24h_in_currency'].toDouble().toStringAsFixed(1)}%',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: json
                                                            .decode(
                                                                currentWatchlist[
                                                                    i])[
                                                                'price_change_percentage_24h_in_currency']
                                                            .toDouble() <=
                                                        0
                                                    ? Colors.red
                                                    : Colors.green,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ), onTap: (() {
                                  Navigator.pushNamed(context, coindetailRoute,
                                      arguments: Arguments(
                                          json.decode(currentWatchlist[i]),
                                          'watchlist'));
                                })),
                                DataCell(
                                    Container(
                                      padding: const EdgeInsets.only(right: 20),
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '\$${NumberFormat('###,###,000').format(json.decode(currentWatchlist[i])['market_cap'])}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: themeNotifier.isDark
                                                ? Colors.white
                                                : Colors.grey.shade900,
                                            fontSize: 13),
                                      ),
                                    ), onTap: (() {
                                  Navigator.pushNamed(context, coindetailRoute,
                                      arguments: Arguments(
                                          json.decode(currentWatchlist[i]),
                                          'watchlist'));
                                })),
                              ],
                            );
                          })),
                    ))
        ],
      );
    });
  }
}
