import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  final List<dynamic> favorites;
  final VoidCallback onUpdateFavorites; // Callback untuk refresh HomePage

  const FavoritePage({
    super.key,
    required this.favorites,
    required this.onUpdateFavorites,
  });

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<dynamic> favorites;
  int _selectedIndex = 1; // Default active tab is Favorite

  @override
  void initState() {
    super.initState();
    favorites = widget.favorites;
  }

  void _removeFromFavorites(int index) {
    final removedItem = favorites[index];
    setState(() {
      favorites.removeAt(index);
    });
    widget.onUpdateFavorites(); // Memanggil callback untuk refresh HomePage
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedItem['name']} removed from favorites!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update tab index
    });
    if (index == 0) {
      widget.onUpdateFavorites(); // Pastikan data di HomePage terupdate
      Navigator.pop(context); // Kembali ke HomePage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final amiibo = favorites[index];
                return Dismissible(
                  key: Key(amiibo['head']),
                  direction: DismissDirection.horizontal, // Swipe kanan dan kiri
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) => _removeFromFavorites(index),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          amiibo['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        amiibo['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Head: ${amiibo['head']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
        ],
        currentIndex: _selectedIndex, // Menentukan tab yang aktif
        selectedItemColor: Colors.amber, // Warna icon aktif
        unselectedItemColor: Colors.grey, // Warna icon tidak aktif
        onTap: _onItemTapped,
      ),
    );
  }
}
