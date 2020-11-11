import 'package:app/profile/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// New Page to Create/Edit a Profile
class CreateEditProfile extends StatefulWidget {
  CreateEditProfile({Key key, this.title, this.data}) : super(key: key);

  final String title;
  final Profile data;

  @override
  _CreateEditProfileState createState() => _CreateEditProfileState();
}

class _CreateEditProfileState extends State<CreateEditProfile> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ProfileModel profileList = Provider.of<ProfileModel>(context);

    final formValues = [
      {
        'label': 'Name',
        'value': null,
        'key': 'name',
      },
      {
        'label': 'Gender',
        'value': null,
        'key': 'gender',
      },
      {
        'label': 'Blood Type',
        'value': null,
        'key': 'bloodType',
      },
      {
        'label': 'Age',
        'value': null,
        'key': 'age',
      },
      {
        'label': 'Current Country',
        'value': null,
        'key': 'country',
      },
    ];

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
                    icon: Icon(Icons.save),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        Profile profile = Profile(
                          id: this.widget.data != null
                              ? this.widget.data.toMap()['id']
                              : null,
                          name: formValues[0]['value'],
                          gender: formValues[1]['value'],
                          bloodType: formValues[2]['value'],
                          age: formValues[3]['value'],
                          country: formValues[4]['value'],
                        );

                        if (this.widget.data == null) {
                          profileList.insertProfile(profile);
                        } else {
                          profileList.updateAddress(profile);
                        }

                        Navigator.of(context).pop();
                      }
                    },
                  );
                },
              )
            ],
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              String key =
                  index < formValues.length ? formValues[index]['key'] : null;

              return Container(
                padding: EdgeInsets.only(top: 24.0),
                child: ListTile(
                  title: index < formValues.length
                      ? Text(
                          formValues[index]['label'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        )
                      : FlatButton(
                          onPressed: this.widget.data != null
                              ? () {
                                  profileList.deleteProfileWithId(
                                      this.widget.data.toMap()['id']);
                                  Navigator.of(context).pop();
                                }
                              : null,
                          child: Text(
                            "Delete Profile",
                            style: TextStyle(
                              fontSize: 16,
                              color: this.widget.data != null
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ),
                  subtitle: index < formValues.length
                      ? TextFormField(
                          initialValue: this.widget.data != null
                              ? this.widget.data.toMap()[key]
                              : '',
                          onSaved: (String value) {
                            formValues[index]['value'] = value;
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return '${formValues[index]['label']} is required';
                            }
                            return null;
                          },
                        )
                      : null,
                ),
              );
            },
            itemCount: formValues.length + 1,
          ),
        ),
      ),
    );
  }
}
