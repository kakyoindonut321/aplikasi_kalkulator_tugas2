class MenuModel {
  final int? id;
  final String nama;
  final String deskripsi;
  final int harga;
  final String tipe; // e.g., 'Makanan', 'Minuman', 'Topping'

  MenuModel({
    this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.tipe,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'harga': harga,
      'tipe': tipe,
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: map['id'],
      nama: map['nama'],
      deskripsi: map['deskripsi'],
      harga: map['harga'],
      tipe: map['tipe'],
    );
  }
}
