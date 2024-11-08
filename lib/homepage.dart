import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Pages/detailed_medicine_itemPage.dart';
import 'widgets/add_reminder.dart';
import 'widgets/medecineItem.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(children: [
        // Background Image
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 300, // Adjust height as needed
            decoration: BoxDecoration(
              color: Colors.green[200],
            ),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Ensure the column fits content
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align content to the left
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          // Wrap the Text with Flexible for potential wrapping
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 25,
                              ),
                              Text(
                                'Hello\nAlina bon',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height:
                            10.0), // Add spacing between Row and ElevatedButton
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        minimumSize: const Size(
                            double.infinity, 48.0), // Directly provide the Size
// Ensure full width
                      ),
                      child: const Text(
                        'CREATE\nNEW SCHEDULE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("medicine")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Text('No data here :(');
                  }
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      List<dynamic> timesList =
                          snapshot.data!.docs[index].data()['times'].toList();
                      List<Timestamp> timestampList = timesList.map((time) {
                        return Timestamp.fromDate(time.toDate());
                      }).toList();

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MedicineDetailPage(
                                      medicineItem: MedicineItem(
                                        medicineType: snapshot.data!.docs[index]
                                            .data()['medicineType'],
                                        frequency: snapshot.data!.docs[index]
                                            .data()['frequency'],
                                        medicineName: snapshot.data!.docs[index]
                                            .data()['name'],
                                        dosage: snapshot.data!.docs[index]
                                            .data()['dosage'],
                                        times: timestampList
                                            .map((timestamp) =>
                                                DateFormat('hh:mm a')
                                                    .format(timestamp.toDate()))
                                            .toList(),
                                        startDate: snapshot.data!.docs[index]
                                            .data()['startdate'],
                                        endDate: snapshot.data!.docs[index]
                                            .data()['enddate'],
                                      ),
                                    )),
                          );
                        },
                        child: MedicineItem(
                          medicineType:
                              snapshot.data!.docs[index].data()['medicineType'],
                          frequency:
                              snapshot.data!.docs[index].data()['frequency'],
                          medicineName:
                              snapshot.data!.docs[index].data()['name'],
                          dosage: snapshot.data!.docs[index].data()['dosage'],
                          times: timestampList
                              .map((timestamp) => DateFormat('hh:mm a')
                                  .format(timestamp.toDate()))
                              .toList(),
                          startDate: snapshot.data!.docs[index]
                              .data()['start_date']
                              .toDate(),
                          endDate: snapshot.data!.docs[index]
                              .data()['end_date']
                              .toDate(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true, // Allow content to scroll if needed

            context: context,
            builder: (context) => const AddReminderBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
