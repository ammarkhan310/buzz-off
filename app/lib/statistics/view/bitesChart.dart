import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/utils.dart';

import '../model/biteModel.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BitesChart extends StatefulWidget {
  String title;

  BitesChart({Key key, this.title}) : super(key: key);

  @override
  _BitesChartState createState() => _BitesChartState();
}

class _BitesChartState extends State<BitesChart> {
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
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: Padding(
        padding: EdgeInsets.all(7),
        child: Column(
          children: <Widget>[
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
                behaviors: [
                  charts.ChartTitle(
                    'Number of Bites',
                    behaviorPosition: charts.BehaviorPosition.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
