import 'package:flutter/material.dart';
import 'package:raven_nitc/components/announcements.dart';

class AllAnnouncementsPage extends StatelessWidget {
  const AllAnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Announcements'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[Announcements()]),
          ),
        ],
      ),
    );
  }
}
