import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  String title;

  ProfilePage({Key key, this.title}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        color: Color.fromRGBO(240, 240, 240, 100),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Color.fromRGBO(220, 220, 220, 100),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Details',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                        FlatButton(
                            highlightColor: Colors.transparent,
                            padding: EdgeInsets.only(left: 90.0),
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            onPressed: () {
                              print('Item  pressed');
                            }),
                      ],
                    ),
                  ),
                  Container(
                    color: Color.fromRGBO(255, 255, 255, 100),
                    child: Column(
                      children: <Widget>[
                        DataRow('Gender', 'Male'),
                        DataRow('Blood Type', 'B+'),
                        DataRow('Country', 'Canada'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Color.fromRGBO(220, 220, 220, 100),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Previous Logs',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Color.fromRGBO(255, 255, 255, 100),
                    child: Column(
                      children: <Widget>[
                        DataRow('10-31-2020', 'Left Arm'),
                        DataRow('10-31-2020', 'Left Arm'),
                        DataRow('10-31-2020', 'Right Arm'),
                        DataRow('10-31-2020', 'Left Leg'),
                        DataRow('10-27-2020', 'Head'),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget DataRow(header, value) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueGrey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
