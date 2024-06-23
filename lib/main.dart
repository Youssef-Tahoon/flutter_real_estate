import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_real_estate/pages/login_page.dart';
import 'package:flutter_real_estate/pages/home.dart';
import 'package:flutter_real_estate/pages/settings_page.dart';
import 'package:flutter_real_estate/theme/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


// await Firebase.initializeApp(
// options: DefaultFirebaseOptions.currentPlatform,
// );

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  MyApp({required this.isDarkMode});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  void _toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = value;
    });
    await prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real Estate App',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const LoginPage(),
      routes: {
        '/settings': (context) => SettingsPage(
          isDarkMode: isDarkMode,
          toggleDarkMode: _toggleDarkMode,
        ),
        '/home': (context) => HomePage(),
      },
    );
  }
}
