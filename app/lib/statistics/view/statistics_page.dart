import 'package:app/statistics/view/addBiteForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/utils.dart';

import '../model/bite.dart';
import '../view/biteLogger.dart';
import '../model/biteModel.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsPage extends StatefulWidget {
  String title;

  StatisticsPage({Key key, this.title}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    final BiteListBLoC biteListBLoC =
        Provider.of<BiteListBLoC>(context, listen: false);
    biteListBLoC
        .getAllBites(); // import and processes raw data into a list of bites
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final BiteListBLoC biteListBLoC = context.watch<BiteListBLoC>();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(7),
        child: Column(
          // used to add new bites
          children: <Widget>[
            Text('Tap a body part below to add new entry'),
            BiteLogger().build(context, biteListBLoC.biteList),
            Expanded(
              // creates a list view to display all the cards
              child: ListView.builder(
                itemCount: biteListBLoC.biteList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    // container to add some padding to make it look nice
                    padding: const EdgeInsets.all(2.0),
                    child: BiteCard(
                      bite: biteListBLoC.biteList[index],
                      isDialog: false,
                    ).build(
                        context), // makes a card to display each animes information
                  );
                },
              ),
            ),
            // Renders a bar chart to show the total number of bites which were
            // logged over the course of a week
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: Text('Weekly Bites Report'),
            ),
            Expanded(
              child: charts.BarChart(
                [
                  charts.Series(
                    id: 'dailyMosquitoLevel',
                    colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                    domainFn: (gf, _) => gf.date,
                    measureFn: (gf, _) => gf.frequency,
                    data: _fetchDateFrequencies(biteListBLoC.biteList),
                  ),
                ],
                animate: true,
                vertical: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // shows the add bite form to add a new entry
  _showAddBiteForm() async {
    final BiteListBLoC biteListBLoC =
        Provider.of<BiteListBLoC>(context, listen: false);
    print('add new bite pressed');

    // pushes add bite form and returns the new bite to be added
    Bite newBite = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddBiteForm(title: 'Add New Bite')),
    );

    // if new bite is returned insert the bite into the database
    if (newBite != null) {
      biteListBLoC.insertBite(newBite); // insert new bite into database
    }
  }
}

class BiteCard extends StatelessWidget {
  Bite bite;
  bool isDialog; // if this card is called in a dialog box

  BiteCard({this.bite, this.isDialog});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)), // rounded cards look nice

        // list tile to format information
        child: ListTile(
          leading: Image.asset(bite.imageURL,
              height: 40, width: 40), // image of bite location
          title: Text(
              '${toMonthName(bite.dateBitten.month)} ${toOrdinal(bite.dateBitten.day)}, ${bite.dateBitten.year}'), // date of bite
          subtitle: Text('Size: ${bite.size}'), // bite size

          // shows delete and update buttons
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // update button
              IconButton(
                icon: Icon(Icons.refresh_rounded),
                onPressed: () => _showUpdateBiteForm(context),
              ),

              // delete button
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _showDeleteBiteForm(context),
              ),
            ],
          ),
        ));
  }

  // shows a are you sure dialog box
  _showDeleteBiteForm(BuildContext context) async {
    final BiteListBLoC biteListBLoC =
        Provider.of<BiteListBLoC>(context, listen: false);
    print('Delete bite pressed');

    if (!isDialog) {
      // if is in dialog box disable button
      // dialog box for delete confirmation
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("Are you sure?"),

              // diplays text and selected entry
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text("Are you sure you want to delete this entry?"),
                BiteCard(bite: bite, isDialog: true).build(context),
              ]),

              actions: [
                // continue button to close the dialog box and make no changes
                RaisedButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

                // closes dialog box and deletes entry
                RaisedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    biteListBLoC.deleteBite(bite); // update database and list
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  // shows add bite form as a update entry form
  _showUpdateBiteForm(BuildContext context) async {
    final BiteListBLoC biteListBLoC =
        Provider.of<BiteListBLoC>(context, listen: false);
    print('update bite pressed');

    if (!isDialog) {
      // if called in a dialog box disable button
      // pushes form page and returns new bite
      Bite updatedBite = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddBiteForm(title: 'Update Bite')),
      );

      // if a bite was returned update selected bite with new bite
      if (updatedBite != null) {
        updatedBite.id = bite.id; // give new bite old bite id
        biteListBLoC.updateBite(updatedBite); // update database and list
      }
    }
  }
}

// Frequency Object for Bar Chart
class LevelFrequency {
  String date;
  int frequency;

  LevelFrequency({this.date, this.frequency});

  String toString() {
    return 'PostFrequency($date, $frequency)';
  }
}

List<LevelFrequency> _fetchDateFrequencies(data) {
  // Fetches todays date at midnight
  DateTime currentDate = new DateTime.now();
  currentDate =
      new DateTime(currentDate.year, currentDate.month, currentDate.day);

  // Frequency of bites over the last week
  var weeklyData = {
    '${currentDate}': 0,
    '${currentDate.subtract(Duration(days: 1))}': 0,
    '${currentDate.subtract(Duration(days: 2))}': 0,
    '${currentDate.subtract(Duration(days: 3))}': 0,
    '${currentDate.subtract(Duration(days: 4))}': 0,
    '${currentDate.subtract(Duration(days: 5))}': 0,
    '${currentDate.subtract(Duration(days: 6))}': 0
  };

  // Calculates the number of bites that occurred each day in the last week
  for (var i = 0; i < data.length; i++) {
    DateTime temp_date = DateTime.parse(data[i].toMap()['dateBitten']);
    temp_date = new DateTime(temp_date.year, temp_date.month, temp_date.day);
    if (currentDate.difference(temp_date).inDays < 7) {
      weeklyData[temp_date.toString()] = weeklyData[temp_date.toString()] + 1;
    }
  }

  // Returns an array of data that is rendered to the bar chart
  return weeklyData.keys
      .toList()
      .reversed
      .map(
        (key) => LevelFrequency(
          date:
              '${toShortMonthName(DateTime.parse(key).month)} ${DateTime.parse(key).day}',
          frequency: weeklyData[key],
        ),
      )
      .toList();
}
