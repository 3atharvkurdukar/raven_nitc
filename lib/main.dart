import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raven_nitc/pages/amenities.dart';
import 'package:raven_nitc/pages/home.dart';
import 'package:raven_nitc/pages/mess.dart';
import 'package:raven_nitc/pages/profile.dart';
import 'package:raven_nitc/navigator.dart';
import 'package:raven_nitc/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PageControllerModel(),
      child: MaterialApp(
        title: 'Raven for NITC',
        theme: ThemeData.dark().copyWith(
          splashColor: Colors.black,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Color.fromARGB(255, 35, 35, 35),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
          ),
          cardTheme: CardTheme(
            color: Colors.black45,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        home: AuthPage(),
      ),
    );
  }
}

class MyNavigator extends StatelessWidget {
  final String title = 'Speed dial';

  SpeedDial _speedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: IconThemeData(size: 22.0),
      backgroundColor: Colors.white,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.calendar_today),
          backgroundColor: Colors.black,
          label: 'New Event',
          labelStyle: TextStyle(fontSize: 18.0),
          labelBackgroundColor: Colors.transparent,
          onTap: () => print('FIRST CHILD'),
        ),
        SpeedDialChild(
          child: Icon(Icons.campaign_outlined),
          backgroundColor: Colors.black,
          label: 'New Announcement',
          labelStyle: TextStyle(fontSize: 18.0),
          labelBackgroundColor: Colors.transparent,
          onTap: () => print('SECOND CHILD'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<PageControllerModel>(context);
    return Scaffold(
      body: PageView(
        controller: model.pageController,
        children: [
          HomePage(),
          MessPage(),
          AmenitiesPage(),
          ProfilePage(),
        ],
        onPageChanged: (index) {
          model.selectedIndex = index;
        },
      ),
      floatingActionButton: _speedDial(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Mess',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_tennis),
            label: 'Amenities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: model.selectedIndex,
        onTap: (index) {
          model.pageController.jumpToPage(index);
        },
      ),
    );
  }
}
