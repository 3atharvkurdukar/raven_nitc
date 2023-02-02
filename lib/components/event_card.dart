import 'package:flutter/material.dart';
import 'package:raven_nitc/pages/event_description.dart';

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
          MaterialPageRoute(builder: (context) => EventDescription(id: id)),
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



//  child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SignUp()),
//                   );
//                 },
//                 child: SizedBox(
//                     width: 150.0,
//                       child: Text(
//                         'Sign Up',
//                         style: GoogleFonts.poppins(
//                           fontSize: 26,
//                           color: const Color(0xff202020),
//                           fontWeight: FontWeight.w600,
//                           height: 0.9615384615384616,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                 ),
//               )
