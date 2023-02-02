import 'package:flutter/material.dart';
import 'package:raven_nitc/components/announcement_card.dart';

class AllAnnouncementsPage extends StatelessWidget {
  const AllAnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Events'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (int i = 0; i < 5; i++)
                    AnnouncementCard(
                        sender: 'Sender $i', title: 'Announcement $i')
                ]),
          ),
        ],
      ),
    );
  }
}
