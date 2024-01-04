import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhiwise_task/circular_progress_bar.dart';
import 'package:dhiwise_task/size_config.dart';
import 'package:flutter/material.dart';

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

  int sliderIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 150, 202, 245),
      body: StreamBuilder(
        stream: goals.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Goals not found'));
          } else {
            // Extract goal data from the snapshot
            // For simplicity, let's assume there's only one document in the collection
            List<QueryDocumentSnapshot<Object?>> goalData = snapshot.data!.docs;

            // Implement UI based on goal data
            return buildGoalDetails(goalData);
          }
        },
      ),
    );
  }

  Widget buildGoalDetails(List<QueryDocumentSnapshot<Object?>> goalData) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.0),
          topLeft: Radius.circular(40.0),
        ),
        color: Color.fromARGB(255, 21, 2, 53),
      ),
      child: Padding(
        // padding:
        //     const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              goalData[sliderIndex]['title'],
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            CircularProgressBar(
                updateSliderCount: (index) {
                  print(index);
                  setState(() {
                    sliderIndex = index;
                  });
                },
                currentAmount:
                    goalData[sliderIndex]['currentAmount'].toDouble(),
                totalAmount: goalData[sliderIndex]['totalAmount'].toDouble(),
                sliderCount: goalData.length),
            const SizedBox(height: 26),
            Text('Total Amount: \$${goalData[sliderIndex]['totalAmount']}'),
            Text('Current Amount: \$${goalData[sliderIndex]['currentAmount']}'),
            Text('Target Date: ${goalData[sliderIndex]['targetDate']}'),
            SizedBox(height: 24),
            Text(
              'Contribution History:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ContributionHistoryList(
                contributions: goalData[sliderIndex]['contributions']),
          ],
        ),
      ),
    );
  }
}

class ContributionHistoryList extends StatelessWidget {
  final List<dynamic> contributions;

  ContributionHistoryList({required this.contributions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: contributions.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> contribution = contributions[index];
        String date = contribution['date'];
        dynamic amount = contribution['amount'];

        // Check if 'amount' is a String and convert it to double if needed
        double? amountDouble =
            amount is String ? double.tryParse(amount) : amount?.toDouble();

        return ListTile(
          title: Text('Date: $date'),
          subtitle: Text(
              'Amount: ${amountDouble != null ? '\$$amountDouble' : 'N/A'}'),
        );
      },
    );
  }
}
