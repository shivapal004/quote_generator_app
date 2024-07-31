import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> favorites;
  final Function(String) onDeleteFavorite;
  final Function(String) onCopyFavorite;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onDeleteFavorite,
    required this.onCopyFavorite,
  });

  void _shareFavorite(String quote) {
    Share.share(quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favorites.isEmpty
          ? const Center(child: Text('No favorite quotes yet!', style: TextStyle(
        fontSize: 20
      ),))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final quote = favorites[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 5, // Add elevation to create a shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16), // Padding inside the card
              title: Text(quote, style: const TextStyle(fontSize: 16)),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'copy') {
                    onCopyFavorite(quote);
                  } else if (value == 'delete') {
                    onDeleteFavorite(quote);
                  } else if (value == 'share') {
                    _shareFavorite(quote);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'copy',
                    child: Text('Copy'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'share',
                    child: Text('Share'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
