import 'package:flutter/material.dart';
import 'package:raven_nitc/components/events.dart';

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
        Events(),
      ],
    );
  }
}
