import 'package:app/data/constants.dart';
import 'package:app/profile/model/address.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// New Page to Create/Edit a New Address
class CreateEditAddress extends StatefulWidget {
  CreateEditAddress({Key key, this.title, this.data}) : super(key: key);

  final String title;
  final Address data;

  @override
  _CreateEditAddressState createState() => _CreateEditAddressState();
}

class _CreateEditAddressState extends State<CreateEditAddress> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  @override
  Widget build(BuildContext context) {
    final AddressModel addressList = Provider.of<AddressModel>(context);
    final List<Map<String, String>> formValues = [
      {
        'label': 'Address',
        'value': widget.data != null ? widget.data.toMap()['address'] : null,
        'key': 'address',
        'inputType': 'textfield',
      },
      {
        'label': 'City',
        'value': widget.data != null ? widget.data.toMap()['city'] : null,
        'key': 'city',
        'inputType': 'textfield',
      },
      {
        'label': 'Province/State',
        'value': widget.data != null ? widget.data.toMap()['state'] : null,
        'key': 'state',
        'inputType': 'textfield',
      },
      {
        'label': 'Postal Code/Zip Code',
        'value': widget.data != null ? widget.data.toMap()['postalCode'] : null,
        'key': 'postalCode',
        'inputType': 'textfield',
      },
      {
        'label': 'Country',
        'value': widget.data != null ? widget.data.toMap()['country'] : null,
        'key': 'country',
        'inputType': 'dropdown',
      },
    ];

    final Map<String, List<String>> dropdownValues = {
      'country': countries,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data != null ? 'Edit Address' : 'Create Address',
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

                        Address address = Address(
                          id: widget.data != null
                              ? widget.data.toMap()['id']
                              : null,
                          address: formValues[0]['value'],
                          city: formValues[1]['value'],
                          state: formValues[2]['value'],
                          postalCode: formValues[3]['value'],
                          country: formValues[4]['value'],
                        );

                        if (widget.data == null) {
                          addressList.insertAddress(address);
                          Navigator.of(context).pop(
                            new SnackBar(
                              content: Text('Added Address'),
                            ),
                          );
                        } else {
                          addressList.updateAddress(address);
                          Navigator.of(context).pop(
                            new SnackBar(
                              content: Text('Updated Address'),
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
          margin: EdgeInsets.all(12.0),
          color: Colors.white,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              String key =
                  index < formValues.length ? formValues[index]['key'] : null;

              return Container(
                padding: EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
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
                                          'Remove Address?',
                                        ),
                                        content: Text(
                                          'Are you sure you want to remove ' +
                                              'this address from your profile?',
                                        ),
                                        actions: [
                                          RaisedButton(
                                            child: Text('Delete'),
                                            onPressed: () {
                                              addressList.deleteAddressWithId(
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
                            "Delete Address",
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
                              items: <String>[
                                ...dropdownValues[key]
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
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
