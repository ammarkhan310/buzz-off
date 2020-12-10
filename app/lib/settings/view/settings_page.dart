import 'package:app/settings/model/themeChanger.dart';
import 'package:flutter/material.dart';
import 'package:app/settings/view/documentation_page.dart';
import 'package:provider/provider.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/settings/model/themeModel.dart';

class SettingsPage extends StatefulWidget {
  final String title;
  final FlutterI18nDelegate flutterI18nDelegate;

  SettingsPage({Key key, this.title, this.flutterI18nDelegate})
      : super(key: key);

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

  Locale currentLang;
  ThemeModel selectedTheme = ThemeModel();
  List<ThemeModel> _theme;
  int selectedRadio;
  String themeName;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() {
        currentLang = FlutterI18n.currentLocale(context);
      });
    });
    selectedRadio = 1;
    _theme = ThemeModel.getTheme();
    themeName = 'Light Mode';
  }

  changeLanguage() async {
    currentLang =
        currentLang.languageCode == 'en' ? Locale('fr') : Locale('en');
    await FlutterI18n.refresh(context, currentLang);
    setState(() {});
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
    setThemeName(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(padding: const EdgeInsets.all(10), children: <Widget>[
        ListTile(
            title: Text(FlutterI18n.translate(context, "settings.theme")),
            subtitle: Text('$themeName'),
            onTap: () {
              themeAlert(context, selectedRadio, themeProvider);
              print('Radio: $themeName');
            }),
        ListTile(
            //currently the location picker is using placeholders
            title: Text(FlutterI18n.translate(context, "settings.language")),
            subtitle:
                Text(FlutterI18n.translate(context, "settings.chosenLang")),
            onTap: () async {
              await changeLanguage();
              setState(() {});
            }),
        ListTile(
            //planned to take the user to the Android System notification
            //settings where they can see all the nofication channels
            title:
                Text(FlutterI18n.translate(context, "settings.notifications")),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              _openNotificationSettings();
            }),
        ListTile(
            title:
                Text(FlutterI18n.translate(context, "settings.documentation")),
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
                      onTap: () {},
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
