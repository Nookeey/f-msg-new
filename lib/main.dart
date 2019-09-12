import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/fish_list_screen.dart';
import './screens/fish_details_screen.dart';
import './screens/chat_list_screen.dart';
import './screens/auth_screen.dart';

import './providers/fish_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: FishProvider(),
        )
      ],
      child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.black,
            primaryIconTheme: IconThemeData(color: Colors.white),
            primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.white)
            ),
            textTheme: TextTheme(title: TextStyle(color: Colors.black)),
            scaffoldBackgroundColor: Colors.black,
            fontFamily: 'Roboto',
          ),
          home: FishListScreen(),
          routes: {
            FishDetailScreen.routeName: (ctx) => FishDetailScreen(),
            ChatListScreen.routeName: (ctx) => ChatListScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          }),
    );
  }
}
