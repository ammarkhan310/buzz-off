import 'package:app/profile/model/address.dart';
import 'package:app/profile/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:app/nav_page.dart';
import 'package:app/profile/view/profile_page.dart';
import 'package:app/profile/view/create_edit_profile.dart';
import 'package:app/profile/view/create_edit_address.dart';
import 'package:app/profile/view/profile_selector.dart';
import 'package:provider/provider.dart';
import 'package:app/statistics/view/statistics_page.dart';
import 'package:app/test_page.dart';
import 'statistics/model/biteModel.dart';
import 'package:app/home_page.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/mosquito_model/mosquito_db.dart';

void main() {
  runApp(
    // Initializes Providers and Consumer Listeners
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileModel()),
        ChangeNotifierProvider(create: (_) => AddressModel()),
        ChangeNotifierProvider(create: (_) => BiteListBLoC()),
      ],
      child: MyApp(),
    ),
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
              routes: <String, WidgetBuilder>{
                '/createEditProfile': (BuildContext context) {
                  return CreateEditProfile(title: 'Create/Edit Profile');
                },
                '/createEditAddress': (BuildContext context) {
                  return CreateEditAddress(title: 'Create/Edit Address');
                },
                '/chooseProfile': (BuildContext context) {
                  return SelectProfile(title: 'Choose Profile');
                },
              },
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

  final List<Map> _titles = [
    {'header': 'Buzz Off', 'showHeader': true},
    {'header': 'Statistics', 'showHeader': true},
    {'header': 'Profile', 'showHeader': false},
    {'header': 'Settings', 'showHeader': true}
  ];

  final List<Widget> _children = [
    HomePage(),
    StatisticsPage(title: 'statistics'),
    ProfilePage(title: 'profile'),
  ];

  void _setHomePageState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _titles[_currentIndex]['showHeader']
          ? AppBar(
              title: Text(_titles[_currentIndex]['header']),
            )
          : null,
      body: _children[_currentIndex],
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
