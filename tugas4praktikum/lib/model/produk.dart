class Produk{
  int? id;
  String? kodeProduk;
  String? namaProduk;
  int? hargaProduk;

  Produk({this.id, this.kodeProduk, this.namaProduk, this.hargaProduk});

  factory Produk.fromJson(Map<String, dynamic> obj){
    return Produk(
      id: int.parse((obj['data'] as Map)['id']),
      kodeProduk: (obj['data'] as Map) ['kode_produk'],
      namaProduk: (obj['data'] as Map)['nama_produk'],
      hargaProduk: int.parse((obj['data'] as Map)['harga']),
    );
  }
}