import 'package:app/settings/themeChanger.dart';
import 'package:flutter/material.dart';
import 'package:app/settings/documentation_page.dart';
import 'package:provider/provider.dart';
import 'package:android_intent/android_intent.dart';

class SettingsPage extends StatefulWidget {
  final String title;

  SettingsPage({Key key, this.title}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _goToDocumentation() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DocumentationPage()),
    );
  }

  ThemeModel selectedTheme = ThemeModel();
  List<ThemeModel> _theme;
  int selectedRadio;
  String themeName;

  @override
  void initState() {
    super.initState();
    selectedRadio = 1;
    _theme = ThemeModel.getTheme();
    themeName = 'Light Mode';
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  setSelectedTheme(ThemeModel theme, ThemeChanger themeProvider) {
    setState(() {
      selectedTheme = theme;
      if (selectedTheme.name == 'Dark Mode') {
        themeProvider.makeDark(true);
      } else if (selectedTheme.name == 'Light Mode') {
        themeProvider.makeDark(false);
      }
    });
  }

  setThemeName(ThemeChanger themeProvider) {
    setState(() {
      if (themeProvider.whatTheme()) {
        themeName = 'Dark Mode';
      } else {
        themeName = 'Light Mode';
      }
    });
  }

  List<Widget> createRadioListThemes(ThemeChanger themeChanger) {
    List<Widget> widgets = [];
    for (ThemeModel theme in _theme) {
      widgets.add(
        RadioListTile(
          value: theme,
          groupValue: selectedTheme,
          title: Text(theme.name),
          onChanged: (currentTheme) {
            print("Current Theme ${currentTheme.name}");
            setSelectedTheme(currentTheme, themeChanger);
          },
          selected: selectedTheme == theme,
        ),
      );
    }
    return widgets;
  }

  void _openNotificationSettings() {
    final AndroidIntent intent = AndroidIntent(
      action: 'action_application_details_settings',
      data: 'package:com.mosquito.app',
    );
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeChanger>(context);
    String chosenLocation = ('Default (Canada)');
    setThemeName(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(padding: const EdgeInsets.all(10), children: <Widget>[
        ListTile(
            title: Text('Theme'),
            subtitle: Text('$themeName'),
            onTap: () {
              themeAlert(context, selectedRadio, themeProvider);
              print('Radio: $themeName');
            }),
        ListTile(
            //currently the location picker is using placeholders
            title: Text('Location'),
            subtitle: Text(chosenLocation),
            onTap: () {
              locationDialog(context);
            }),
        ListTile(
            //planned to take the user to the Android System notification
            //settings where they can see all the nofication channels
            title: Text('Manage Notifications'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              _openNotificationSettings();
            }),
        ListTile(
            title: Text('Documentation'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              _goToDocumentation();
            }),
      ]),
    );
  }

  //pops up an alert dialog that gives the option between light and dark mode for
  //the app theme
  Widget themeAlert(
      BuildContext context, int selectedRadio, ThemeChanger themeChanger) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Theme'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: createRadioListThemes(themeChanger),
            );
          }),
        );
      },
    );
  }
}

class ThemeModel {
  String name;
  int index;
  ThemeModel({this.name, this.index});

  static List<ThemeModel> getTheme() {
    return <ThemeModel>[
      ThemeModel(name: "Light Mode", index: 1),
      ThemeModel(name: "Dark Mode", index: 2),
    ];
  }
}

//currently using placeholders for locations
Widget locationDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Country'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 200,
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: Text('Australia'),
                      onTap: () {
                        //setState(() => chosenLocation = 'Australia')
                      },
                    ),
                    ListTile(
                      title: Text('Default (Canada)'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Germany'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Japan'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('United States'),
                      onTap: () {},
                    ),
                  ]),
            ),
          );
        }),
      );
    },
  );
}