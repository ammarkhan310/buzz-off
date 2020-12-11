import 'package:flutter/material.dart';

class DocumentationPage extends StatefulWidget {
  @override
  _DocumentationPageState createState() => _DocumentationPageState();
}

//Page to show the credits, FAQ and other information about the app
class _DocumentationPageState extends State<DocumentationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Docs')),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          child: ListView(children: <Widget>[
            Text(
              'Buzz Off',
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
            ),
            Text(
              'ver. 0.1-alpha',
              textAlign: TextAlign.center,
            ),
            Text(
              '\nThe Buzz Off app is a project in association with Ontario Tech University. '
              'Thank you to the creators of the original images/works/ideas used in the app as '
              'referenced below.',
              textAlign: TextAlign.center,
            ),
            Text(
              '\nCredits',
              textAlign: TextAlign.center,
              textScaleFactor: 1.2,
            ),
            Text(
              '\nIcons made by "https://www.flaticon.com/authors/kiranshastry" Kiranshastry from https://www.flaticon.com/'
              '\nCharacter pack by'
              '\nKenney Vleugels (www.kenney.nl) || License (CC0): http://creativecommons.org/publicdomain/zero/1.0/',
              textAlign: TextAlign.center,
            ),
            Text(
              '\nFAQ',
              textAlign: TextAlign.center,
              textScaleFactor: 1.2,
            ),
            Text(
              '\nHow do I add a bite?'
              '\nTo add a bite, go to the statistics page and select the body part where you got bitten.'
              '\n'
              '\nWhat does the graph show?'
              '\nThe graph shows the number of times you were bitten each day in the past week.',
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ),
    );
  }
}
