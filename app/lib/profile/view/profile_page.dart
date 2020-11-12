import 'package:app/profile/model/active_profile.dart';
import 'package:app/profile/model/address.dart';
import 'package:app/profile/model/profile.dart';
import 'package:app/profile/view/create_edit_profile.dart';
import 'package:app/profile/view/profile_selector.dart';
import 'package:app/utils.dart';
import 'package:app/profile/view/create_edit_address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String title;

  ProfilePage({Key key, this.title}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          Row(
            children: <Widget>[
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                    icon: Icon(Icons.swap_horiz_outlined),
                    onPressed: () async {
                      final SnackBar snackbar = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectProfile(
                            title: 'Profile Selector',
                          ),
                        ),
                      );

                      if (snackbar != null) {
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(snackbar);
                      }
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
        onPressed: () async {
          final SnackBar snackbar = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEditAddress(
                title: 'Create Address',
              ),
            ),
          );

          if (snackbar != null) {
            _scaffoldKey.currentState.hideCurrentSnackBar();
            _scaffoldKey.currentState.showSnackBar(snackbar);
          }
        },
        tooltip: 'Add Address',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _profileList(BuildContext context) {
    final AddressModel addressList = context.watch<AddressModel>();
    final ProfileModel profileList = context.watch<ProfileModel>();
    final ActiveUserModel activeUserModel = context.watch<ActiveUserModel>();

    return FutureBuilder(
      future: activeUserModel.getActiveUserId(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var activeUserId = snapshot.data.profileId;
          var activeUserData;
          if (activeUserId != null) {
            profileList.getProfileById(activeUserId).then(
              (profileData) {
                activeUserData = profileData;
              },
            );
          }

          return Container(
            child: FutureBuilder(
              future: addressList.getAllAddresses(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List addresses = snapshot.data;

                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        color: Color.fromRGBO(245, 245, 245, 100),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              index == 0
                                  ? Container(
                                      padding: EdgeInsets.only(top: 12.0),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            color: Color.fromRGBO(
                                                220, 220, 220, 100),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'Details',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blueGrey),
                                                ),
                                                FlatButton(
                                                  highlightColor:
                                                      Colors.transparent,
                                                  padding: EdgeInsets.only(
                                                      left: 90.0),
                                                  child: Text(
                                                    activeUserData != null
                                                        ? 'Edit'
                                                        : 'Create Profile',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    final SnackBar snackbar =
                                                        await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CreateEditProfile(
                                                          title:
                                                              'Create Profile',
                                                          data: activeUserData,
                                                        ),
                                                      ),
                                                    );

                                                    if (snackbar != null) {
                                                      Scaffold.of(context)
                                                          .hideCurrentSnackBar();
                                                      Scaffold.of(context)
                                                          .showSnackBar(
                                                              snackbar);
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                DataRow('Name',
                                                    '${activeUserData != null ? activeUserData.name : '-'}'),
                                                DataRow('Gender',
                                                    '${activeUserData != null ? activeUserData.gender : '-'}'),
                                                DataRow('Blood Type',
                                                    '${activeUserData != null ? activeUserData.bloodType : '-'}'),
                                                DataRow('Age',
                                                    '${activeUserData != null ? calculateAge(DateTime.parse(activeUserData.dob)).toString() : '-'}'),
                                                DataRow('Country',
                                                    '${activeUserData != null ? activeUserData.country : '-'}'),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: Color.fromRGBO(
                                                220, 220, 220, 100),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 16.0,
                                            ),
                                            margin: EdgeInsets.only(top: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'Saved Addresses',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blueGrey),
                                                ),
                                                Text(
                                                  'Mosquito Level',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                        _editAddress(
                                            context, addresses[index - 1].id);
                                      },
                                    )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: addresses.length + 1,
                  );
                } else {
                  return Text('Fetching Data...');
                }
              },
            ),
          );
        } else {
          return Text('Fetching Data...');
        }
      },
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
          Container(
            padding: EdgeInsets.only(right: 8),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          )
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
      color: Colors.white,
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

  Future<void> _editAddress(BuildContext context, int id) async {
    // Allows user to edit an address
    final AddressModel addressList =
        Provider.of<AddressModel>(context, listen: false);
    final Address selectedAddress = await addressList.getAddressWithId(id);

    final SnackBar snackbar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateEditAddress(title: 'Create Address', data: selectedAddress),
      ),
    );

    if (snackbar != null) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
}
