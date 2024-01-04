// ignore_for_file: use_key_in_widget_constructors

import 'package:dhiwise_task/ProgressBar/circular_slider.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircularProgressBar extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var currentAmount;
  // ignore: prefer_typing_uninitialized_variables
  var totalAmount;
  final int sliderLength;
  final int currentIndex;
  final Function(int index) updateSliderCount;

  CircularProgressBar({
    required this.currentAmount,
    required this.totalAmount,
    required this.sliderLength,
    required this.updateSliderCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    double progressPercentage = (currentAmount / totalAmount) * 100;

    return Stack(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            onPageChanged: (value) => updateSliderCount(value),
            scrollDirection: Axis.horizontal,
            itemCount: sliderLength,
            reverse: true,
            itemBuilder: (context, index) {
              return Center(
                child: buildCircularSlider(progressPercentage),
              );
            },
          ),
        ),
        buildIndicator(),
      ],
    );
  }

  Widget buildCircularSlider(double progressPercentage) {
    return SizedBox(
      height: 200,
      width: 200,
      child: MultiCircularSlider(
        size: 80,
        values: [progressPercentage / 100],
        colors: const [Colors.white],
        showTotalPercentage: true,
        animationDuration: const Duration(milliseconds: 1500),
        animationCurve: Curves.easeIn,
        innerWidget: buildInnerWidget(),
        trackColor: Colors.grey,
        progressBarWidth: 30.0,
        trackWidth: 5.0,
        labelTextStyle: const TextStyle(),
        percentageTextStyle: const TextStyle(),
        progressBarType: MultiCircularSliderType.circular,
      ),
    );
  }

  Widget buildInnerWidget() {
    return Column(
      children: [
        const Icon(
          Icons.home,
          color: Colors.white,
          size: 70,
        ),
        const SizedBox(height: 8),
        Text(
          '\$ ${currentAmount.toStringAsFixed(1)}',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Text(
          'You Saved ',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildIndicator() {
    return Positioned(
      top: 210,
      left: 160,
      child: SizedBox(
        width: 50,
        height: 20,
        child: buildIndicatorList(),
      ),
    );
  }

  Widget buildIndicatorList() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: sliderLength,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index ? Colors.grey : Colors.white,
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 6),
    );
  }
}
