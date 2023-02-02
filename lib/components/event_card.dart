import 'package:flutter/material.dart';
import 'package:raven_nitc/pages/event_details.dart';

class EventCard extends StatelessWidget {
  const EventCard(
      {super.key, required this.title, required this.id, this.imageUrl});

  final String title;
  final String id;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    Widget cardBody = Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      width: 240,
    );

    if (imageUrl == null) {
      cardBody = Container(
        width: 240,
        alignment: Alignment.center,
        margin: EdgeInsets.all(16),
        child: Text(
          title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDetailsPage(docId: id)),
        );
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: cardBody,
      ),
    );
  }
}
