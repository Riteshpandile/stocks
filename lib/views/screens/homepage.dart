import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/controllers/providers/tabindexnotifier.dart';
import 'package:stocks/views/screens/stockslist/stockslist.dart';
import 'package:stocks/views/screens/watchlist/watchlist.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  final List<Widget> _pages = const [
    Stocklist(),
    WatchlistPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(tabIndexProvider);

    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(tabIndexProvider.notifier).setTab(index);
        },
        selectedItemColor: Colors.blue, 
        unselectedItemColor: Colors.grey,
        items: const [
          
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Watchlist',
          ),
        
        ],
      ),
    );
  }
}
