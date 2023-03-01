import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_provider/AuthModel.dart';
import 'package:tutorial_provider/LoginPage.dart';
import 'HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthModel()),
      ],
      child: MaterialApp(
        title: 'Mi aplicación',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthModel> (
          builder: (_, authModel, __){
            return authModel.isAuthenticated ? HomePage(): LoginPage();
          },
        ),
      ),
    );
  }
}
