import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:cross_file_image/cross_file_image.dart';

class EventForm extends StatelessWidget {
  const EventForm({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Add Event';

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
  File? _image;
  String title = '';
  String description = '';
  // XfileImage? image;
  DateTime? startDateTime;
  DateTime? endDateTime; // this thing we need to resolve!
  String downloadUrl = '';

  TextEditingController dateController = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  DateTime date = DateTime.now();
  bool loading = false;

  Future getImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image != null ? image.path : image!.path);
    });
  }

  Future<void> eventHandler() async {
    if (loading) return;
    loading = true;
    if (title.isEmpty || title.length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Title must be less than 50 characters and non empty'),
          backgroundColor: Colors.white));
      loading = false;
      return;
    } else if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Description cannot be empty'),
          backgroundColor: Colors.white));
      loading = false;
      return;
    } else if (startDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a date and time'),
          backgroundColor: Colors.white));
      loading = false;
      return;
    } else if (endDateTime != null && endDateTime!.isBefore(startDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Start Date must be before End Date'),
          backgroundColor: Colors.white));
      loading = false;
      return;
    } else if (startDateTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Start Time must be after current time'),
          backgroundColor: Colors.white));
      loading = false;
      return;
    }

    if (_image != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      String path = _image!.path.split("/").last;
      Reference ref = storage.ref().child("events/$path");
      UploadTask uploadTask = ref.putFile(_image!);
      await uploadTask.whenComplete(() => print('File Uploaded'));
      downloadUrl = await ref.getDownloadURL();
    }

    print("this is the download url $downloadUrl");
    await FirebaseFirestore.instance.collection('events').add({
      'title': title,
      'description': description,
      'startTime': startDateTime,
      'endTime': endDateTime,
      'createdAt': DateTime.now(),
      'imageUrl': downloadUrl != '' ? downloadUrl : null,
      'authority': FirebaseAuth.instance.currentUser!.uid,
    });
    // should disable the submit button and show a loadder
    loading = false;
    Navigator.of(context).pop();
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
                      hintText: 'Event Name', border: OutlineInputBorder()),
                  onChanged: (value) => setState(() {
                    title = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length > 30) {
                      return 'Name should be less than 30 characters';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  maxLines: 8,
                  // The validator receives the text that the user has entered.
                  decoration: InputDecoration(
                      hintText: 'Event Description',
                      border: OutlineInputBorder()),
                  onChanged: (value) => setState(() {
                    description = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  // The validator receives the text that the user has entered.
                  decoration: InputDecoration(
                      hintText: 'Event Venue', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Event Start Date'),
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
                          //Do Some thing
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
                    Text('Event End Date'),
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
                  children: [
                    Text('Event Image'),
                    OutlinedButton(
                      onPressed: () {
                        getImage();
                      },
                      child: Text('Select Image'),
                    ),
                  ],
                ),
              ),
              _image != null
                  ? Padding(
                      padding: EdgeInsets.all(16),
                      child: Image.file(
                        _image!,
                        width: 200,
                        height: 200,
                      ),
                    )
                  : Container(),
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
                      onPressed: !loading ? eventHandler : null,
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
