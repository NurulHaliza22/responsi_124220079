import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi/detail_screen.dart';
import 'package:responsi/favorite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> amiiboList = [];
  List<dynamic> favoriteList = [];
  bool isLoading = true;

  int _selectedIndex = 0; // Menyimpan indeks tab yang aktif

  @override
  void initState() {
    super.initState();
    fetchAmiiboData();
  }

  Future<void> fetchAmiiboData() async {
    try {
      final response =
          await http.get(Uri.parse('https://www.amiiboapi.com/api/amiibo'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          amiiboList = data['amiibo'];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _toggleFavorite(dynamic amiibo) {
    setState(() {
      if (favoriteList.contains(amiibo)) {
        favoriteList.remove(amiibo);
      } else {
        favoriteList.add(amiibo);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          favoriteList.contains(amiibo)
              ? '${amiibo['name']} added to favorites!'
              : '${amiibo['name']} removed from favorites!',
        ),
      ),
    );
  }

  void _navigateToFavorite() {
    setState(() {
      _selectedIndex = 1; // Update indeks saat navigasi ke Favorite
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritePage(
          favorites: favoriteList,
          onUpdateFavorites: () => setState(() {}),
        ),
      ),
    ).then((_) {
      setState(() {
        _selectedIndex = 0; // Kembali ke tab Home setelah keluar dari Favorite
      });
    });
  }

  void _navigateToDetail(dynamic amiibo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          amiibo: amiibo,
          onToggleFavorite: () => _toggleFavorite(amiibo),
          isFavorite: favoriteList.contains(amiibo),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nitendo Amiibo'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: amiiboList.length,
              itemBuilder: (context, index) {
                final amiibo = amiiboList[index];
                return GestureDetector(
                  onTap: () => _navigateToDetail(amiibo),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            child: Image.network(
                              amiibo['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      amiibo['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      amiibo['gameSeries'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _toggleFavorite(amiibo),
                                child: Icon(
                                  favoriteList.contains(amiibo)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: favoriteList.contains(amiibo)
                                      ? Colors.red
                                      : Colors.grey, // Warna berubah jika difavoritkan
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
        currentIndex: _selectedIndex, // Mengatur indeks aktif
        selectedItemColor: Colors.amber, // Warna icon aktif
        unselectedItemColor: Colors.grey, // Warna icon tidak aktif
        onTap: (index) {
          if (index == 1) {
            _navigateToFavorite(); // Navigasi ke halaman Favorite
          } else {
            setState(() {
              _selectedIndex = 0; // Update indeks untuk Home
            });
          }
        },
      ),
    );
  }
}
