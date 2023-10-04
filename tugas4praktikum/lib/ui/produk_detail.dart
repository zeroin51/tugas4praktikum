import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:developer' as devLog;
import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:http/http.dart' as http;
import 'package:tokokita/ui/produk_page.dart';

class ProdukDetail extends StatefulWidget {
  Produk? produk;
  ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProdukForm(produk: widget.produk!)));
            },
            child: const Text("EDIT")),
        OutlinedButton(
            onPressed: () {
              confirmHapus();
            },
            child: Text("DELETE"))
      ],
    );
  }

  Future deleteData(int? id) async {
    final response = await http
        .delete(Uri.parse('http://192.168.1.104/toko-api/public/produk/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  void confirmHapus() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: const Text("Yakin ingin menghapus data ini?"),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      deleteData(widget.produk!.id).then((result) {
                        if (result['status'] == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProdukPage(produk: widget.produk)));
                        }
                      });
                    },
                    child: const Text("Ya")),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Batal")),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Kode : ${widget.produk!.kodeProduk}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${widget.produk!.namaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${widget.produk!.hargaProduk.toString()}",
              style: const TextStyle(fontSize: 18.0),
            ),
            _tombolHapusEdit()
          ],
        ),
      ),
    );
  }
}
