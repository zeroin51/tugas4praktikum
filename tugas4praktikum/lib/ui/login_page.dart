import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/ui/registrasi_page.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

import '../model/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  Widget _emailTextField() {
    return TextFormField(
        decoration: const InputDecoration(labelText: "email"),
        keyboardType: TextInputType.emailAddress,
        controller: _emailTextboxController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Email harus diisi';
          }
          return null;
        });
  }

  Widget _buttonLogin() {
    return ElevatedButton(
        child: const Text("Login"),
        onPressed: () async {
          var validate = _formKey.currentState!.validate();
          String email = _emailTextboxController.text;
          String password = _passwordTextboxController.text;
          if (validate) {
            String url = Platform.isAndroid
                ? 'http://192.168.1.104/toko-api/public/login'
                : ' localhost/toko-api/public/login';
            await loginMember(url, email, password);
            await saveLoginStatus(true, email, password);
          }
        });
  }

  Future<void> saveLoginStatus(
      bool isLoggedIn, String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  Future loginMember(String url, String email, String password) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'email': email, 'password': password}),
    );
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    Login login = Login.fromJson(jsonResponse);
    if (login.code == 200) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Login Sukses dengan Token ${login.token}"),
              content: Text(login.userEmail.toString()),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ProdukPage()));
                  },
                ),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(login.data.toString()),
              content: Text(_emailTextboxController.text),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  Widget _menuRegistrasi() {
    return Center(
        child: InkWell(
            child: const Text(
              "Registrasi",
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrasiPage()));
            }));
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _emailTextField(),
                    _passwordTextField(),
                    _buttonLogin(),
                    const SizedBox(
                      height: 30,
                    ),
                    _menuRegistrasi()
                  ],
                ),
              )),
        ));
  }
}
