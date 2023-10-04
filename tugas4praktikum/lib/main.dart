import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas4praktikum/ui/login_page.dart';
import 'package:tugas4praktikum/ui/produk_detail.dart';
import 'package:tugas4praktikum/ui/produk_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  Future<bool> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Toko Kita',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return snapshot.data == true  ? ProdukPage() : LoginPage();
            }else{
              return CircularProgressIndicator();
            }
        },
      ),
    );
  }
}
