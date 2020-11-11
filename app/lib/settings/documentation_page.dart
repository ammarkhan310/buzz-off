import 'package:flutter/material.dart';

class DocumentationPage extends StatefulWidget {
  @override
  _DocumentationPageState createState() => _DocumentationPageState();
}

class _DocumentationPageState extends State<DocumentationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text('Docs'),
          floating: true,
          flexibleSpace: Container(),
          expandedHeight: 200,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(title: Text('Placeholder #$index')),
            childCount: 20,
          ),
        ),
      ],
    ));
  }
}
