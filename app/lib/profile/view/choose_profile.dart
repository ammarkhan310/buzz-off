import 'package:app/profile/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectProfile extends StatefulWidget {
  final String title;

  SelectProfile({Key key, this.title}) : super(key: key);

  @override
  _SelectProfileState createState() => _SelectProfileState();
}

class _SelectProfileState extends State<SelectProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Profile'),
        actions: [
          Row(
            children: <Widget>[
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(context, '/createEditProfile');
                    },
                  );
                },
              )
            ],
          )
        ],
      ),
      body: Builder(
        builder: _profileList,
      ),
    );
  }

  Widget _profileList(BuildContext context) {
    final ProfileModel profilesList = context.watch<ProfileModel>();

    return Container(
      child: FutureBuilder(
        future: profilesList.getAllProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List addresses = snapshot.data;

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: index % 2 == 0
                      ? Color.fromRGBO(255, 255, 255, 100)
                      : Color.fromRGBO(220, 220, 220, 100),
                  child: ListTile(
                    title: Container(
                        child: DataRow(
                      '${addresses[index].name}',
                      () {
                        Navigator.pushNamed(context, '/createEditAddress');
                      },
                    )),
                  ),
                );
              },
              itemCount: addresses.length,
            );
          } else {
            return Text("Data Loading......");
          }
        },
      ),
    );
  }

  Widget DataRow(header, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          ],
        ),
      ),
    );
  }
}
