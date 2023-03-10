import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tutorialfirebase/CreateUserPage.dart';
import 'package:tutorialfirebase/MyHomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  late String email, password;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Tutorial Firebase"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Login Page",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          Offstage(
            offstage: error == '',
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: formulario(),
          ),
          butonLogin(),
          nuevoAqui(),
          buildOrLine(),
          BotonesGooleApple()
        ],
      ),
    );
  }

  Widget BotonesGooleApple() {
    return Column(
      children: [
        SignInButton(Buttons.Google, onPressed: () async {
          await entrarConGoogle();
          if (FirebaseAuth.instance.currentUser != null) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => MyHomePage()), (Route<dynamic> route) => false);
          }
        }),
        Offstage(
          offstage: !Platform.isIOS,
          child: SignInButton(Buttons.Apple, onPressed: () async {
            await entrarConApple();
            if (FirebaseAuth.instance.currentUser != null) {
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) => MyHomePage()), (Route<dynamic> route) => false);
            }
          }),
        )
      ],
    );
  }

  Future<UserCredential> entrarConGoogle()async{
    final GoogleSignInAccount? googleUser= await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? autentication = await googleUser?.authentication;
    final credentials = GoogleAuthProvider.credential(
      accessToken:  autentication?.accessToken,
      idToken: autentication?.idToken
    );
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }

  Future<UserCredential> entrarConApple() async{

    final rawNonce =generateNonce();
    final nonce = sha256toString(rawNonce);

    final appleCredentials = await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName
    ],
    nonce: nonce);

    final authCredential = OAuthProvider("apple.com").credential(
    idToken: appleCredentials.identityToken,
      rawNonce: rawNonce
    );

    return await FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  String sha256toString(String input){
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Widget buildOrLine() {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Divider()),
          Text("ó"),
          Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget nuevoAqui() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Nuevo aqui"),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateUserPage()));
            },
            child: Text("Registrarse")),
      ],
    );
  }

  Widget formulario() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            buildEmail(),
            const Padding(padding: EdgeInsets.only(top: 12)),
            buildPassword(),
          ],
        ));
  }

  Widget buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Correo",
          border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(8), borderSide: new BorderSide(color: Colors.black))),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String? value) {
        email = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  Widget buildPassword() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(8), borderSide: new BorderSide(color: Colors.black))),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
        password = value!;
      },
    );
  }

  Widget butonLogin() {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              UserCredential? credenciales = await login(email, password);
              if (credenciales != null) {
                if (credenciales.user != null) {
                  if (credenciales.user!.emailVerified) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage()),
                        (Route<dynamic> route) => false);
                  } else {
                    //todo Mostrar al usuario que debe verificar su email
                    setState(() {
                      error = "Debes verificar tu correo antes de acceder";
                    });
                  }
                }
              }
            }
          },
          child: Text("Login")),
    );
  }

  Future<UserCredential?> login(String email, String passwd) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //todo usuario no encontrado
        setState(() {
          error = "usuario no encontrado";
        });
      }
      if (e.code == 'wrong-password') {
        //todo contrasenna incorrecta
        setState(() {
          error = "contrasenna incorrecta";
        });
      }
    }
  }
}
