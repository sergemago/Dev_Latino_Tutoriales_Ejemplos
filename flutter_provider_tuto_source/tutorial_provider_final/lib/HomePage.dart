import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_provider/LoginPage.dart';

import 'AuthModel.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final AuthModel authModel = Provider.of<AuthModel>(context);

    if(!authModel.isAuthenticated){
      return LoginPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: !authModel.isAuthenticated ? Text('Inicia session'): Text('Bienvenido'),
        actions: [
          authModel.isAuthenticated
              ? IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    authModel.logout();
                  },
                )
              : IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );

                  },
                ),
        ],
      ),
      body: Center(
        child: !authModel.isAuthenticated
            ? Text(
                'NO has iniciado sesión',
                style: TextStyle(fontSize: 20),
              )
            : Text('Has iniciado sesión correctamente', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
