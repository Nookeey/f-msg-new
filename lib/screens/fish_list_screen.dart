import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/fish_provider.dart';

import '../models/fish.dart';

import '../screens/fish_details_screen.dart';
import '../screens/chat_list_screen.dart';

class FishListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FishListScreenState();
  }
}

class _FishListScreenState extends State<FishListScreen> {
  List<Fish> _fishItems;

  Widget _buildSomeFishCart(Fish fish, int index) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: SizedBox(
            height: 50.0,
            width: 50.0,
            child: Image.network(fish.image),
          ),
          title: Text(fish.name),
          subtitle: Text(fish.description.substring(0, 30)+'...'),
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            Navigator.of(context).pushNamed(
              FishDetailScreen.routeName,
              arguments: fish.id
            );
          },
        ),
        Divider(
          height: 12.0,
          color: Colors.grey[800],
        )
      ],
    );
  }

  Widget _buildFishList(List<Fish> fishs) {
    Widget fishCards;
    if (fishs.length > 0) {
      fishCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) => _buildSomeFishCart(fishs[index], index),
        itemCount: fishs.length,
      );
    } else {
      fishCards = Container();
    }
    return fishCards;
  }

  @override
  Widget build(BuildContext context) {
    final _fishProvider = Provider.of<FishProvider>(context);
    _fishProvider.fetchAndSetFish();
    _fishItems = _fishProvider.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Fish list'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more),
            onPressed: () {
              Navigator.of(context).pushNamed(
                ChatListScreen.routeName
              );
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          child: _buildFishList(_fishItems),
        )
      ),
    );
  }
}