import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/theme_model.dart';

class CoinDetail extends StatefulWidget {
  final Map coinDetail;
  final String previousPage;
  const CoinDetail(
      {Key? key, required this.coinDetail, required this.previousPage})
      : super(key: key);

  @override
  State<CoinDetail> createState() => _CoinDetailState();
}

class _CoinDetailState extends State<CoinDetail> {
  List<String> currentWatchlist = [];

  // Get watchlist from SharedPreferences
  Future<void> getWatchlistFromSharedPrefs() async {
    // Create an instance of SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Get value of 'watchlist' key in SharedPreferences
    List<String>? watchlist = prefs.getStringList('watchlist');

    // If watchlist is not null, assign it to currentWatchlist
    if (watchlist != null) {
      setState(() {
        currentWatchlist = watchlist;
      });
    }
  }

  // Add coin to watchlist
  Future<void> addCoinToWatchlist(dynamic coinDetail) async {
    // Create an instance of SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Add coin to local watchlist
    setState(() {
      currentWatchlist.add(json.encode(coinDetail));
    });

    // Update watchlist value in SharedPreferences
    prefs.setStringList('watchlist', currentWatchlist);
  }

  // Remove coin from watchlist
  Future<void> removeCoinFromWatchlist(dynamic coinDetail) async {
    // Create an instance of SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Remove coin from local watchlist
    setState(() {
      currentWatchlist.removeWhere(
          (element) => json.decode(element)['symbol'] == coinDetail['symbol']);
    });

    // Update watchlist value in SharedPreferences
    prefs.setStringList('watchlist', currentWatchlist);
  }

  bool doesCoinExists(coin) {
    if (currentWatchlist
            .where((item) => json.decode(item)['symbol'] == coin)
            .length >
        0) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    // Get watchlist from SharedPreferences
    getWatchlistFromSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel themeNotifier, child) {
        return Scaffold(
          backgroundColor: themeNotifier.isDark
              ? Colors.grey.shade900
              : const Color.fromARGB(255, 255, 255, 255),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: themeNotifier.isDark
                ? Colors.grey.shade800
                : Colors.grey.shade200,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: '${widget.coinDetail['image']}',
                  width: 20,
                  height: 20,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Color.fromARGB(255, 116, 255, 3))),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(width: 20),
                widget.coinDetail['name'].toString().length >= 10
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${widget.coinDetail['name']}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: themeNotifier.isDark
                                      ? Colors.white
                                      : Colors.grey.shade700)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                              "(${widget.coinDetail['symbol'].toString().toUpperCase()})",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: themeNotifier.isDark
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade600)),
                        ],
                      )
                    : Row(
                        children: [
                          Text("${widget.coinDetail['name']}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: themeNotifier.isDark
                                      ? Colors.white
                                      : Colors.grey.shade700)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                              "(${widget.coinDetail['symbol'].toString().toUpperCase()})",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: themeNotifier.isDark
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade600)),
                        ],
                      ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  doesCoinExists(widget.coinDetail['symbol'])
                      ? Icons.star
                      : Icons.star_border,
                  color: doesCoinExists(widget.coinDetail['symbol'])
                      ? Colors.yellow
                      : Colors.grey.shade600,
                ),
                onPressed: () {
                  doesCoinExists(widget.coinDetail['symbol'])
                      ? removeCoinFromWatchlist(widget.coinDetail)
                      : addCoinToWatchlist(widget.coinDetail);
                },
              ),
            ],
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color:
                    themeNotifier.isDark ? Colors.white : Colors.grey.shade800,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  '${NumberFormat("#,##0.00", "en_US").format(widget.coinDetail['current_price'].toDouble())} ???',
                  style: const TextStyle(
                      fontSize: 50, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  width: 60,
                  height: 30,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: themeNotifier.isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                        )),
                    child: Row(
                      children: [
                        widget.coinDetail[
                                        'price_change_percentage_24h_in_currency']
                                    .toDouble() <=
                                0
                            ? const Icon(Icons.arrow_drop_down,
                                size: 20, color: Colors.red)
                            : const Icon(
                                Icons.arrow_drop_up,
                                size: 20,
                                color: Colors.green,
                              ),
                        Text(
                          '${widget.coinDetail['price_change_percentage_24h_in_currency'].toDouble().toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: widget.coinDetail[
                                            'price_change_percentage_24h_in_currency']
                                        .toDouble() <
                                    0
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: themeNotifier.isDark
                      ? const Color.fromARGB(255, 47, 46, 46)
                      : Colors.white,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Piyasa Degeri',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: themeNotifier.isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade700,
                                    fontSize: 15)),
                            Text(
                                '${NumberFormat('###,###,000').format(widget.coinDetail['market_cap'])} ???',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: themeNotifier.isDark
                                        ? Colors.white
                                        : Colors.grey.shade900,
                                    fontSize: 15))
                          ],
                        ),
                      ),
                      Divider(
                        height: 40,
                        thickness: 2,
                        indent: 0,
                        endIndent: 0,
                        color: themeNotifier.isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade500,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('????lem Hacmi',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: themeNotifier.isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade700,
                                    fontSize: 15)),
                            Text(
                                '${NumberFormat('###,###,000').format(widget.coinDetail['total_volume'])} ???',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: themeNotifier.isDark
                                        ? Colors.white
                                        : Colors.grey.shade900,
                                    fontSize: 15))
                          ],
                        ),
                      ),
                      Divider(
                        height: 40,
                        thickness: 2,
                        indent: 0,
                        endIndent: 0,
                        color: themeNotifier.isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade500,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Dola??an Arz',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: themeNotifier.isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade700,
                                    fontSize: 15)),
                            Text(
                                '${NumberFormat('###,###,000').format(widget.coinDetail['circulating_supply'])} ???',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: themeNotifier.isDark
                                        ? Colors.white
                                        : Colors.grey.shade900,
                                    fontSize: 15))
                          ],
                        ),
                      ),
                      Divider(
                        height: 40,
                        thickness: 2,
                        indent: 0,
                        endIndent: 0,
                        color: themeNotifier.isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade500,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Toplam Arz',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: themeNotifier.isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade700,
                                    fontSize: 15)),
                            Text(
                                widget.coinDetail['total_supply'] == null
                                    ? '?'
                                    : '${NumberFormat('###,###,###,###,###,###,###,###,000').format(widget.coinDetail['total_supply'])} ???',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: themeNotifier.isDark
                                        ? Colors.white
                                        : Colors.grey.shade900,
                                    fontSize: 15))
                          ],
                        ),
                      ),
                      Divider(
                        height: 40,
                        thickness: 2,
                        indent: 0,
                        endIndent: 0,
                        color: themeNotifier.isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade500,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('En Y??ksek Seviye',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: themeNotifier.isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade700,
                                    fontSize: 15)),
                            Text(
                                '${widget.coinDetail['ath'].toDouble().toStringAsFixed(2)} ???',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: themeNotifier.isDark
                                        ? Colors.white
                                        : Colors.grey.shade900,
                                    fontSize: 15))
                          ],
                        ),
                      ),
                      Divider(
                        height: 40,
                        thickness: 2,
                        indent: 0,
                        endIndent: 0,
                        color: themeNotifier.isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade500,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('En D??????k Seviye',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: themeNotifier.isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade700,
                                    fontSize: 15)),
                            Text(
                                '${widget.coinDetail['atl'].toDouble().toStringAsFixed(2)} ???',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: themeNotifier.isDark
                                        ? Colors.white
                                        : Colors.grey.shade900,
                                    fontSize: 15))
                          ],
                        ),
                      ),
                    ]),
              )
            ],
          ),
        );
      },
    );
  }
}
