import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptmark/models/currency_model.dart';
import 'package:cryptmark/services/currency_service.dart';
import 'package:cryptmark/states/coin_cubit.dart';
import 'package:cryptmark/states/coin_state.dart';
import 'package:cryptmark/theme/theme_model.dart';
import 'package:cryptmark/widgets/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({Key? key}) : super(key: key);

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  late CoinCubit cubit;
  late String coinname;
  late Future<Album> futureTry;
  late Future<euro> futureEuro;
  late double coinprice;
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
    } else {
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
    coinname = 'btc';
    coinprice = 1;
    // Create an instance of CoinCubit
    cubit = BlocProvider.of<CoinCubit>(context);
    futureTry = fetchTry();
    futureEuro = fetchEuro();
    // Get API's last fetch time
    getApiLastFetchTimeFromSharedPrefs();
  }

  String dropdownValue = 'TL';
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    const List<String> list = <String>[
      'TL',
      'USD',
    ];
    final _tot = TextEditingController();
    final _totvalue = TextEditingController();

    List<Map<String, dynamic>> results = [];
    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Consumer(builder: (context, ThemeModel themeNotifier, child) {
          return SizedBox(
            height: size.height,
            child: Column(children: [
              BlocBuilder(
                  bloc: cubit,
                  builder: (context, state) {
                    if (state is CoinLoading) {
                      return const SkeletonLoader();
                    }

                    if (state is CoinLoaded) {
                      setCoinsList(state.coinModel);

                      return FutureBuilder<Album>(
                        future: futureTry,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Center(
                              child: SingleChildScrollView(
                                child: SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 150),
                                        child: Container(
                                          width: size.width / 2.5,
                                          height: size.height / 15,
                                          child: DropdownButtonFormField(
                                              value: this.dropdownValue,
                                              elevation: 16,
                                              menuMaxHeight: 200,
                                              hint: const Text("Birim Seciniz"),
                                              isExpanded: false,
                                              items: list.map<
                                                      DropdownMenuItem<String>>(
                                                  (String valueCurrency) {
                                                return DropdownMenuItem<String>(
                                                  value: valueCurrency,
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          valueCurrency,
                                                          textAlign:
                                                              TextAlign.right,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      )),
                                                );
                                              }).toList(),
                                              onChanged: (valueCurrency) {
                                                setState(() {
                                                  dropdownValue =
                                                      valueCurrency.toString();
                                                });
                                              }),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: size.width / 1.5,
                                        child: TextField(
                                          controller: _totvalue,
                                          decoration: InputDecoration(
                                              labelText: "Miktar",
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade400),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: size.width / 2.5,
                                        height: size.height / 15,
                                        child: DropdownButton(
                                            value: coinname,
                                            elevation: 16,
                                            menuMaxHeight: 200,
                                            hint: const Text("Coin Seciniz"),
                                            isExpanded: false,
                                            items: state.coinModel.map((items) {
                                              return DropdownMenuItem(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        items['symbol']
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              items['image'],
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                value: items['symbol'],
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                coinname = value as String;
                                              });
                                            }),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: size.width / 1.1,
                                        child: TextField(
                                          controller: _tot,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              labelText: "Sonuc",
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade400),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // cal = this.coinprice * 300;
                                          // result = cal;
                                          String? temp;

                                          for (var a in state.coinModel
                                              .where((element) =>
                                                  element['symbol']
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(coinname
                                                          .toLowerCase()))
                                              .toList()) {
                                            temp =
                                                json.encode(a['current_price']);
                                          }
                                          if (double.parse(_totvalue.text) >
                                              0) {
                                            if (dropdownValue.toLowerCase() ==
                                                'tl') {
                                              var calc =
                                                  double.parse(_totvalue.text) /
                                                      double.parse(temp!);

                                              _tot.text = calc.toString() +
                                                  ' $coinname';
                                            } else if (dropdownValue
                                                    .toLowerCase() ==
                                                'usd') {
                                              var calc =
                                                  double.parse(_totvalue.text) /
                                                      (double.parse(temp!) /
                                                          snapshot.data!.id);
                                              _tot.text = calc.toString() +
                                                  ' $coinname';
                                            }
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: size.height / 14,
                                          width: size.width / 1.5,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Text(
                                            "Dönüştür",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          return Container(
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator());
                        },
                      );
                    }
                    return Text(state is CoinError
                        ? state.errorMessage
                        : 'Unknown error');
                  }),
            ]),
          );
        }),
      ),
    );
  }
}
