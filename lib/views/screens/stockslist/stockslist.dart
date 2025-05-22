import 'dart:async';

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

class Stocklist extends ConsumerStatefulWidget {
  const Stocklist({super.key});

  @override
  ConsumerState<Stocklist> createState() => _StocklistState();
}

class _StocklistState extends ConsumerState<Stocklist> {
  final TextEditingController _searchController = TextEditingController();
  List<StockModel> filteredStocks = [];
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();

    _refreshTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      ref.refresh(stockListProvider);
    });

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredStocks = ref
            .watch(stockListProvider)
            .maybeWhen(
              data:
                  (stocks) =>
                      stocks
                          .where(
                            (stock) =>
                                stock.symbol.toLowerCase().contains(query),
                          )
                          .toList(),
              orElse: () => [],
            );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final stockListAsyncValue = ref.watch(stockListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stock list')),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: AppStyles.inputDecoration(label: "Search ", prefixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(stockListProvider);
                await Future.delayed(const Duration(seconds: 1));
              },
              child: stockListAsyncValue.when(
                data: (stocks) {
                  final query = _searchController.text.toLowerCase();
                  filteredStocks =
                      query.isEmpty
                          ? stocks
                          : stocks
                              .where(
                                (stock) =>
                                    stock.symbol.toLowerCase().contains(query),
                              )
                              .toList();

                  if (filteredStocks.isEmpty) {
                    return const Center(child: Text('No stocks found.'));
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredStocks.length,
                    itemBuilder: (context, index) {
                      final stock = filteredStocks[index];
                  
                      return Consumer(
                        builder: (context, ref, _) {
                          return Dismissible(
                            key: Key(stock.symbol),
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              color: Colors.green,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (_) async {
                              final list =
                                  await SharedPreferenceService.getStringListAsync(
                                    Stringkeys.watchlist,
                                  ) ??
                                  [];
                  
                              if (!list.contains(stock.symbol)) {
                                list.add(stock.symbol);
                                await SharedPreferenceService.setStringList(
                                  Stringkeys.watchlist,
                                  list,
                                );
                  
                             
                  
                                AppUtils.showSnackBar(
                                  context,
                                  "${stock.symbol} added to watchlist",
                                );
                              }else {
                                 AppUtils.showSnackBar(
                                  context,
                                  "${stock.symbol} already added",
                                  backgroundColor: Colors.orange
                                );
                              }
                  
                              return false;
                            },
                            child:
  //                            Card(
  //   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //   elevation: 3,
  //   child: Padding(
  //     padding: const EdgeInsets.all(12.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         ListTile(
  //           contentPadding: EdgeInsets.zero,
  //           title: Text(stock.symbol, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //           subtitle: Text(stock.sector),
  //         ),
  //         const SizedBox(height: 8),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('Sector: ${stock.sector}'),
  //             Text('Price: \$${stock.price.toStringAsFixed(2)}'),
  //             Text(
  //               'Change: ${stock.change >= 0 ? '+' : ''}${stock.change.toStringAsFixed(2)}%',
  //               style: TextStyle(
  //                 color: stock.change >= 0 ? Colors.green : Colors.red,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   ),
  // ),
                            
                        StockCard(stock: stock,),    
                      
                          );
                        },
                      );
                    },
                  );
                
                
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, _) =>
                        Center(child: Text('Error loading stocks: $error')),
              ),

              
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}
