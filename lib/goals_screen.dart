import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dhiwise_task/ProgressBar/circular_slider.dart';
import 'package:dhiwise_task/circular_progress_bar.dart';
import 'package:dhiwise_task/size_config.dart';

class GoalScreen extends StatefulWidget {
  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  late CollectionReference goals;

  @override
  void initState() {
    super.initState();
    goals = FirebaseFirestore.instance.collection('goals');
  }

  bool flag = true;
  int sliderIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 150, 202, 245),
      body: StreamBuilder(
        stream: goals.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Goals not found'));
          }

          List<QueryDocumentSnapshot<Object?>> goalData = snapshot.data!.docs;
          return SingleChildScrollView(child: buildGoalDetails(goalData));
        },
      ),
    );
  }

  Widget buildGoalDetails(List<QueryDocumentSnapshot<Object?>> goalData) {
    dynamic remainingSavings = goalData[sliderIndex]['totalAmount'] -
        goalData[sliderIndex]['currentAmount'];

    dynamic monthlySavingProjection =
        remainingSavings / Constants.monthsForProjection;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.0),
          topLeft: Radius.circular(40.0),
        ),
        color: Color.fromARGB(255, 21, 2, 53),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 25, left: 25, top: 25),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  goalData[sliderIndex]['title'],
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                CircularProgressBar(
                  currentIndex: sliderIndex,
                  updateSliderCount: (index) {
                    setState(() {
                      sliderIndex = index;
                    });
                  },
                  currentAmount: goalData[sliderIndex]['currentAmount'],
                  totalAmount: goalData[sliderIndex]['totalAmount'],
                  sliderLength: goalData.length,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Goal',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          Text('by ${goalData[sliderIndex]['goalDate']}',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                      Text('\$ ${goalData[sliderIndex]['totalAmount']}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 70,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 7, 87, 153),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 13, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Need more savings',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13)),
                            Text('\$ $remainingSavings',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Monthly Saving Projection',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13)),
                            Text('\$ $monthlySavingProjection',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 207, 218, 238),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            flag = true;
                          });
                        },
                        child: Text(
                          'Contributions',
                          style: TextStyle(
                              color: flag ? Colors.black : Colors.grey,
                              fontWeight:
                                  flag ? FontWeight.bold : FontWeight.normal,
                              fontSize: 15),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            flag = false;
                          });
                        },
                        child: Text(
                          'Show History',
                          style: TextStyle(
                              color: flag ? Colors.grey : Colors.black,
                              fontWeight:
                                  flag ? FontWeight.normal : FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  flag
                      ? Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Column(
                            children: [
                              const MultiCircularSlider(
                                size: 10,
                                values: [0.6, 0.3, 0.1],
                                colors: [
                                  Colors.blue,
                                  Colors.yellow,
                                  Colors.greenAccent,
                                ],
                                showTotalPercentage: true,
                                animationDuration: Duration(milliseconds: 1500),
                                animationCurve: Curves.easeIn,
                                innerWidget: Column(
                                  children: [],
                                ),
                                trackColor: Colors.grey,
                                progressBarWidth: 30.0,
                                trackWidth: 10,
                                labelTextStyle: TextStyle(),
                                percentageTextStyle: TextStyle(),
                                progressBarType: MultiCircularSliderType.linear,
                              ),
                              HistoryList(
                                  contributions: goalData[sliderIndex]
                                      ['contributions']),
                            ],
                          ),
                        )
                      : HistoryList(
                          contributions: goalData[sliderIndex]
                              ['contributions']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Constants {
  static const int monthsForProjection = 60;
}

class HistoryList extends StatelessWidget {
  final List<dynamic> contributions;

  const HistoryList({Key? key, required this.contributions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: contributions.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> contribution = contributions[index];
        String date = contribution['date'];
        dynamic amount = contribution['amount'];
        double? amountDouble =
            amount is String ? double.tryParse(amount) : amount?.toDouble();

        return ListTile(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date : $date',
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Amount : ${amountDouble != null ? '\$$amountDouble' : 'N/A'}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }
}
