import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/fish_provider.dart';

class FishDetailScreen extends StatelessWidget {
  static const routeName = '/fish-details';

  Widget titleSection(String name) { 
    return Container (
      padding: const EdgeInsets.all(32),
      child: Text(name),
    );
  }

  Widget descriptionSection(String description) { 
    return Container (
      padding: const EdgeInsets.all(32),
      child: Text(description, softWrap: true,),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fishId = ModalRoute.of(context).settings.arguments as String;
    final loadedFish = Provider.of<FishProvider>(context, listen: false).findById(fishId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Fish details'),
      ),
      body: ListView(
        children: <Widget>[
          Image.network(loadedFish.image, width: 600, height: 200, fit: BoxFit.fill),
          titleSection(loadedFish.name),
          descriptionSection(loadedFish.description)
        ],
      )
    );
  }
}