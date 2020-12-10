import 'package:app/profile/model/active_profile.dart';
import 'package:app/profile/view/create_edit_profile.dart';
import 'package:app/profile/model/profile.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SelectProfile extends StatefulWidget {
  // Constructor
  final String title;

  SelectProfile({Key key, this.title}) : super(key: key);

  @override
  _SelectProfileState createState() => _SelectProfileState();
}

class _SelectProfileState extends State<SelectProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Renders an App bar
      appBar: AppBar(
        title: Text('Select Profile'),
        actions: [
          Row(
            children: <Widget>[
              Builder(
                builder: (BuildContext context) {
                  // Renders an add icon in the app bar to allow the user to
                  // create a new Profile
                  return IconButton(
                    padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      final SnackBar snackbar = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateEditProfile(
                            title: 'Create Profile',
                          ),
                        ),
                      );

                      // Displays a snackbar indicating that the new profile was
                      // created
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
      // Renders a list of profiles to the screen
      body: Builder(
        builder: _profileList,
      ),
    );
  }

  Widget _profileList(BuildContext context) {
    final ProfileModel profilesList = context.watch<ProfileModel>();
    final ActiveUserModel activeUserModel = context.watch<ActiveUserModel>();

    return Container(
      child: FutureBuilder(
        // Fetches all profiles stored on the local database
        future: profilesList.getAllProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List profiles = snapshot.data;

            return ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context, int index) {
                // Renders a profile object to the screen
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: index == 0
                        // Renders profile list header
                        ? Card( 
                          child: Container(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                    child: Container(
                                      padding: EdgeInsets.all(
                                      10
                                      ),
                                      child: Text(
                                        'Profiles',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold, ),
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          )
                        )
                      // Allows user to switch between profiles by tapping on
                      // the profile data row
                      : GestureDetector(
                          onTap: () async {
                            // Updates current active user and returns a
                            // snackbar to indicate that the active profile
                            // has changed
                            // Returns to the previous screen
                            await activeUserModel
                                .updateActiveUser(profiles[index - 1].id);
                            Navigator.of(context).pop(
                              SnackBar(
                                content: Text('Switched Active Profile'),
                              ),
                            );
                          },
                          // Renders a profile name data row
                          child: Column(
                            children: <Widget>[
                              // Pressing the edit button allows the user to
                              // edit the selected profile
                              Card(
                                child: Container(
                                  child: DataRowWithIconSuffix(
                                    '${profiles[index - 1].name}',
                                    Icons.edit,
                                    () {
                                      _editProfile(
                                          context, profiles[index - 1].id);
                                    },
                                  ),
                                ),
                              ),
                              // Renders a divider
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Divider(
                                  height: 0.5,
                                  color: Color.fromRGBO(180, 180, 180, 100),
                                ),
                              )
                            ],
                          ),
                        ),
                );
              },
              itemCount: profiles.length + 1,
            );
          } else {
            return Text('Fetching Data...');
          }
        },
      ),
    );
  }

  // Renders a Data Row Widget used in list of profiles which includes an icon
  // at the end of the data row
  Widget DataRowWithIconSuffix(header, icon, onTap) {
    return Container(
      padding: EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              header,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.only(
                right: 12.0,
              ),
              child: Icon(
                icon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editProfile(BuildContext context, int id) async {
    // Allows user to edit a profile
    final ProfileModel profileList =
        Provider.of<ProfileModel>(context, listen: false);
    final Profile selectedAddress = await profileList.getProfileById(id);

    // Navigates to the create profile form, with the selected profile object
    final SnackBar snackbar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditProfile(
          title: 'Edit Address',
          data: selectedAddress,
        ),
      ),
    );

    // Returns a snackbar indicating that a profile was updated
    if (snackbar != null) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }
}
