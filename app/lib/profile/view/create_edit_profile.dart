import 'package:app/data/constants.dart';
import 'package:app/profile/model/profile.dart';
import 'package:app/utils.dart';
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

    final List<Map<String, String>> formValues = [
      {
        'label': 'Name',
        'value': widget.data != null ? widget.data.toMap()['name'] : null,
        'key': 'name',
        'inputType': 'textfield',
      },
      {
        'label': 'Gender',
        'value': widget.data != null ? widget.data.toMap()['gender'] : null,
        'key': 'gender',
        'inputType': 'textfield',
      },
      {
        'label': 'Blood Type',
        'value': widget.data != null ? widget.data.toMap()['bloodType'] : null,
        'key': 'bloodType',
        'inputType': 'dropdown',
      },
      {
        'label': 'Age',
        'value': widget.data != null ? widget.data.toMap()['age'] : null,
        'key': 'age',
        'inputType': 'number',
      },
      {
        'label': 'Current Country',
        'value': widget.data != null ? widget.data.toMap()['country'] : null,
        'key': 'country',
        'inputType': 'dropdown',
      },
    ];

    final Map<String, List<String>> dropdownValues = {
      'gender': genders,
      'bloodType': bloodTypes,
      'country': countries,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data != null ? 'Edit Profile' : 'Create Profile',
        ),
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
                          id: widget.data != null
                              ? widget.data.toMap()['id']
                              : null,
                          name: formValues[0]['value'],
                          gender: formValues[1]['value'],
                          bloodType: formValues[2]['value'],
                          age: formValues[3]['value'],
                          country: formValues[4]['value'],
                        );

                        if (widget.data != null) {
                          profileList.updateAddress(profile);
                          Navigator.of(context).pop(
                            new SnackBar(
                              content: Text('Updated Profile'),
                            ),
                          );
                        } else {
                          profileList.insertProfile(profile);
                          Navigator.of(context).pop(
                            SnackBar(
                              content: Text('Created Profile'),
                            ),
                          );
                        }
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
                          onPressed: widget.data != null
                              ? () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text(
                                          'Delete Profile?',
                                        ),
                                        content: Text(
                                          'Are you sure you want to delete ' +
                                              'this profile?',
                                        ),
                                        actions: [
                                          RaisedButton(
                                            child: Text('Delete'),
                                            onPressed: () {
                                              profileList.deleteProfileWithId(
                                                widget.data.toMap()['id'],
                                              );
                                              Navigator.of(dialogContext).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          RaisedButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              : null,
                          child: Text(
                            "Delete Profile",
                            style: TextStyle(
                              fontSize: 16,
                              color: widget.data != null
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ),
                  subtitle: index < formValues.length
                      ? formValues[index]['inputType'] == 'dropdown'
                          ? DropdownButtonFormField(
                              value: formValues[index]['value'],
                              items: <String>[...dropdownValues[key]]
                                  .map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                              onChanged: (String value) {
                                formValues[index]['value'] = value;
                              },
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return '${formValues[index]['label']} is ' +
                                      'required';
                                }
                                return null;
                              },
                            )
                          : formValues[index]['inputType'] == 'number'
                              ? TextFormField(
                                  keyboardType: TextInputType.number,
                                  initialValue: widget.data != null
                                      ? widget.data.toMap()[key]
                                      : '',
                                  onSaved: (String value) {
                                    formValues[index]['value'] = value;
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return '${formValues[index]['label']} ' +
                                          'is required';
                                    } else if (!isNumeric(value)) {
                                      return '${formValues[index]['label']} ' +
                                          'must be a valid number';
                                    }
                                    return null;
                                  },
                                )
                              : TextFormField(
                                  initialValue: widget.data != null
                                      ? widget.data.toMap()[key]
                                      : '',
                                  onSaved: (String value) {
                                    formValues[index]['value'] = value;
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return '${formValues[index]['label']} ' +
                                          'is required';
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
