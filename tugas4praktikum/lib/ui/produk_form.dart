import 'dart:convert';
import 'dart:developer' as devLog;
import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:tokokita/ui/produk_page.dart';

class ProdukForm extends StatefulWidget {
  Produk? produk;
  ProdukForm({Key? key, this.produk}) : super(key: key);
  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PRODUK";
  String tombolSubmit = "Simpan";
  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "UBAH PRODUK";
        tombolSubmit = "Ubah";
        _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
        _namaProdukTextboxController.text = widget.produk!.kodeProduk!;
        _hargaProdukTextboxController.text =
            widget.produk!.hargaProduk.toString();
      });
    } else {
      judul = "TAMBAH PRODUK";
      tombolSubmit = "SIMPAN";
    }
  }

  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Produk"),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Kode Produk Harus Diisi";
        }
        return null;
      },
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Produk Harus Diisi";
        }
        return null;
      },
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Harga Harus Diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          devLog.log(tombolSubmit);
          if (tombolSubmit == "Ubah") {
            if (validate) {
              String kode_harga = _kodeProdukTextboxController.text;
              String nama_produk = _namaProdukTextboxController.text;
              int harga = int.parse(_hargaProdukTextboxController.text);
              productUpdate(kode_harga, nama_produk, harga);
            }
          } else {
            if (validate) {
              String kode_harga = _kodeProdukTextboxController.text;
              String nama_produk = _namaProdukTextboxController.text;
              int harga = int.parse(_hargaProdukTextboxController.text);
              String url = Platform.isAndroid
                  ? 'http://192.168.1.104/toko-api/public/produk'
                  : 'localhost/toko-api/public/produk';
              productCreate(url, kode_harga, nama_produk, harga);
            }
          }
        },
        child: Text(tombolSubmit));
  }

  Future productUpdate(
      String kode_produk, String nama_produk, int harga) async {
    final response = await http.put(
      Uri.parse(
          'http://192.168.1.104/toko-api/public/produk/${widget.produk!.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'kode_produk': kode_produk,
        'nama_produk': nama_produk,
        'harga': harga
      }),
    );
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProdukPage(),
        ),
      );
    } else {
      throw Exception('Failed to Update Data');
    }
  }

  Future productCreate(
      String url, String kode_produk, String nama_produk, int harga) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'kode_produk': kode_produk,
        'nama_produk': nama_produk,
        'harga': harga
      }),
    );
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    Produk produk = Produk.fromJson(jsonResponse);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Produk sukses ditambahkan"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Kode Produk : ${produk.kodeProduk.toString()}"),
                Text("Nama Produk : ${produk.namaProduk.toString()}"),
                Text("Harga Produk : ${produk.hargaProduk.toString()}")
              ],
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProdukPage()));
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _kodeProdukTextField(),
                      _namaProdukTextField(),
                      _hargaProdukTextField(),
                      _buttonSubmit(),
                    ],
                  )))),
    );
  }
}
