import 'package:app/model/address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// New Page to Create/Edit a New Address
class CreateEditAddress extends StatefulWidget {
  CreateEditAddress({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreateEditAddressState createState() => _CreateEditAddressState();
}

class _CreateEditAddressState extends State<CreateEditAddress> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  @override
  Widget build(BuildContext context) {
    final AddressModel addressList = Provider.of<AddressModel>(context);
    final formValues = [
      {'label': 'Address', 'value': null},
      {'label': 'City', 'value': null},
      {'label': 'Province/State', 'value': null},
      {'label': 'Postal Code/Zip Code', 'value': null},
      {'label': 'Country', 'value': null},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Create/Edit Address'),
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
                          address: formValues[0]['value'],
                          city: formValues[1]['value'],
                          state: formValues[2]['value'],
                          postalCode: formValues[3]['value'],
                          country: formValues[4]['value'],
                        );
                        addressList.insertAddress(address);

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
              return Container(
                padding: EdgeInsets.only(top: 24.0),
                child: ListTile(
                  title: Text(
                    formValues[index]['label'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  subtitle: TextFormField(
                    onSaved: (String value) {
                      formValues[index]['value'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return '${formValues[index]['label']} is required';
                      }
                      return null;
                    },
                  ),
                ),
              );
            },
            itemCount: formValues.length,
          ),
        ),
      ),
    );
  }
}
