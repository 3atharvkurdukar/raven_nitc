import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raven_nitc/navigator.dart';
import 'package:raven_nitc/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:raven_nitc/seed.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // populateMessDB();
  // populateAmenitiesDB();
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
