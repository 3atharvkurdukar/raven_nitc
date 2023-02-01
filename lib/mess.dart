import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessPage extends StatelessWidget {
  const MessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.chevron_left, color: Colors.grey),
                  Text(DateFormat('E, MMM d').format(DateTime.now()),
                      style: Theme.of(context).textTheme.headlineSmall),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text('E Mess',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Breakfast',
                          style: Theme.of(context).textTheme.labelLarge),
                      Text('Poori, Aloo Sabji, Tea, Coffee, Milk',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
