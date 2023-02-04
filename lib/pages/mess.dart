import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessPage extends StatelessWidget {
  const MessPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: MessDetails(),
    );
  }
}

class MessDetails extends StatefulWidget {
  const MessDetails({super.key});

  @override
  Mess createState() {
    return Mess();
  }
}

class Mess extends State<MessDetails> {
  int count = 0;

  final List<bool> _selectedMess = <bool>[true, false];

  String getWeekday() {
    Map<int, String> weekdays = {
      1: "mon",
      2: "tue",
      3: "wed",
      4: "thu",
      5: "fri",
      6: "sat",
      7: "sun"
    };

    return weekdays[DateTime.now().subtract(Duration(days: count)).weekday]!;
  }

  List<Widget> mess = <Widget>[
    Text('Registered'),
    Text('AllMess'),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('messTimetables').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            Text('Something went wrong');
          }
          if (snapshot.hasData && snapshot.data!.size == 0) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
            return ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    count += 1;
                                  });
                                },
                                child: Icon(Icons.chevron_left,
                                    color: Colors.grey)),
                            Text(DateFormat('E, MMM d').format(DateTime.now()
                                .subtract(Duration(days: count)))),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  count -= 1;
                                });
                              },
                              child:
                                  Icon(Icons.chevron_right, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    )),
                ...data.map((d) => MessCard(
                    name: d['name'],
                    vegOnly: d['vegOnly'],
                    breakfast: d[getWeekday()]["breakfast"],
                    lunch: d[getWeekday()]["lunch"],
                    snacks: d[getWeekday()]["snacks"],
                    dinner: d[getWeekday()]["dinner"]))
              ],
            );
          }
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        });
  }
}

class MessCard extends StatelessWidget {
  final String name;
  final List<dynamic> breakfast;
  final List<dynamic> lunch;
  final List<dynamic> snacks;
  final List<dynamic> dinner;
  final bool vegOnly;
  MessCard(
      {super.key,
      required this.name,
      required this.vegOnly,
      required this.breakfast,
      required this.lunch,
      required this.snacks,
      required this.dinner});

  String add(List<dynamic> lst, String time) {
    var ite = lst.asMap().entries.iterator;
    String fs = "$time: ";
    int count = 0;
    while (ite.moveNext()) {
      print("This is count $count");
      fs += ite.current.value + ", ";
      count += 1;
    }
    return fs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            name,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(16),
                    child:
                        Column(children: [Text(add(breakfast, "Breakfast"))])),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(children: [Text(add(lunch, "Lunch"))])),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(children: [Text(add(snacks, "Snacks"))])),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(children: [Text(add(dinner, "Dinner"))])),
              ],
            ),
          )
        ],
      ),
    );
  }
}
