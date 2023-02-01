import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raven_nitc/amenities.dart';
import 'package:raven_nitc/home.dart';
import 'package:raven_nitc/mess.dart';
import 'package:raven_nitc/profile.dart';

void main() {
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
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Color.fromARGB(255, 35, 35, 35),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
          ),
          cardTheme: CardTheme(
            color: Colors.black45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xFF1D1D1D), width: 1),
            ),
          ),
        ),
        home: MyNavigator(),
      ),
    );
  }
}

class MyNavigator extends StatelessWidget {
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

class PageControllerModel with ChangeNotifier {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  PageController get pageController => _pageController;
}
