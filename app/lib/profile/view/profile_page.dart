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
                      padding: EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 12.0),
                      color: Color.fromRGBO(245, 245, 245, 100),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 12.0),
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: DataTable(
                                      headingRowHeight: 36.0,
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                        (states) =>
                                            Color.fromRGBO(220, 220, 220, 100),
                                      ),
                                      dataRowColor:
                                          MaterialStateColor.resolveWith(
                                        (states) => Colors.white,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Container(
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                            ),
                                          ),
                                        ),
                                        // Allows user to quickly edit
                                        // current active user's profile
                                        // data
                                        DataColumn(
                                          label: Container(
                                            child: Expanded(
                                              child: FlatButton(
                                                highlightColor:
                                                    Colors.transparent,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
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
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final SnackBar snackbar =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CreateEditProfile(
                                                        title: 'Create Profile',
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
                                                        .showSnackBar(snackbar);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                      // Renders profile information of the
                                      // current active user to the screen
                                      rows: <DataRow>[
                                        DataRowComponent('Name',
                                            '${activeUserData != null ? activeUserData.name : '-'}'),
                                        DataRowComponent('Gender',
                                            '${activeUserData != null ? activeUserData.gender : '-'}'),
                                        DataRowComponent('Blood Type',
                                            '${activeUserData != null ? activeUserData.bloodType : '-'}'),
                                        DataRowComponent('Age',
                                            '${activeUserData != null ? calculateAge(DateTime.parse(activeUserData.dob)).toString() : '-'}'),
                                        DataRowComponent('Country',
                                            '${activeUserData != null ? activeUserData.country : '-'}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                            ),
                            // Renders all addresses on local database
                            Card(
                              child: DataTable(
                                headingRowHeight: 36.0,
                                headingRowColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromRGBO(220, 220, 220, 100),
                                ),
                                dataRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Container(
                                        width: 220,
                                        child: Text(
                                          'Saved Addresses',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Allows user to quickly edit
                                  // current active user's profile
                                  // data
                                  DataColumn(
                                    label: Expanded(
                                      child: Container(
                                        child: Text(
                                          'Level',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                                // Renders profile information of the
                                // current active user to the screen
                                rows: addresses
                                    .map(
                                      (data) => DataRow(
                                        cells: [
                                          DataCell(
                                            Row(
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    _editAddress(
                                                        context, data.id);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                      right: 12.0,
                                                    ),
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 150,
                                                  child: Text(
                                                    '${data.address}',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataCell(
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  '5',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: 1,
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

  DataRow DataRowComponent(header, value) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            width: 130,
            padding: EdgeInsets.only(right: 16),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ),
        DataCell(
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 24.0),
              width: 150,
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ),
      ],
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
