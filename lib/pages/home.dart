import 'package:flutter/material.dart';
import 'package:raven_nitc/components/announcement_card.dart';
import 'package:raven_nitc/components/event_card.dart';
import 'all_events.dart';
import 'all_announcements.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              Text('Events', style: Theme.of(context).textTheme.headlineSmall),
              OutlinedButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllEventsPage(),
                    ),
                  );
                },
                child: Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: EventCard(
                title: 'Event $index',
                imageUrl: 'https://picsum.photos/seed/$index/480/640',
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Announcements',
                  style: Theme.of(context).textTheme.headlineSmall),
              OutlinedButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllAnnouncementsPage(),
                    ),
                  );
                },
                child: Text('View All'),
              ),
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