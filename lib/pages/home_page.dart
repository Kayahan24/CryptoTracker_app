import 'package:cryptmark/pages/market_page.dart';
import 'package:cryptmark/pages/calculate_page.dart';
import 'package:cryptmark/pages/onboard_screen_page.dart';
import 'package:cryptmark/pages/watchlist_page.dart';
import 'package:cryptmark/theme/theme_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ThemeModel themeNotifier;
  const HomePage({Key? key, required this.themeNotifier}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const MarketPage(),
    const CalculatePage(),
    const WatchlistPage(),
  ];

  final List<String> _tabTitle = [
    'Market',
    'Hesapla',
    'Takip Et',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == -1
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: widget.themeNotifier.isDark
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
              title: Text(
                _tabTitle[_selectedIndex],
                style: TextStyle(
                  color: widget.themeNotifier.isDark
                      ? Colors.grey.shade200
                      : Colors.grey.shade600,
                ),
              ),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    widget.themeNotifier.isDark
                        ? widget.themeNotifier.isDark = false
                        : widget.themeNotifier.isDark = true;
                  },
                  icon: Icon(widget.themeNotifier.isDark
                      ? Icons.nightlight_rounded
                      : Icons.wb_sunny),
                  color: widget.themeNotifier.isDark
                      ? Colors.grey.shade200
                      : Colors.grey.shade600,
                )
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: widget.themeNotifier.isDark
            ? Colors.grey.shade800
            : Colors.grey.shade200,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart, color: Colors.grey.shade500),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calculate_outlined,
              color: widget.themeNotifier.isDark
                  ? Colors.grey.shade200
                  : Colors.grey.shade800,
            ),
            label: 'Hesapla',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star_border_outlined,
              color: widget.themeNotifier.isDark
                  ? Colors.grey.shade200
                  : Colors.grey.shade800,
            ),
            label: 'Takip Et',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
      body: _tabs[_selectedIndex],
    );
  }
}
