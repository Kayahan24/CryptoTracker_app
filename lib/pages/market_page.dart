import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptmark/models/argument_model.dart';
import 'package:cryptmark/routing/router.dart';
import 'package:cryptmark/states/coin_cubit.dart';
import 'package:cryptmark/states/coin_state.dart';
import 'package:cryptmark/theme/theme_model.dart';
import 'package:cryptmark/widgets/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  late CoinCubit cubit;

  Future<void> setCoinsList(List<dynamic> coinsList) async {
    // Create an instance of SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    List<String> stringCoinsList =
        coinsList.map((i) => json.encode(i).toString()).toList();

    // Set value of 'coinsList' key in SharedPreferences
    prefs.setStringList('coinsList', stringCoinsList);
  }

  // Get API's last fetch time from SharedPreferences
  Future<void> getApiLastFetchTimeFromSharedPrefs() async {
    // Create an instance of SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Get value of 'apilastFetchTime' key in SharedPreferences
    String? apiLastFetchTime = prefs.getString('apiLastFetchTime');

    // If API's last fetch time is not null (the API has been fetched at least once)
    if (apiLastFetchTime != null) {
      // Check if current time is more than 10 seconds than lastFetchTime
      final timeDifference =
          DateTime.now().difference(DateTime.parse(apiLastFetchTime)).inSeconds;

      // If the time difference between current time and API's last fetch time
      // is more than 10 seconds, fetch coins from API again
      // and update API's last fetch time
      if (timeDifference >= 10) {
        cubit.fetchCoins();
        setApiLastFetchTime();
      }
    }
    // Else if API's last fetch time is null (the API hasn't been fetched ever)
    // fetch coins from API
    // and update API's last fetch time
    else {
      cubit.fetchCoins();
      setApiLastFetchTime();
    }
  }

  // Set API's last fetch time in SharedPreferences
  Future<void> setApiLastFetchTime() async {
    // Create an instance of SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Set value of 'apilastFetchTime' key in SharedPreferences
    prefs.setString('apiLastFetchTime', DateTime.now().toString());
  }

  @override
  void initState() {
    super.initState();

    // Create an instance of CoinCubit
    cubit = BlocProvider.of<CoinCubit>(context);

    // Get API's last fetch time
    getApiLastFetchTimeFromSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Column(
        children: [
          BlocBuilder(
              bloc: cubit,
              builder: (context, state) {
                if (state is CoinLoading) {
                  return const SkeletonLoader();
                }

                if (state is CoinLoaded) {
                  setCoinsList(state.coinModel);

                  return Expanded(
                      child: SingleChildScrollView(
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
                        rows:
                            List<DataRow>.generate(state.coinModel.length, (i) {
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
                                    arguments:
                                        Arguments(state.coinModel[i], '/'));
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
                                              '${state.coinModel[i]['image']}',
                                          width: 20,
                                          height: 20,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          Color.fromARGB(255,
                                                              116, 255, 3))),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '${state.coinModel[i]['symbol']}'
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
                                    arguments:
                                        Arguments(state.coinModel[i], '/'));
                              })),
                              DataCell(
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${NumberFormat("#,##0.00", "en_US").format(state.coinModel[i]['current_price'].toDouble())} ???',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: themeNotifier.isDark
                                              ? Colors.white
                                              : Colors.grey.shade900,
                                          fontSize: 13),
                                    ),
                                  ), onTap: (() {
                                Navigator.pushNamed(context, coindetailRoute,
                                    arguments:
                                        Arguments(state.coinModel[i], '/'));
                              })),
                              DataCell(
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        state.coinModel[i][
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
                                          '${state.coinModel[i]['price_change_percentage_24h_in_currency'].toDouble().toStringAsFixed(1)}%',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: state.coinModel[i][
                                                              'price_change_percentage_24h_in_currency']
                                                          .toDouble() <
                                                      0
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ), onTap: (() {
                                Navigator.pushNamed(context, coindetailRoute,
                                    arguments:
                                        Arguments(state.coinModel[i], '/'));
                              })),
                              DataCell(
                                  Container(
                                    padding: const EdgeInsets.only(right: 20),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${NumberFormat('###,###,000').format(state.coinModel[i]['market_cap'])} ???',
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
                                    arguments:
                                        Arguments(state.coinModel[i], '/'));
                              })),
                            ],
                          );
                        })),
                  ));
                }
                return Text(
                    state is CoinError ? state.errorMessage : 'Unknown error');
              }),
        ],
      );
    });
  }
}
