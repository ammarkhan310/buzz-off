import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/utils.dart';

import '../model/biteModel.dart';
import '../model/bite.dart';

// this page allows the user to add new bite to the database
class AddBiteForm extends StatefulWidget {
  String title;

  AddBiteForm({Key key, this.title}) : super(key: key);

  @override
  _AddBiteFormState createState() => _AddBiteFormState();
}


class _AddBiteFormState extends State<AddBiteForm> {
  final _formKey = GlobalKey<FormState>();

  var tec = TextEditingController(); // text controller for the size

  String _location = 'head';
  int _size;
  DateTime _date = DateTime.now(); // set initial date to now

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),

          // column of entry fields
          child: Column(
            children: [
              // drop down menu to select where you were bitten
              DropdownButtonFormField<String> (
                value: _location,
                icon: Icon(Icons.arrow_downward),

                // set location when a list is interacted with
                onChanged: (String newLocation) { 
                  setState(() {
                    _location = newLocation;
                  });
                },

                // set items in dropdown list
                items: <String>[ 
                  'head',
                  'body',
                  'arm',
                  'leg',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>( 
                    value: value,
                    child: Text(value),
                  ); 
                }).toList(),
              ),

              // text form field to input user rating
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Size (0 - 9)',
                ),
                controller: tec, 
                keyboardType: TextInputType.number, // change keyboard to numbers only

                // on change only accept the first digit
                onChanged: (String newSize) {
                  _size = int.parse('${newSize[0]}');
                  _selectSize(newSize);
                },
              ),

              SizedBox(height: 20), // used to add space before date picker
              Text('${toMonthName(_date.month)} ${toOrdinal(_date.day)}, ${_date.year}'),

              RaisedButton(
                child: Text('Select Date'),
                onPressed: () => _selectDate(context),
              ),

            ],
          ),
        ),

        // button to subbmit form
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _submit(),
        tooltip: 'Submit Form',
        child: Icon(Icons.save),
      ),
    );
  }

  // checks and submits current user inputed data
  _submit(){
    print('submit button pressed');
    final BiteListBLoC biteListBLoC = Provider.of<BiteListBLoC>(context, listen: false);

    // if all entries have been filled in
    if(_location != null && _size !=null && _date != null){
      // create bite object based on user inputed info
      Bite bite = Bite(  
        _date,
        _size,
        _location,
      );

      print('New bite created: ${bite}');

      // pops and retrns the bite
      Navigator.of(context).pop(bite);
    }
    else{
      // show a alert dialog if the entry is invalid
      showDialog(  
        context: context,
        builder: (BuildContext context) {
          return AlertDialog( 
            title: Text("Invalid entry", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blueGrey[600], 
            content: Text("Please ensure you have entries for each field", style: TextStyle(color: Colors.white)),

            actions: [ 
              // continue button to close the dialog box
              RaisedButton( 
                child: Text('Continue'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      );
    }
  }

  // only takes the first digit of user score
  _selectSize(String newSize){
    tec.text = '${newSize[0]}';
  }

  // opens date selection dialog and allows users to select a date
  _selectDate(BuildContext context) async{
    DateTime selectedDate = await showDatePicker( 
      context: context,
      initialDate: _date, // set initial date to last selected date
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    // sets date as selected date
    if(selectedDate != null){
      setState(() {
        _date = selectedDate;
      });
    }
  }
}