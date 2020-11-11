import 'package:app/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:app/nav_page.dart';
import 'package:app/statistics/view/statistics_page.dart';
import 'package:app/test_page.dart';
import 'package:provider/provider.dart';
import 'statistics/model/biteModel.dart';
import 'package:app/settings/settings_page.dart';
import 'package:app/home_page.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/mosquito_model/mosquito_db.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => BiteListBLoC()),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error initializing firebase');
            return Text('Error initializing firebase');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Mobile Development Group Project',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: MyHomePage(title: 'Buzz Off'),
              debugShowCheckedModeBanner: false,
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  //Array of dummy values for navigation destions
  List<NavPage> _navBarItems = [
    NavPage(title: 'Home', icon: Icons.home),
    NavPage(title: 'Statistics', icon: Icons.trending_up),
    NavPage(title: 'Profile', icon: Icons.account_box),
  ];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<String> _titles = [
    "Buzz off",
    "Statistics",
    "Profile",
    "Settings",
  ];

  final List<Widget> _children = [
    HomePage(),
    StatisticsPage(title: 'statistics'),
    TestPage(Colors.blue),
  ];

  void _setHomePageState() {
    setState(() {});
  }

  void _goToSettings() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex]), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            _goToSettings();
          },
        ),
      ]),
      body: Center(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onItemTapped, // new
        currentIndex: _currentIndex, // new
        items: widget._navBarItems.map((NavPage page) {
          return BottomNavigationBarItem(
              icon: Icon(page.icon), title: Text(page.title));
        }).toList(),
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
