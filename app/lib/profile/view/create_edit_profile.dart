import 'package:app/data/constants.dart';
import 'package:app/profile/model/active_profile.dart';
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
    final TextEditingController _dobController = new TextEditingController(
      text: widget.data != null
          ? formatDate(DateTime.parse(widget.data.toMap()['dob']))
          : '',
    );

    final ProfileModel profileList = Provider.of<ProfileModel>(context);
    final ActiveUserModel activeUserModel = context.watch<ActiveUserModel>();

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
        'label': 'Date of Birth',
        'value': widget.data != null ? widget.data.toMap()['dob'] : null,
        'key': 'dob',
        'inputType': 'date',
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
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        Profile profile = Profile(
                          id: widget.data != null
                              ? widget.data.toMap()['id']
                              : null,
                          name: formValues[0]['value'],
                          gender: formValues[1]['value'],
                          bloodType: formValues[2]['value'],
                          dob: formValues[3]['value'],
                          country: formValues[4]['value'],
                        );

                        if (widget.data == null) {
                          var newProfileId =
                              await profileList.insertProfile(profile);
                          await activeUserModel.getActiveUserId().then(
                                (activeUser) => {
                                  if (activeUser.profileId == null)
                                    {
                                      activeUserModel
                                          .updateActiveUser(newProfileId)
                                    }
                                },
                              );

                          Navigator.of(context).pop(
                            SnackBar(
                              content: Text('Created Profile'),
                            ),
                          );
                        } else {
                          await profileList.updateProfile(profile);
                          Navigator.of(context).pop(
                            new SnackBar(
                              content: Text('Updated Profile'),
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
                                            onPressed: () async {
                                              profileList.deleteProfileWithId(
                                                widget.data.toMap()['id'],
                                              );
                                              await activeUserModel
                                                  .getActiveUserId()
                                                  .then(
                                                    (activeUser) => {
                                                      if (activeUser
                                                              .profileId ==
                                                          widget.data
                                                              .toMap()['id'])
                                                        {
                                                          profileList
                                                              .getAllProfiles()
                                                              .then((profiles) {
                                                            if (profiles
                                                                    .length >
                                                                0) {
                                                              activeUserModel
                                                                  .updateActiveUser(
                                                                      profiles[
                                                                              0]
                                                                          .id);
                                                            } else {
                                                              activeUserModel
                                                                  .updateActiveUser(
                                                                      null);
                                                            }
                                                          })
                                                        }
                                                    },
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
                              : formValues[index]['inputType'] == 'date'
                                  ? TextFormField(
                                      controller: _dobController,
                                      readOnly: true,
                                      onTap: () {
                                        // Displays Date Picker
                                        showDatePicker(
                                          context: context,
                                          initialDate: widget.data != null
                                              ? DateTime.parse(
                                                  formValues[index]['value'])
                                              : new DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        ).then((value) {
                                          _dobController.text =
                                              '${toMonthName(value.month)} ' +
                                                  '${value.day}, ${value.year}';
                                          formValues[3]['value'] =
                                              value.toIso8601String();
                                        });
                                      },
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return '${formValues[index]['label']} ' +
                                              'is required';
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
