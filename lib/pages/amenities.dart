import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Amenity extends StatelessWidget {
  const Amenity({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: AmenitiesPage(),
    );
  }
}

class AmenitiesPage extends StatefulWidget {
  const AmenitiesPage({super.key});

  @override
  AmenityDetails createState() {
    return AmenityDetails();
  }
}

class AmenityDetails extends State<AmenitiesPage> {
  Future<void> apiCall() async {}

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  var count = 0;

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('amenities').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            count += 1;
                          });
                        },
                        child: Icon(Icons.chevron_left, color: Colors.grey)),
                    Text(DateFormat('E, MMM d').format(
                        DateTime.now().subtract(Duration(days: count)))),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          count -= 1;
                        });
                      },
                      child: Icon(Icons.chevron_right, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              ...data.map((d) =>
                  AmenityCard(name: d['name'], timings: d[getWeekday()])),
            ],
          );
        }
        return Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class AmenityCard extends StatelessWidget {
  final String name;
  final List<dynamic> timings;

  AmenityCard({super.key, required this.name, required this.timings});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      timings.isEmpty ? Text('Closed') : Container(),
                      ...timings
                          .map((t) => t['gender'] != null
                              ? Text(
                                  "${t['gender']}: ${t['startTime']} to ${t['endTime']}")
                              : Text("${t['startTime']} to ${t['endTime']}"))
                          .toList(),
                    ])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
