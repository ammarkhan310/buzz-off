import 'package:flutter/material.dart';
import 'package:app/settings/documentation_page.dart';
import 'package:app/settings/themes.dart';

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

  List<Themes> themes;
  String selectedTheme = 'Light Mode';

  void initState() {
    super.initState();
    selectedTheme = 'Light Mode';
    themes = Themes.getThemes();
  }

  setTheme(Themes themes) {
    setState(() {
      selectedTheme = themes.themeName;
    });
  }

  @override
  Widget build(BuildContext context) {
    String chosenLocation = ('Default (Canada)');
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(padding: const EdgeInsets.all(10), children: <Widget>[
        ListTile(
            title: Text('Theme'),
            subtitle: Text(selectedTheme),
            onTap: () {
              themeAlert(context);
            }),
        ListTile(
            title: Text('Location'),
            subtitle: Text(chosenLocation),
            onTap: () {
              locationDialog(context);
            }),
        ListTile(
            title: Text('Manage Notifications'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('pressed');
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
}

Widget themeAlert(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      int selectedRadio = 0;
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
