import 'package:flutter/material.dart';
import 'package:stocks/models/stocksmodel.dart';
import 'package:stocks/services/sharedpreference.dart';

class StockCard extends StatelessWidget {
  final StockModel stock;
  const StockCard({Key? key, required this.stock}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(
          stock.symbol,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(stock.sector),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${stock.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '${stock.change >= 0 ? '+' : ''}${stock.change.toStringAsFixed(2)}%',
              style: TextStyle(
                color: stock.change >= 0 ? Colors.green : Colors.red,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
