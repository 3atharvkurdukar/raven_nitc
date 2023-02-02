import 'package:flutter/material.dart';
import 'package:raven_nitc/components/announcement_card.dart';

class AllAnnouncementsPage extends StatelessWidget {
  const AllAnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Announcements',
                  style: Theme.of(context).textTheme.headlineSmall),
              // OutlinedButton(onPressed: null, child: Text('View All')),
            ],
          ),
        ),
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
    );
  }
}
