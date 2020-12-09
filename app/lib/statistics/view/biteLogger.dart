import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/statistics/view/addBiteForm.dart';

import '../model/biteModel.dart';
import '../model/bite.dart';

class BiteLogger{
  String head = 'head';
  String body = 'body';
  String rArm = 'rightArm';
  String lArm = 'leftArm';
  String legs = 'leg';

  String URL = 'assets/bitemap/';

  double scale = 9.5; //scale of person size
  double opacity = 0.8; // opacity of overlay

  @override
  Widget build(BuildContext context, List<Bite> bites) {
    return Column(

      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
            height: 250,
            width: 250,

          // stack to put the person together
          child: Stack(
            alignment: Alignment.topCenter,

            children: <Widget>[ 

              // body section
              Positioned(
                top: 67,

                child: GestureDetector( 
                  child: bodyPartImage(bites, body),

                  onTap: () => _showAddBiteForm(context, body),
                )
              ),

              // head section
              Positioned(
                child: GestureDetector( 
                  child: bodyPartImage(bites, head),

                  onTap: () => _showAddBiteForm(context, head),
                )
              ),

              // right arm section
              Positioned(
                top: 70,
                left: 21, 

                child: GestureDetector( 
                  child: bodyPartImage(bites, rArm),

                  onTap: () => _showAddBiteForm(context, rArm),
                )
              ),

              // left arm section
              Positioned(
                top: 70,
                right: 23, 

                child: GestureDetector( 
                  child: bodyPartImage(bites, lArm),

                  onTap: () => _showAddBiteForm(context, lArm),
                )
              ),

              // leg section
              Positioned(
                top: 145,

                child: GestureDetector( 
                  child: bodyPartImage(bites, legs),

                  onTap: () => _showAddBiteForm(context, legs),
                ),
              ),
              
            ],
          ),
        ),

        // displays bite count for each body part
        Row( 
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [ 
            countCard(context, bites, head),
            countCard(context, bites, body),
            countCard(context, bites, lArm),
            countCard(context, bites, legs),
          ],
        )
      ],
    );
  }

  // shows the add bite form to add a new entry
  _showAddBiteForm(BuildContext context, String bodyPart) async {
    final BiteListBLoC biteListBLoC =
        Provider.of<BiteListBLoC>(context, listen: false);
    print('add new bite pressed');

    String part = bodyPart;

    if(isArm(part)){
      part = 'arm';
    }

    // pushes add bite form and returns the new bite to be added
    Bite newBite = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddBiteForm(title: 'Add new ' + part + ' bite', bodyPart: part)),
    );

    // if new bite is returned insert the bite into the database
    if (newBite != null) {
      biteListBLoC.insertBite(newBite); // insert new bite into database
    }
  }

  // checks if right arm or left arm database doesnt count left and right arm individually
  bool isArm(String part){
    return (part == lArm || part == rArm);
  }

  // card to display bite count for each body part
  Widget countCard(BuildContext context, List<Bite> bites, String bodyPart){
    String part = bodyPart;

    if(isArm(part)){
      part = 'arm';
    }

    return GestureDetector( 
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)), // rounded cards look nice

        child: Padding( 
          padding: EdgeInsets.all(5),
    
          child: Row( 
            children: <Widget>[ 
              Image.asset(URL + part + 'Bite.png',
                  height: 50, width: 50),

              Text('x ${countBites(bites, part)}'),
            ]
          ),
        )  
      ),

      onTap: () => _showAddBiteForm(context, part),
    );
  }

  // displays each body part and colors it depending on how many times bit
  Widget bodyPartImage(List<Bite> bites, String bodyPart){
    String part = bodyPart;
    int count;
    Color color;

    if(isArm(part)){
      part = 'arm';
    }

    count = countBites(bites, part);

    // determaining what color the body part should be
    if(count < 3){
      color = Colors.red[900].withOpacity(0);
    }
    else if(count > 27){
      color = Colors.red[900].withOpacity(opacity);
    }
    else{ 
      color = Colors.red[ (count~/3) * 100 ].withOpacity(opacity);
    }

    // the colored body part
    return ColorFiltered( 
      colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
      child: Image.asset(URL + bodyPart + '.png', scale: scale),
    );
  }

  // counts the amount of bites for that body part
  int countBites(List<Bite> bites, String bodyPart){
    int count = 0;

    for(int i = 0; i < bites.length; i++){
      if(bites[i].location == bodyPart){
        count++;
      }
    }

    return count;
  }
}