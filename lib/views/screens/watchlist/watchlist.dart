import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/controllers/providers/stockproviders.dart';
import 'package:stocks/models/stocksmodel.dart';
import 'package:stocks/services/sharedpreference.dart';
import 'package:stocks/utils/Apputils.dart';
import 'package:stocks/utils/stringkey.dart';
import 'package:stocks/utils/styles.dart';
import 'package:stocks/views/widgets/drawer.dart';
import 'package:stocks/views/widgets/stockcard.dart';


class WatchlistPage extends ConsumerStatefulWidget {
  const WatchlistPage({super.key});

  @override
  ConsumerState<WatchlistPage> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistPage> {
  String searchQuery = '';
  late Future<List<StockModel>> _filteredWatchlistFuture;

  @override
  void initState() {
    super.initState();
    _loadFilteredWatchlist();
  }

  void _loadFilteredWatchlist() {
    _filteredWatchlistFuture = _getFilteredWatchlist();
  }

  Future<List<StockModel>> _getFilteredWatchlist() async {
    final allStocks = await ref.read(stockListProvider.future);
    final savedSymbolsRaw = await SharedPreferenceService.getStringListAsync(Stringkeys.watchlist) ?? [];

    final savedSymbols = savedSymbolsRaw.map((e) => e.trim().toUpperCase()).toList();

    return allStocks.where((stock) => savedSymbols.contains(stock.symbol.toUpperCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: AppStyles.inputDecoration(label: "Search ", prefixIcon: Icon(Icons.search) ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase().trim();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StockModel>>(
              future: _filteredWatchlistFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No stocks in watchlist."));
                }

                final filtered = snapshot.data!
                    .where((s) => s.symbol.toLowerCase().contains(searchQuery))
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("No matching stocks."));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _loadFilteredWatchlist();
                    });
                  },
                  child: ListView.builder(
  physics: const AlwaysScrollableScrollPhysics(),
  itemCount: filtered.length,
  itemBuilder: (context, index) {
    final stock = filtered[index];
    
    return Dismissible(
  key: Key(stock.symbol),
  direction: DismissDirection.startToEnd,
  background: Container(
    color: Colors.red,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 20),
    child: const Icon(Icons.delete, color: Colors.white),
  ),
  confirmDismiss: (_) async {
    return true; 
  },
  onDismissed: (_) async {
  
    final currentList = await SharedPreferenceService.getStringListAsync(Stringkeys.watchlist) ?? [];
    if (currentList.contains(stock.symbol)) {
      currentList.remove(stock.symbol);
      await SharedPreferenceService.setStringList(Stringkeys.watchlist, currentList);
    }

   AppUtils.showSnackBar(context, 'remove from watchlist!', backgroundColor: Colors.red);


  },
  child: StockCard(stock: stock),
);

  },
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
