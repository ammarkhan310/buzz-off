import 'package:app/profile/model/active_profile.dart';
import 'package:app/profile/model/profile.dart';
import 'package:app/profile/view/create_edit_profile.dart';
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
                    onPressed: () async {
                      final SnackBar snackbar = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateEditProfile(
                            title: 'Create Profile',
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
    );
  }

  Widget _profileList(BuildContext context) {
    final ProfileModel profilesList = context.watch<ProfileModel>();
    final ActiveUserModel activeUserModel = context.watch<ActiveUserModel>();

    return Container(
      child: FutureBuilder(
        future: profilesList.getAllProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List profiles = snapshot.data;

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: index != 0 ? Colors.white : Colors.transparent,
                  child: ListTile(
                    title: index == 0
                        ? Text(
                            'Profiles',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              await activeUserModel
                                  .updateActiveUser(profiles[index - 1].id);
                              Navigator.of(context).pop(
                                SnackBar(
                                  content: Text('Switched Active Profile'),
                                ),
                              );
                            },
                            child: Container(
                              child: DataRowWithIconSuffix(
                                '${profiles[index - 1].name}',
                                Icons.edit,
                                () {
                                  _editProfile(context, profiles[index - 1].id);
                                },
                              ),
                            ),
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

  Widget DataRowWithIconSuffix(header, icon, onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
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
        ],
      ),
    );
  }

  Future<void> _editProfile(BuildContext context, int id) async {
    // Allows user to edit a profile
    final ProfileModel profileList =
        Provider.of<ProfileModel>(context, listen: false);
    final Profile selectedAddress = await profileList.getProfileById(id);

    final SnackBar snackbar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditProfile(
          title: 'Edit Address',
          data: selectedAddress,
        ),
      ),
    );

    if (snackbar != null) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }
}
