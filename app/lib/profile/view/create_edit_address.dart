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
        'value': this.widget.data != null
            ? this.widget.data.toMap()['address']
            : null,
        'key': 'address',
        'inputType': 'textfield',
      },
      {
        'label': 'City',
        'value':
            this.widget.data != null ? this.widget.data.toMap()['city'] : null,
        'key': 'city',
        'inputType': 'textfield',
      },
      {
        'label': 'Province/State',
        'value':
            this.widget.data != null ? this.widget.data.toMap()['state'] : null,
        'key': 'state',
        'inputType': 'textfield',
      },
      {
        'label': 'Postal Code/Zip Code',
        'value': this.widget.data != null
            ? this.widget.data.toMap()['postalCode']
            : null,
        'key': 'postalCode',
        'inputType': 'textfield',
      },
      {
        'label': 'Country',
        'value': this.widget.data != null
            ? this.widget.data.toMap()['country']
            : null,
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
          this.widget.data != null ? 'Edit Address' : 'Create Address',
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
                          id: this.widget.data != null
                              ? this.widget.data.toMap()['id']
                              : null,
                          address: formValues[0]['value'],
                          city: formValues[1]['value'],
                          state: formValues[2]['value'],
                          postalCode: formValues[3]['value'],
                          country: formValues[4]['value'],
                        );

                        if (this.widget.data == null) {
                          addressList.insertAddress(address);
                        } else {
                          addressList.updateAddress(address);
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
                                  addressList.deleteAddressWithId(
                                      this.widget.data.toMap()['id']);
                                  Navigator.of(context).pop();
                                }
                              : null,
                          child: Text(
                            "Delete Address",
                            style: TextStyle(
                              fontSize: 16,
                              color: this.widget.data != null
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
                                print(value);
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
                                  initialValue: this.widget.data != null
                                      ? this.widget.data.toMap()[key]
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
                                  initialValue: this.widget.data != null
                                      ? this.widget.data.toMap()[key]
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
