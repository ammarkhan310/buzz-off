import 'package:app/statistics/view/addBiteForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/utils.dart';

import '../model/bite.dart';
import '../model/biteModel.dart';

class StatisticsPage extends StatefulWidget {
  String title;

  StatisticsPage({Key key, this.title}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    final BiteListBLoC biteListBLoC =
        Provider.of<BiteListBLoC>(context, listen: false);
    biteListBLoC
        .getAllBites(); // import and processes raw data into a list of bites
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final BiteListBLoC biteListBLoC = context.watch<BiteListBLoC>();

    return Scaffold(
      body: Column(

        // used to add new bites
        children: <Widget>[
          
          Text('Tap the person below to add new entry'),

          GestureDetector(
            child: BiteLogger().build(),
            onTap: () {
              _showAddBiteForm();
            },
          ),

          Text('Refresh button updates entry || Trash button deletes entry'),

          Expanded(
              // creates a list view to display all the cards
            child: ListView.builder(
              itemCount: biteListBLoC.biteList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  // container to add some padding to make it look nice
                  padding: const EdgeInsets.all(2.0),
                  child: BiteCard(
                    bite: biteListBLoC.biteList[index],
                    isDialog: false,
                  ).build(context), // makes a card to display each animes information    
                );
              },
            )
          ),
        ]
      )
    );
  }

  // shows the add bite form to add a new entry
  _showAddBiteForm() async {
    final BiteListBLoC biteListBLoC =
        Provider.of<BiteListBLoC>(context, listen: false);
    print('add new bite pressed');

    // pushes add bite form and returns the new bite to be added
    Bite newBite = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddBiteForm(title: 'Add New Bite')),
    );

    // if new bite is returned insert the bite into the database
    if (newBite != null) {
      biteListBLoC.insertBite(newBite); // insert new bite into database
    }
  }
}

class BiteLogger {
  //temp need to implement inveractivity
  String imageURL = 'assets/bitemap/noBite.png';

  Widget build() {
    return Image.asset(imageURL, height: 250, width: 250);
  }
}

class BiteCard extends StatelessWidget {
  Bite bite;
  bool isDialog; // if this card is called in a dialog box

  BiteCard({this.bite, this.isDialog});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)), // rounded cards look nice

        // list tile to format information
        child: ListTile(
          leading: Image.asset(bite.imageURL,
              height: 40, width: 40), // image of bite location
          title: Text(
              '${toMonthName(bite.dateBitten.month)} ${toOrdinal(bite.dateBitten.day)}, ${bite.dateBitten.year}'), // date of bite
          subtitle: Text('Size: ${bite.size}'), // bite size

          // shows delete and update buttons
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // update button
              IconButton(
                icon: Icon(Icons.refresh_rounded),
                onPressed: () => _showUpdateBiteForm(context),
              ),

              // delete button
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _showDeleteBiteForm(context),
              ),
            ],
          ),
        ));
  }

  // shows a are you sure dialog box
  _showDeleteBiteForm(BuildContext context) async {
    final BiteListBLoC biteListBLoC =
        Provider.of<BiteListBLoC>(context, listen: false);
    print('Delete bite pressed');

    if (!isDialog) {
      // if is in dialog box disable button
      // dialog box for delete confirmation
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("Are you sure?"),

              // diplays text and selected entry
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text("Are you sure you want to delete this entry?"),
                BiteCard(bite: bite, isDialog: true).build(context),
              ]),

              actions: [
                // continue button to close the dialog box and make no changes
                RaisedButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

                // closes dialog box and deletes entry
                RaisedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    biteListBLoC.deleteBite(bite); // update database and list
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  // shows add bite form as a update entry form
  _showUpdateBiteForm(BuildContext context) async {
    final BiteListBLoC biteListBLoC =
        Provider.of<BiteListBLoC>(context, listen: false);
    print('update bite pressed');

    if (!isDialog) {
      // if called in a dialog box disable button
      // pushes form page and returns new bite
      Bite updatedBite = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddBiteForm(title: 'Update Bite')),
      );

      // if a bite was returned update selected bite with new bite
      if (updatedBite != null) {
        updatedBite.id = bite.id; // give new bite old bite id
        biteListBLoC.updateBite(updatedBite); // update database and list
      }
    }
  }
}
