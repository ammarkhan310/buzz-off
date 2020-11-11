import 'package:app/profile/model/address.dart';
import 'package:app/profile/view/edit_address_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String title;

  ProfilePage({Key key, this.title}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
        actions: [
          Row(
            children: <Widget>[
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                    icon: Icon(Icons.swap_horiz_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, '/chooseProfile');
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createEditAddress');
        },
        tooltip: 'Add Address',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _profileList(BuildContext context) {
    final AddressModel addressList = context.watch<AddressModel>();

    return Container(
      child: FutureBuilder(
        future: addressList.getAllAddresses(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List addresses = snapshot.data;

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Color.fromRGBO(255, 255, 255, 100),
                  child: ListTile(
                    title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          index == 0
                              ? Container(
                                  padding: EdgeInsets.only(top: 12.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        color:
                                            Color.fromRGBO(220, 220, 220, 100),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'Details',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                            ),
                                            FlatButton(
                                              highlightColor:
                                                  Colors.transparent,
                                              padding:
                                                  EdgeInsets.only(left: 90.0),
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    '/createEditProfile');
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 100),
                                        child: Column(
                                          children: <Widget>[
                                            DataRow('Gender', 'Male'),
                                            DataRow('Blood Type', 'B+'),
                                            DataRow('Age', '15'),
                                            DataRow('Country', 'Canada'),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color:
                                            Color.fromRGBO(220, 220, 220, 100),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal: 16.0,
                                        ),
                                        margin: EdgeInsets.only(top: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'Saved Addresses',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                            ),
                                            Text(
                                              'Mosquito Level',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : DataRowWithIconPrefix(
                                  '${addresses[index - 1].address}',
                                  '5',
                                  Icons.edit,
                                  () {
                                    Navigator.pushNamed(
                                        context, '/createEditAddress');
                                  },
                                )
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: addresses.length + 1,
            );
          } else {
            return Text("Data Loading......");
          }
        },
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

  Widget DataRowWithIconPrefix(header, value, icon, onTap) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.only(
                    right: 12.0,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              Text(
                header,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueGrey,
                ),
              ),
            ],
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

  Future<void> _editAddress(BuildContext context) async {
    // Allows user to edit an address
    final AddressModel addressList =
        Provider.of<AddressModel>(context, listen: false);
    final selectedAddress = await addressList.getAddressWithId('0');
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CreateEditAddress(title: 'Edit Address', data: selectedAddress)),
    );
  }
}
