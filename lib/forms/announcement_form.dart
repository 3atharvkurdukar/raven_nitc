import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AnnouncementForm extends StatelessWidget {
  const AnnouncementForm({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Add Announcement';

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: const MyCustomForm(),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  DateTime date = DateTime.now();

  String _title = '';
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();
  bool loading = false;

  Future<void> submitHandler() async {
    if (loading) return;
    loading = true;
    if (_title.isEmpty || _title.length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Title must be less than 50 characters and non empty'),
          backgroundColor: Colors.white));
      loading = false;
      return;
    }
    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Start Date must be before End Date'),
          backgroundColor: Colors.white));
      loading = false;
      return;
    } else if (startDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Start Time must be after current time'),
          backgroundColor: Colors.white));
      loading = false;
      return;
    }
    await FirebaseFirestore.instance.collection('announcements').add({
      'title': _title,
      'startTime': startDateTime,
      'endTime': endDateTime,
      'createdAt': DateTime.now(),
      'authority': FirebaseAuth.instance.currentUser!.uid
    });
    loading = false;
    Navigator.of(context).pop();

    //print('##########################');
    //print(_formKey.currentState);
    // print('##########################');
    // we need to fire the Firebase API
    // we need to add validation for image size and if image exists
    // we need to then navigate to a different page

    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return ListView(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  // The validator receives the text that the user has entered.
                  decoration: InputDecoration(
                      hintText: 'Announcement Title',
                      border: OutlineInputBorder()),
                  onChanged: (value) => setState(() {
                    _title = value;
                  }),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Announcement Start Date'),
                    Padding(
                      padding: EdgeInsets.all(16),
                    ),
                    SizedBox(
                      height: 100,
                      width: 350,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        initialDateTime: DateTime.now(),
                        // maximumYear: 2025,
                        // minimumYear: 2021,
                        onDateTimeChanged: (DateTime newDateTime) {
                          startDateTime = newDateTime;
                        },
                        use24hFormat: false,

                        minuteInterval: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Announcement End Date'),
                    Padding(
                      padding: EdgeInsets.all(16),
                    ),
                    SizedBox(
                      height: 100,
                      width: 350,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        initialDateTime: DateTime.now(),
                        // maximumYear: 2025,
                        // minimumYear: 2021,
                        // dateOrder: CupertinoDatePickerDateOrder.mdy,
                        onDateTimeChanged: (DateTime newDateTime) {
                          endDateTime = newDateTime;
                        },
                        use24hFormat: false,
                        minuteInterval: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: !loading ? submitHandler : null,
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
