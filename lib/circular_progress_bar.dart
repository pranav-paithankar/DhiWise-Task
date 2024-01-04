import 'package:dhiwise_task/size_config.dart';
import 'package:flutter/material.dart';
import 'package:multi_circular_slider/multi_circular_slider.dart';

class CircularProgressBar extends StatelessWidget {
  final double currentAmount;
  final double totalAmount;
  final int sliderCount;
  final Function(int index) updateSliderCount;

  CircularProgressBar({
    required this.currentAmount,
    required this.totalAmount,
    required this.sliderCount,
    required this.updateSliderCount,
  });

  @override
  Widget build(BuildContext context) {
    double progressPercentage = (currentAmount / totalAmount) * 100;

    return Container(
      color: Colors.red,
      height: 300,
      width: 250,
      child: PageView.builder(
          onPageChanged: (value) => updateSliderCount(value),
          scrollDirection: Axis.horizontal,
          itemCount: sliderCount,
          itemBuilder: (context, index) {
            return Center(
              child: Container(
                color: Colors.white,
                height: 250,
                width: 250,
                child: MultiCircularSlider(
                  size: 100,
                  values: [
                    progressPercentage / 100
                  ], // Provide a list with a single value
                  colors: const [
                    Colors.white,
                  ], // List of colors for progress and remaining
                  showTotalPercentage: true,
                  animationDuration: const Duration(milliseconds: 1000),
                  animationCurve: Curves.easeIn,
                  innerWidget: Column(
                    children: [
                      const Icon(
                        Icons.home_filled,
                        color: Colors.white,
                        size: 55,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        '\$ ${currentAmount.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Adjust the color as needed
                        ),
                      ),
                      Text(
                        'You Saved $index',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey, // Adjust the color as needed
                        ),
                      ),
                    ],
                  ),
                  trackColor:
                      Colors.grey, // Set the color for the remaining part
                  progressBarWidth: 42.0,
                  trackWidth: 6.0,
                  labelTextStyle: const TextStyle(),
                  percentageTextStyle: const TextStyle(),
                  progressBarType:
                      MultiCircularSliderType.circular, // Set to semi-half
                ),
              ),
            );
          }),
    );
  }
}
