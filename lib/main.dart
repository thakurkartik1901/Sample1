import 'package:flutter/material.dart';
import 'package:oodles/users_screen.dart';
import 'package:provider/provider.dart';

import 'package:oodles/provider/users_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UsersProvider>(
            create: (context) => UsersProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Oodles',
          home: Consumer<UsersProvider>(builder: (ctx, userProviderRef, _) {
            if (userProviderRef.items == null) {
              return CircularProgressIndicator();
            }
            return UsersScreen();
          }),
        ));
  }
}
