import 'package:app/profile/model/active_profile.dart';
import 'package:app/profile/model/address.dart';
import 'package:app/profile/model/profile.dart';
import 'package:app/profile/view/create_edit_profile.dart';
import 'package:app/profile/view/profile_selector.dart';
import 'package:app/utils.dart';
import 'package:app/profile/view/create_edit_address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/settings/themeChanger.dart';

class ProfilePage extends StatefulWidget {
  // Constructor
  final String title;

  ProfilePage({Key key, this.title}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variable Declaration
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // Renders an App bar
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          Row(
            children: <Widget>[
              Builder(
                builder: (BuildContext context) {
                  // Renders an icon in the app bar to allow the user to
                  // switch the current active user
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

                      // Displays a snackbar indicating that the current active
                      // user has changed
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
      // Renders the profile data to the screen
      body: Builder(
        builder: _profileList,
      ),
      // Renders an add icon to allow the user to create a new address
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

          // Displays a snackbar indicating that a new address has been created
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
    // Variable Declaration
    final AddressModel addressList = context.watch<AddressModel>();
    final ProfileModel profileList = context.watch<ProfileModel>();
    final ActiveUserModel activeUserModel = context.watch<ActiveUserModel>();

    return FutureBuilder(
      // Fetches current active user
      future: activeUserModel.getActiveUserId(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Fetches profile data for the current active user
          var activeUserId = snapshot.data.profileId;
          var activeUserData;
          if (activeUserId != null) {
            profileList.getProfileById(activeUserId).then(
              (profileData) {
                activeUserData = profileData;
              },
            );
          }

          return FutureBuilder(
            future: addressList.getAllAddresses(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List addresses = snapshot.data;

                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          index == 0
                              // Renders profile information header
                              ? Container(
                                  padding: EdgeInsets.only(top: 12.0),
                                  child: Column(
                                    children: <Widget>[
                                      Card(
                                        child: Container(
                                        
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
                                                        FontWeight.bold,),
                                              ),
                                              // Allows user to quickly edit
                                              // current active user's profile
                                              // data
                                              FlatButton(

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

                                                  // Renders a snackbar
                                                  // indicating the active
                                                  // profile was edited
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
                                      ),
                                      // Renders profile information of the
                                      // current active user to the screen
                                      Card(
                                        child: Container(
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
                                      ),
                                      // Renders Address information header
                                      Card(
                                        child: Container(
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
                                                        FontWeight.bold,),
                                              ),
                                              Text(
                                                'Mosquito Level',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold,),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              // Renders all addresses on local database
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
                    );
                
                  },
                  itemCount: addresses.length + 1,
                );
              } else {
                return Text('Fetching Data...');
              }
            },
          );
           
        } else {
          return Text('Fetching Data...');
        }
      },
    );
  }

  // Data row widget used in profile information
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

  // Renders a Data Row Widget used in list of addresses which includes an icon
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

    // Navigates to the create address form, with the selected address object
    final SnackBar snackbar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateEditAddress(title: 'Create Address', data: selectedAddress),
      ),
    );

    // Returns a snackbar indicating that an address was updated
    if (snackbar != null) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
}
