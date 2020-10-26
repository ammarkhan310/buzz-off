import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  String title;

  StatisticsPage({Key key, this.title}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    List<biteHistory> biteHistoryList= <biteHistory>[
      biteHistory( 
        dateTime: '26-10-2020',
        size: 5,
        location: "arm",
      ),

      biteHistory( 
        dateTime: '31-05-2019',
        size: 3,
        location: "leg",
      ),
    ];
  
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
        itemCount: biteHistoryList.length,
        itemBuilder: (BuildContext context, int index){
          return biteHistoryList[index].build();
        }, 
        separatorBuilder: (BuildContext context, int index) => Divider(), 
        ) 
    );

    throw UnimplementedError();
  }
}

class biteHistory{
  String dateTime;
  int size; //1-10 bite serverity
  String location; //location of bite

  biteHistory({
    this.dateTime,
    this.size,
    this.location
  });

  Widget build(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: <Widget>[
        Text(dateTime),
        Text("Size: $size"),
        Text(location),
      ],
      );
  }
}
