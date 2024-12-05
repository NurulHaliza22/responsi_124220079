import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final dynamic amiibo;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;

  const DetailScreen({
    super.key,
    required this.amiibo,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool isFavorite; // Local state to manage favorite status

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite; // Initialize with the passed favorite status
  }

  void _handleFavoriteToggle() {
    setState(() {
      isFavorite = !isFavorite; // Toggle the local favorite status
    });
    widget.onToggleFavorite(); // Trigger the callback to update the favorite list globally
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.amiibo['name']),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white, // Change color dynamically
            ),
            onPressed: _handleFavoriteToggle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display the Amiibo image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.amiibo['image'], // Assuming the image URL is in widget.amiibo['image']
                    fit: BoxFit.contain, // Ensure the image is not cropped
                    height: 200, // Set the height of the image to keep it fixed
                    width: double.infinity, // Ensure the image covers the full width
                  ),
                ),
                const SizedBox(height: 16),

                // Display Amiibo details
                Text(
                  widget.amiibo['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildRow('Amiibo Series', widget.amiibo['amiiboSeries']),
                _buildRow('Character', widget.amiibo['character']),
                _buildRow('Game Series', widget.amiibo['gameSeries']),
                _buildRow('Type', widget.amiibo['type']),
                _buildRow('Head', widget.amiibo['head']),
                _buildRow('Tail', widget.amiibo['tail']),
                const Divider(color: Colors.grey),
                const Text(
                  'Release Dates',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                _buildRow('Australia', widget.amiibo['release']['au'] ?? 'N/A'),
                _buildRow('Europe', widget.amiibo['release']['eu'] ?? 'N/A'),
                _buildRow('Japan', widget.amiibo['release']['jp'] ?? 'N/A'),
                _buildRow('North America', widget.amiibo['release']['na'] ?? 'N/A'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build row with label and value
  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
