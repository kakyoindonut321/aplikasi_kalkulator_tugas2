import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/database_helper.dart';
import '../models/menu_model.dart';

class TestDbScreen extends StatefulWidget {
  const TestDbScreen({super.key});

  @override
  State<TestDbScreen> createState() => _TestDbScreenState();
}

class _TestDbScreenState extends State<TestDbScreen> {
  List<MenuModel> _menuList = [];
  bool _isLoading = true;

  // Pilihan Tipe Menu
  final List<String> _tipeOptions = ['Makanan', 'Minuman', 'Tambahan'];

  @override
  void initState() {
    super.initState();
    _refreshMenuList();
  }

  Future<void> _refreshMenuList() async {
    setState(() => _isLoading = true);
    final menus = await DatabaseHelper.instance.getAllMenu();
    setState(() {
      _menuList = menus;
      _isLoading = false;
    });
  }

  // --- DIALOG POP-UP FORM (TAMBAH & EDIT) ---
  void _showMenuFormDialog([MenuModel? existingMenu]) {
    final formKey = GlobalKey<FormState>();

    final namaController = TextEditingController(
      text: existingMenu?.nama ?? '',
    );
    final deskripsiController = TextEditingController(
      text: existingMenu?.deskripsi ?? '',
    );
    final hargaController = TextEditingController(
      text: existingMenu != null ? existingMenu.harga.toString() : '',
    );

    // Set default tipe ke 'Makanan' atau gunakan tipe dari menu yang di-edit
    String selectedTipe = existingMenu?.tipe ?? 'Makanan';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                existingMenu == null ? 'Tambah Menu Baru' : 'Edit Menu',
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1. INPUT NAMA
                      TextFormField(
                        controller: namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Menu',
                          hintText: 'Misal: Nasi Goreng No. 1',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama menu wajib diisi';
                          }
                          if (value.trim().length < 3) {
                            return 'Nama menu minimal 3 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // 2. INPUT TIPE (DROPDOWN)
                      DropdownButtonFormField<String>(
                        value: _tipeOptions.contains(selectedTipe)
                            ? selectedTipe
                            : _tipeOptions.first,
                        decoration: const InputDecoration(
                          labelText: 'Tipe Menu',
                        ),
                        items: _tipeOptions.map((tipe) {
                          return DropdownMenuItem(
                            value: tipe,
                            child: Text(tipe),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setDialogState(() {
                              selectedTipe = newValue;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // 3. INPUT HARGA (STRICT NUMERIC)
                      TextFormField(
                        controller: hargaController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ], // Blokir non-angka
                        decoration: const InputDecoration(
                          labelText: 'Harga (Rp)',
                          hintText: 'Misal: 10000',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harga wajib diisi';
                          }
                          final hargaInt = int.tryParse(value);
                          if (hargaInt == null) {
                            return 'Harga harus berupa angka valid';
                          }
                          if (hargaInt < 500) {
                            return 'Harga minimal Rp 500';
                          }
                          if (hargaInt > 1000000) {
                            return 'Harga melebihi batas (Maks Rp 1.000.000)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // 4. INPUT DESKRIPSI
                      TextFormField(
                        controller: deskripsiController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                          hintText: 'Penjelasan singkat menu',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Deskripsi wajib diisi';
                          }
                          if (value.trim().length < 5) {
                            return 'Deskripsi minimal 5 karakter';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final menuData = MenuModel(
                        id: existingMenu?.id,
                        nama: namaController.text.trim(),
                        tipe: selectedTipe,
                        harga: int.parse(hargaController.text),
                        deskripsi: deskripsiController.text.trim(),
                      );

                      if (existingMenu == null) {
                        // Tambah Data
                        await DatabaseHelper.instance.insertMenu(menuData);
                      } else {
                        // Update Data
                        await DatabaseHelper.instance.updateMenu(menuData);
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                        _refreshMenuList();
                      }
                    }
                  },
                  child: Text(existingMenu == null ? 'Simpan' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- DIALOG KONFIRMASI HAPUS ---
  void _showDeleteConfirmation(MenuModel menu) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Menu'),
          content: Text('Yakin ingin menghapus "${menu.nama}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await DatabaseHelper.instance.deleteMenu(menu.id!);
                if (context.mounted) {
                  Navigator.pop(context);
                  _refreshMenuList();
                }
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Menu Warmindo')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Menu Utama'),
                      onPressed: () => _showMenuFormDialog(),
                    ),
                  ),
                ),
                Expanded(
                  child: _menuList.isEmpty
                      ? const Center(child: Text('Belum ada data menu.'))
                      : ListView.builder(
                          itemCount: _menuList.length,
                          itemBuilder: (context, index) {
                            final menu = _menuList[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              child: ListTile(
                                title: Text(
                                  '${menu.nama} [${menu.tipe}]',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(menu.deskripsi),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${menu.harga}',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () =>
                                          _showMenuFormDialog(menu),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          _showDeleteConfirmation(menu),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
