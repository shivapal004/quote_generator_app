import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../apis/apis.dart';
import 'package:flutter/services.dart';
import 'favourite_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const RandomQuoteScreen(),
    );
  }
}


class RandomQuoteScreen extends StatefulWidget {
  const RandomQuoteScreen({super.key});

  @override
  State<RandomQuoteScreen> createState() => _RandomQuoteScreenState();
}

class _RandomQuoteScreenState extends State<RandomQuoteScreen> {
  String _quote = "";
  String _author = "";
  int _currentIndex = 0;
  final Set<String> _favorites = <String>{};
  final PageController _pageController = PageController();

  void _getQuote() async {
    try {
      var quoteData = await fetchQuote();
      setState(() {
        _quote = quoteData['quote']!;
        _author = quoteData['author']!;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load quote')),
      );
    }
  }

  void _shareQuote() {
    Share.share('$_quote - $_author');
  }

  void _copyQuote() {
    final String quoteText = '"$_quote" - $_author';
    Clipboard.setData(ClipboardData(text: quoteText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quote copied to clipboard')),
    );
  }

  void _toggleFavorite() {
    final String quoteText = '$_quote - $_author';
    setState(() {
      if (_favorites.contains(quoteText)) {
        _favorites.remove(quoteText);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        _favorites.add(quoteText);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
      }
    });
  }

  void _deleteFavorite(String quote) {
    setState(() {
      _favorites.remove(quote);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites')),
      );
    });
  }

  void _copyFavorite(String quote) {
    Clipboard.setData(ClipboardData(text: quote));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quote copied to clipboard')),
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _getQuote();
  }

  @override
  Widget build(BuildContext context) {

    // Determine the AppBar title based on the current index
    String appBarTitle = _currentIndex == 0 ? "Daily Inspiration" : "My Favorites";

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(appBarTitle)),
        backgroundColor: Colors.blueGrey[900], // AppBar color

      ),


      body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        children: [
          Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Row(
                  children: [
                    SizedBox(
                      width: 50,
                        height: 30,
                        child: Image.asset("assets/images/quote.png", color: Colors.white,)),
                  ],
                ),

                const SizedBox(height: 40),

                Text(
                  _quote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(height: 10.0),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "- $_author",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.blue),
                      onPressed: _getQuote,
                    ),

                    const SizedBox(width: 25,),

                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.blue),
                      onPressed: _copyQuote,
                    ),

                    const SizedBox(width: 25,),

                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.blue),
                      onPressed: _shareQuote,
                    ),

                    const SizedBox(width: 25,),

                    IconButton(
                      icon: Icon(
                        _favorites.contains('$_quote - $_author') ? Icons.favorite : Icons.favorite_border,
                        color: Colors.blue,
                      ),
                      onPressed: _toggleFavorite,
                    ),

                    const SizedBox(width: 25,),

                  ],
                ),
              ],
            ),
          ),
        ),

          // Favorites Screen
          FavoritesScreen(
            favorites: _favorites.toList(),
            onDeleteFavorite: _deleteFavorite,
            onCopyFavorite: _copyFavorite,
          ),
  ]
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),

        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey, // Color for unselected items
        backgroundColor: Colors.blueGrey[800], // BottomNavigationBar color
        onTap: _onBottomNavTapped,
      ), // Body color
    );
  }
}

