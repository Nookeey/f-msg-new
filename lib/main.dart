import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/fish_list_screen.dart';
import './screens/fish_details_screen.dart';
import './screens/chat_list_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash-screen.dart';

import './providers/fish_provider.dart';
import './providers/auth_provider.dart';
import './providers/chat_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, FishProvider>(
          builder: (ctx, auth, previousFish) => FishProvider(
            auth.token,
            previousFish == null ? [] : previousFish.items 
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChatProvider>(
          builder: (ctx, auth, previousChats) => ChatProvider(
            auth.token,
            auth.userId,
            previousChats == null ? [] : previousChats.items 
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
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
            ChatListScreen.routeName: (ctx) => auth.isAuth
              ? ChatListScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          }
        ),
      )
    );
  }
}
