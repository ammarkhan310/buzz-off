import 'package:app/mosquito_model/mosquito_db.dart';
import 'package:app/profile/model/active_profile.dart';
import 'package:app/profile/model/address.dart';
import 'package:app/profile/model/profile.dart';
import 'package:app/settings/themeChanger.dart';
import 'package:app/statistics/view/bitesChart.dart';
import 'package:flutter/material.dart';
import 'package:app/nav_page.dart';
import 'package:app/profile/view/profile_page.dart';
import 'package:app/profile/view/create_edit_profile.dart';
import 'package:app/profile/view/create_edit_address.dart';
import 'package:app/profile/view/profile_selector.dart';
import 'package:provider/provider.dart';
import 'package:app/statistics/view/statistics_page.dart';
import 'statistics/model/biteModel.dart';
import 'package:app/settings/settings_page.dart';
import 'package:app/home_page.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:app/notifications.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/profile/model/active_profile.dart';

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'en',
        basePath: 'assets/flutter_i18n'),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await flutterI18nDelegate.load(null);
  runApp(
    // Initializes Providers and Consumer Listeners
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileModel()),
        ChangeNotifierProvider(create: (_) => AddressModel()),
        ChangeNotifierProvider(create: (_) => ActiveUserModel()),
        ChangeNotifierProvider(create: (_) => BiteListBLoC()),
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
      ],
      child: MyApp(flutterI18nDelegate),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FlutterI18nDelegate flutterI18nDelegate;
  final _notifications = Notifications();

  MyApp(this.flutterI18nDelegate);

  String _title = '';
  String _body = '';
  String _payload = '';

  Future<void> _displayNotification() async {
    tz.initializeTimeZones();
    _notifications.init();

    var when = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    List<String> infoList = await MosquitoDb().getInfoList();
    await _notifications.sendNotificationLater(
        infoList[0],
        'Location Rating: ${infoList[1]} Weather Conditions: ${infoList[2]}',
        when,
        _payload);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeChanger>(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return FutureBuilder(
        //Initialize cloud database
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          //Notify if there is an error within the database
          if (snapshot.hasError) {
            print('Error initializing firebase');
            return Text('Error initializing firebase');
          }
          //Wait for database connection
          if (snapshot.connectionState == ConnectionState.done) {
            _displayNotification();
            return MaterialApp(
              title: 'Mobile Development Group Project',
              theme: themeProvider.getDarkMode()
                  ? ThemeData.dark()
                  : ThemeData(
                      primarySwatch: Colors.green,
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                    ),
              home: MyHomePage(title: 'Buzz Off'),
              localizationsDelegates: [
                flutterI18nDelegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
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
  bool first = true;
  
  //Index for current page showing
  int _currentIndex = 0;
  Profile activeUserData;
  UserAccountsDrawerHeader drawerHeader = UserAccountsDrawerHeader(
    decoration: BoxDecoration(
      color: Colors.transparent,
    ),
    accountEmail: Text('place_holder@buzzOff.ca'),
    accountName: Text('place_holder'),
    currentAccountPicture: CircleAvatar(
      child: Text('PH'),
    ),
    otherAccountsPictures: [
      CircleAvatar(
        child: Text('A2'),
      ),
      CircleAvatar(
        child: Text('A3'),
      ),
    ],
  );

  //Titles of the pages that can be shown
  final List<Map> _titles = [
    {'header': 'Buzz Off'},
    {'header': 'Statistics'},
    {'header': 'Profile'},
    {'header': 'Settings'}
  ];

  //List of pages that can be inserted as the children for the main body
  final List<Widget> _children = [
    HomePage(),
    StatisticsPage(title: 'statistics'),
    ProfilePage(title: 'profile'),
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

  ActiveUserModel _activeUserModel = ActiveUserModel();

  Future<ActiveUser> getUser() async {
    return await _activeUserModel.getActiveUserId();
  }

  ProfileModel _profileModel = ProfileModel();

  Future<Profile> getProfile(int id) async {
    return await _profileModel.getProfileById(id);
  }

  void setDrawerState(UserAccountsDrawerHeader newDrawerHeader) {
    if(first){
      setState(() {
        drawerHeader = newDrawerHeader;
        first = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileModel profileList = context.watch<ProfileModel>();
    final ActiveUserModel activeUserModel = context.watch<ActiveUserModel>();

    return Scaffold(
      appBar: AppBar(
          title: Text(_titles[_currentIndex]['header']),
          actions: appBarIcons(_titles[_currentIndex]['header'], context)),
      //Hamburger menu below
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          FutureBuilder(
            future: activeUserModel.getActiveUserId(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Fetches profile data for the current active user
                var activeUserId = snapshot.data.id;
                getDrawerProfile(context, activeUserId, profileList);
              }
              return drawerHeader;
            },
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text(FlutterI18n.translate(context, "drawer.profile")),
            onTap: () {
              Navigator.of(context).pop();
              onItemTapped(2);
            },
          ),
          ListTile(
            leading: Icon(Icons.trending_up),
            title: Text(FlutterI18n.translate(context, "drawer.statistics")),
            onTap: () {
              Navigator.of(context).pop();
              onItemTapped(1);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(FlutterI18n.translate(context, "drawer.settings")),
            onTap: () {
              Navigator.of(context).pop();
              _goToSettings();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 350.0, left: 120.0),
            child: Row(
              children: [
                FlatButton(
                  child: Text('EN'),
                  onPressed: () async {
                    print('Switching to english');
                    Locale newLocale = Locale('en');
                    await FlutterI18n.refresh(context, newLocale);
                    setState(() {});
                  },
                ),
                FlatButton(
                  child: Text('FR'),
                  onPressed: () async {
                    print('Switching to french');
                    Locale newLocale = Locale('fr');
                    await FlutterI18n.refresh(context, newLocale);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      )),
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

  Future<void> getDrawerProfile(
    BuildContext context, var userId, ProfileModel profileModel) async {
    ProfileModel profileList = profileModel;
    var activeUserId = userId;

    if (activeUserId != null) {
      await profileList.getProfileById(activeUserId).then((profileData) {
        activeUserData = profileData;
      });
    }

    buildDrawerHeader(context);
  }

  void buildDrawerHeader(BuildContext context) {
    print('$activeUserData');
    UserAccountsDrawerHeader drawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      accountEmail: Text(
          '${activeUserData.toString()}${DateTime.parse(activeUserData.dob).year.toString().substring(2)}@buzzOff.ca'),
      accountName: Text('${activeUserData.toString()}'),
      currentAccountPicture: CircleAvatar(
        child: Text('${activeUserData.toString().substring(0, 1)}'),
      ),
      otherAccountsPictures: [
        CircleAvatar(
          child: Text('A2'),
        ),
        CircleAvatar(
          child: Text('A3'),
        ),
      ],
    );
    setDrawerState(drawerHeader);
  }

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Renders appbar icons based on the current screen
  List<Widget> appBarIcons(key, context) {
    if (key == 'Statistics') {
      return [
        // Allows user to view bar chart of their weekly mosquito bites
        IconButton(
          icon: Icon(Icons.bar_chart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BitesChart()),
            );
          },
        )
      ];
    } else if (key == 'Profile') {
      return [
        Row(
          children: <Widget>[
            Builder(
              builder: (BuildContext context) {
                // Renders an icon in the app bar to allow the user to
                // switch the current active user
                return IconButton(
                  padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                  icon: Icon(Icons.swap_horiz_outlined),
                  onPressed: () async {
                    final SnackBar snackbar = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectProfile(
                          title: 'Profile Selector',
                        ),
                      ),
                    );

                    // Displays a snackbar indicating that the current active
                    // user has changed
                    if (snackbar != null) {
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(snackbar);
                    }
                  },
                );
              },
            )
          ],
        )
      ];
    } else {
      // Default Settings Icon
      return [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            _goToSettings();
          },
        )
      ];
    }
  }
}
