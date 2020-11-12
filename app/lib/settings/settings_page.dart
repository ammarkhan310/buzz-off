import 'package:app/settings/themeChanger.dart';
import 'package:flutter/material.dart';
import 'package:app/settings/documentation_page.dart';
import 'package:provider/provider.dart';

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

  static int selectedRadio = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeChanger>(context);
    String chosenLocation = ('Default (Canada)');
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(padding: const EdgeInsets.all(10), children: <Widget>[
        ListTile(
            title: Text('Theme'),
            subtitle: Text('Light Mode'),
            onTap: () {
              themeAlert(context, selectedRadio);
            }),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            children: [
              Text('Dark Mode'),
              Switch(
                //the bool value returned is used in ThemeChanger to check if
                //the theme should be changed
                value: themeProvider.getDarkMode(),
                onChanged: (value) {
                  setState(() {
                    themeProvider.makeDark(value);
                  });
                },
              ),
            ],
          ),
        ),
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
            onTap: () {}),
        ListTile(
            title: Text('Documentation'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              _goToDocumentation();
            }),
      ]),
    );
  }
}

//pops up an alert dialog that gives the option between light and dark mode for
//the app theme
Widget themeAlert(BuildContext context, int selectedRadio) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Theme'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            RadioListTile<int>(
              value: 1,
              title: Text('Light Mode'),
              groupValue: selectedRadio,
              onChanged: (value) {
                setState(() => selectedRadio = value);
              },
            ),
            RadioListTile<int>(
              value: 2,
              title: Text('Dark Mode'),
              groupValue: selectedRadio,
              onChanged: (value) {
                setState(() => selectedRadio = value);
              },
            )
          ]);
        }),
      );
    },
  );
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
