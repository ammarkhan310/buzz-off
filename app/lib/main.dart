import 'package:app/model/address.dart';
import 'package:app/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:app/nav_page.dart';
import 'package:app/profile_page.dart';
import 'package:app/profile_page_edit.dart';
import 'package:app/edit_address_form.dart';
import 'package:app/choose_profile.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Initializes Providers and Consumer Listeners
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileModel()),
        ChangeNotifierProvider(create: (_) => AddressModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    ProfilePage(title: 'home'),
    ProfilePage(title: 'statistics'),
    ProfilePage(title: 'profile'),
    ProfilePage(title: 'statistics'),
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
