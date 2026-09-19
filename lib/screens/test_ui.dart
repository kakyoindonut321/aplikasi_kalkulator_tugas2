import 'package:flutter/material.dart';

class TestUi extends StatefulWidget {
  const TestUi({super.key});

  @override
  State<TestUi> createState() => _TestUiState();
}

class _TestUiState extends State<TestUi> {
  static const _green = Color(0xFF00A651);
  static const _yellow = Color(0xFFFFD100);
  static const _red = Color(0xFFED1C24);
  static const _ink = Color(0xFF1A2A22);
  static const _muted = Color(0xFF6D7B73);

  final _categories = const ['Semua', 'Mie', 'Nasi', 'Minuman'];
  final _menus = const [
    _MenuItem(
      name: 'Mie Goreng Spesial',
      description: 'Telur, sawi, dan taburan bawang goreng',
      price: 'Rp12.000',
      icon: Icons.ramen_dining,
      color: Color(0xFFFFE28A),
      category: 'Mie',
    ),
    _MenuItem(
      name: 'Mie Kuah Soto',
      description: 'Kuah gurih hangat dengan irisan ayam',
      price: 'Rp13.000',
      icon: Icons.soup_kitchen,
      color: Color(0xFFFFC5B5),
      category: 'Mie',
    ),
    _MenuItem(
      name: 'Nasi Telur Kriuk',
      description: 'Nasi pulen, telur ceplok, sambal merah',
      price: 'Rp15.000',
      icon: Icons.lunch_dining,
      color: Color(0xFFC9E8A9),
      category: 'Nasi',
    ),
    _MenuItem(
      name: 'Es Teh Jumbo',
      description: 'Manis segar, teman makan paling pas',
      price: 'Rp6.000',
      icon: Icons.local_drink,
      color: Color(0xFFBDE7EE),
      category: 'Minuman',
    ),
  ];

  int _selectedCategory = 0;
  int _cartCount = 2;
  String? _addedMenu;

  List<_MenuItem> get _visibleMenus {
    final category = _categories[_selectedCategory];
    if (category == 'Semua') return _menus;
    return _menus.where((menu) => menu.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildPromo()),
            SliverToBoxAdapter(child: _buildSectionHeading()),
            SliverToBoxAdapter(child: _buildCategories()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              sliver: SliverList.builder(
                itemCount: _visibleMenus.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMenuCard(_visibleMenus[index]),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _green,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2200A651),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.ramen_dining,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WARMIN•DO',
                  style: TextStyle(
                    color: _green,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Makan enak, harga bersahabat',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded, color: _ink),
                style: IconButton.styleFrom(backgroundColor: Colors.white),
              ),
              Positioned(
                right: 7,
                top: 5,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: _red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2200A651),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LAPER DATANG?',
                  style: TextStyle(
                    color: _yellow,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Mie hangat\nsiap menemani.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Pesan sekarang dan ambil di kasir.',
                  style: TextStyle(color: Color(0xFFD9F2DF), fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: _yellow,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: const Icon(Icons.ramen_dining, color: _red, size: 52),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Mau makan apa?',
              style: TextStyle(
                color: _ink,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            'Lihat semua',
            style: TextStyle(
              color: _red,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 2),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == _selectedCategory;
          return ChoiceChip(
            label: Text(_categories[index]),
            selected: selected,
            onSelected: (_) => setState(() => _selectedCategory = index),
            labelStyle: TextStyle(
              color: selected ? Colors.white : _muted,
              fontWeight: FontWeight.w700,
            ),
            backgroundColor: Colors.white,
            selectedColor: _red,
            side: BorderSide(color: selected ? _red : const Color(0xFFE5EAE5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(_MenuItem menu) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDE8)),
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: menu.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(menu.icon, color: _ink, size: 38),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.name,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  menu.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  menu.price,
                  style: const TextStyle(
                    color: _red,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Tambah ke pesanan',
            onPressed: () => setState(() {
              _cartCount++;
              _addedMenu = menu.name;
            }),
            icon: const Icon(Icons.add, color: _ink, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: _yellow,
              minimumSize: const Size(40, 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8EDE8))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _addedMenu == null ? 'Pesananmu' : 'Ditambahkan',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$_cartCount item',
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined, size: 18),
            label: const Text('Lihat pesanan'),
            style: FilledButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
    required this.category,
  });

  final String name;
  final String description;
  final String price;
  final IconData icon;
  final Color color;
  final String category;
}
