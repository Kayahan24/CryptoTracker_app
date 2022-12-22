import 'package:cryptmark/pages/onboard_screen/model/onboard_model.dart';
import 'package:flutter/material.dart';

class OnBoardCard extends StatelessWidget {
  const OnBoardCard({Key? key, required this.model}) : super(key: key);
  final OnBoardModel model;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Align(
              child: Center(
                child: Text(
                  model.title,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
          ),
          Text(model.description),
          SizedBox(
              height: 450, width: 450, child: Image.asset(model.imageWithPath)),
        ],
      ),
    );
  }
}
