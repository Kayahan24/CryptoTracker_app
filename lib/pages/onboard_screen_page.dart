import 'package:cryptmark/pages/home_page.dart';
import 'package:cryptmark/pages/market_page.dart';
import 'package:cryptmark/pages/onboard_screen/model/onboard_model.dart';
import 'package:cryptmark/pages/onboard_screen/widget/onboard_card.dart';
import 'package:cryptmark/theme/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardScreen extends StatefulWidget {
  final ThemeModel themeNotifier;
  const OnBoardScreen({Key? key, required this.themeNotifier})
      : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final PageController _controller = PageController();

  bool onLastpage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView.builder(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastpage = (index == 2);
            });
          },
          itemCount: OnBoardModels.onBoardItems.length,
          itemBuilder: (BuildContext context, int index) {
            return OnBoardCard(model: OnBoardModels.onBoardItems[index]);
          },
        ),
        Container(
          alignment: const Alignment(0, 0.80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: const Text('Back')),
              SmoothPageIndicator(
                controller: _controller,
                count: 3,
              ),
              onLastpage
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HomePage(
                                themeNotifier: widget.themeNotifier,
                              );
                            },
                          ),
                        );
                      },
                      child: const Text('Done'))
                  : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: const Text('Next')),
            ],
          ),
        ),
      ],
    ));
  }
}
