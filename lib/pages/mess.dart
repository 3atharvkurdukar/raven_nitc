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


/*
Text(add(breakfast, "breakfast")),
                      Text(add(lunch, "Lunch")),
                      Text(add(snacks, "snacks")),
                      Text(add(dinner, "dinner"))
class MessPage extends StatelessWidget {
  const MessPage({super.key});
  void dummy(){

  }

  @override
  Widget build(BuildContext context) {
    final List<bool> _selectedMess = <bool>[true, false];
    const List<Widget> mess = <Widget>[
      Text('Registered'),
      Text('AllMess'),
    ];
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
                  Icon(Icons.chevron_left, color: Colors.grey),
                  Text(DateFormat('E, MMM d').format(DateTime.now()),
                      style: Theme.of(context).textTheme.headlineSmall),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: ToggleButtons(
                    direction: Axis.horizontal,
                    children: mess,
                    isSelected: _selectedMess,
                    onPressed: (int index) {
                      dummy();
                      // d
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text('E Mess',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Breakfast',
                          style: Theme.of(context).textTheme.labelLarge),
                      Text('Poori, Aloo Sabji, Tea, Coffee, Milk',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

*/

/*
import 'package:flutter/material.dart';

const List<Widget> fruits = <Widget>[
  Text('Apple'),
  Text('Banana'),
  Text('Orange')
];


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'ToggleButtons Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: ToggleButtonsSample(title: _title),
    );
  }
}

class ToggleButtonsSample extends StatefulWidget {
  const ToggleButtonsSample({super.key, required this.title});

  final String title;

  @override
  State<ToggleButtonsSample> createState() => _ToggleButtonsSampleState();
}

class _ToggleButtonsSampleState extends State<ToggleButtonsSample> {
  final List<bool> _selectedFruits = <bool>[true, false, false];
  final List<bool> _selectedVegetables = <bool>[false, true, false];
  final List<bool> _selectedWeather = <bool>[false, false, true];
  bool vertical = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ToggleButtons with a single selection.
              Text('Single-select', style: theme.textTheme.titleSmall),
              const SizedBox(height: 5),
              ToggleButtons(
                direction: vertical ? Axis.vertical : Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedFruits.length; i++) {
                      _selectedFruits[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.red[700],
                selectedColor: Colors.white,
                fillColor: Colors.red[200],
                color: Colors.red[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: _selectedFruits,
                children: fruits,
              ),
              const SizedBox(height: 20),
              // ToggleButtons with a multiple selection.
              Text('Multi-select', style: theme.textTheme.titleSmall),
              const SizedBox(height: 5),
              ToggleButtons(
                direction: vertical ? Axis.vertical : Axis.horizontal,
                onPressed: (int index) {
                  // All buttons are selectable.
                  setState(() {
                    _selectedVegetables[index] = !_selectedVegetables[index];
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.green[700],
                selectedColor: Colors.white,
                fillColor: Colors.green[200],
                color: Colors.green[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: _selectedVegetables,
                children: vegetables,
              ),
              const SizedBox(height: 20),
              // ToggleButtons with icons only.
              Text('Icon-only', style: theme.textTheme.titleSmall),
              const SizedBox(height: 5),
              ToggleButtons(
                direction: vertical ? Axis.vertical : Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedWeather.length; i++) {
                      _selectedWeather[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.blue[700],
                selectedColor: Colors.white,
                fillColor: Colors.blue[200],
                color: Colors.blue[400],
                isSelected: _selectedWeather,
                children: icons,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            // When the button is pressed, ToggleButtons direction is changed.
            vertical = !vertical;
          });
        },
        icon: const Icon(Icons.screen_rotation_outlined),
        label: Text(vertical ? 'Horizontal' : 'Vertical'),
      ),
    );
  }
}

*/
