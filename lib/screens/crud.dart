import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/database_helper.dart';
import '../models/menu_model.dart';

// === WARMINDO COLOR PALETTE ===
const Color warmindoRed = Color(0xFFE51A24);
const Color warmindoYellow = Color(0xFFFFD100);
const Color warmindoGreen = Color(0xFF008752);
const Color warmindoBg = Color(0xFFFAF7F2);
const Color textDark = Color(0xFF2C2C2C);
const Color textMuted = Color(0xFF757575);

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
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

  // Helper untuk menentukan Ikon berdasarkan Tipe
  IconData _getMenuIcon(String tipe) {
    switch (tipe.toLowerCase()) {
      case 'makanan':
        return Icons.ramen_dining_rounded;
      case 'minuman':
        return Icons.local_drink_rounded;
      case 'tambahan':
        return Icons.egg_alt_rounded;
      default:
        return Icons.restaurant_menu_rounded;
    }
  }

  // Helper untuk menentukan Warna Ikon berdasarkan Tipe
  Color _getMenuColor(String tipe) {
    switch (tipe.toLowerCase()) {
      case 'makanan':
        return warmindoRed; // Merah
      case 'minuman':
        return Colors.blue; // Biru
      case 'tambahan':
        return Colors.amber.shade700; // Kuning / Amber
      default:
        return textDark;
    }
  }

  // --- HELPER STYLING DEKORASI INPUT FIELD (SEPERTI LOGIN) ---
  InputDecoration _buildInputDecoration(
    String label,
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: warmindoRed),
      labelStyle: const TextStyle(color: textDark),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: warmindoRed, width: 2),
      ),
      filled: true,
      fillColor: warmindoBg,
    );
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

    String selectedTipe = existingMenu?.tipe ?? 'Makanan';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: warmindoYellow.withValues(alpha: 0.8),
                  width: 2,
                ),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: warmindoRed.withValues(alpha: 0.1),
                    child: Icon(
                      existingMenu == null
                          ? Icons.add_rounded
                          : Icons.edit_rounded,
                      color: warmindoRed,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    existingMenu == null ? 'Tambah Menu Baru' : 'Edit Menu',
                    style: const TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      // 1. INPUT NAMA
                      TextFormField(
                        controller: namaController,
                        decoration: _buildInputDecoration(
                          'Nama Menu',
                          'Misal: Indomie Goreng Spesial',
                          Icons.fastfood,
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
                      const SizedBox(height: 14),

                      // 2. INPUT TIPE (DROPDOWN)
                      DropdownButtonFormField<String>(
                        value: _tipeOptions.contains(selectedTipe)
                            ? selectedTipe
                            : _tipeOptions.first,
                        decoration: _buildInputDecoration(
                          'Tipe Menu',
                          'Pilih kategori',
                          _getMenuIcon(selectedTipe),
                        ),
                        items: _tipeOptions.map((tipe) {
                          return DropdownMenuItem(
                            value: tipe,
                            child: Row(children: [Text(tipe)]),
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
                      const SizedBox(height: 14),

                      // 3. INPUT HARGA
                      TextFormField(
                        controller: hargaController,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: _buildInputDecoration(
                          'Harga (Rp)',
                          'Misal: 12000',
                          Icons.payments_rounded,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Harga wajib diisi';
                          }

                          // Gunakan BigInt atau num/double agar tidak rentan overflow int 32-bit
                          final hargaNum = num.tryParse(value.trim());
                          if (hargaNum == null) {
                            return 'Harga harus berupa angka valid';
                          }
                          if (hargaNum < 500) {
                            return 'Harga minimal Rp 500';
                          }
                          if (hargaNum > 1000000) {
                            return 'Harga melebihi batas (Maks Rp 1.000.000)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // 4. INPUT DESKRIPSI
                      TextFormField(
                        controller: deskripsiController,
                        maxLines: 2,
                        decoration: _buildInputDecoration(
                          'Deskripsi',
                          'Penjelasan singkat menu',
                          Icons.description_rounded,
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
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: textMuted),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: warmindoGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      final menuData = MenuModel(
                        id: existingMenu?.id,
                        nama: namaController.text.trim(),
                        tipe: selectedTipe,
                        harga: int.parse(hargaController.text),
                        deskripsi: deskripsiController.text.trim(),
                      );

                      if (existingMenu == null) {
                        await DatabaseHelper.instance.insertMenu(menuData);
                      } else {
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: warmindoRed),
              SizedBox(width: 8),
              Text('Hapus Menu', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text('Yakin ingin menghapus "${menu.nama}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: warmindoRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await DatabaseHelper.instance.deleteMenu(menu.id!);
                if (context.mounted) {
                  Navigator.pop(context);
                  _refreshMenuList();
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warmindoBg,
      appBar: AppBar(
        title: const Text(
          'Kelola Menu Warmindo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: warmindoRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: warmindoRed))
          : Column(
              children: [
                // Tombol Tambah Menu
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_rounded),
                      label: const Text(
                        'TAMBAH MENU UTAMA',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warmindoGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () => _showMenuFormDialog(),
                    ),
                  ),
                ),

                // Daftar Menu
                Expanded(
                  child: _menuList.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada data menu.',
                            style: TextStyle(color: textMuted, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: _menuList.length,
                          itemBuilder: (context, index) {
                            // Di dalam itemBuilder ListView.builder:
                            final menu = _menuList[index];
                            final icon = _getMenuIcon(menu.tipe);
                            final iconColor = _getMenuColor(
                              menu.tipe,
                            ); // Tambahkan ini

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: warmindoYellow.withValues(alpha: 0.6),
                                  width: 1.5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Icon Refleksi Tipe Menu
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: iconColor.withValues(
                                        alpha: 0.12,
                                      ),
                                      child: Icon(
                                        icon,
                                        color: iconColor,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Detail Menu
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  menu.nama,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: textDark,
                                                  ),
                                                ),
                                              ),
                                              // Badge Tipe
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: warmindoGreen
                                                      .withValues(alpha: 0.12),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  menu.tipe,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: warmindoGreen,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            menu.deskripsi,
                                            style: const TextStyle(
                                              color: textMuted,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Rp ${menu.harga}',
                                            style: const TextStyle(
                                              color: warmindoGreen,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Action Buttons (Edit & Delete)
                                    Column(
                                      children: [
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: const EdgeInsets.all(6),
                                          icon: const Icon(
                                            Icons.edit_rounded,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          onPressed: () =>
                                              _showMenuFormDialog(menu),
                                        ),
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: const EdgeInsets.all(6),
                                          icon: const Icon(
                                            Icons.delete_rounded,
                                            color: warmindoRed,
                                            size: 20,
                                          ),
                                          onPressed: () =>
                                              _showDeleteConfirmation(menu),
                                        ),
                                      ],
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
