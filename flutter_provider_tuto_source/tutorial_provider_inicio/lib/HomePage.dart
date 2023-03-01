import 'package:flutter/material.dart';
import 'package:tutorial_provider/LoginPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isAuthenticated ? Text('Inicia session'): Text('Bienvenido'),
        actions: [
          isAuthenticated
              ? IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    setState(() {
                      isAuthenticated = false;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () async {
                    bool login = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                    if (login) {
                      setState(() {
                        isAuthenticated = true;
                      });
                    }
                  },
                ),
        ],
      ),
      body: Center(
        child: !isAuthenticated
            ? Text(
                'NO has iniciado sesión',
                style: TextStyle(fontSize: 20),
              )
            : Text('Has iniciado sesión correctamente', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
