import 'package:flutter/material.dart';

class AmenitiesPage extends StatelessWidget {
  const AmenitiesPage({super.key});

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
              Text('Amenities',
                  style: Theme.of(context).textTheme.headlineSmall),
              OutlinedButton(onPressed: null, child: Text('View All')),
            ],
          ),
        ),
      ],
    );
  }
}
