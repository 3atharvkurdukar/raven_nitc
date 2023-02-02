import 'package:flutter/material.dart';
import 'package:raven_nitc/components/event_card.dart';

class AllEventsPage extends StatelessWidget {
  const AllEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          child:
              Text('Events', style: Theme.of(context).textTheme.headlineSmall),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: EventCard(
              title: 'Event $index',
              imageUrl: 'https://picsum.photos/seed/$index/480/640',
            ),
          ),
        ),
      ],
    );
  }
}
