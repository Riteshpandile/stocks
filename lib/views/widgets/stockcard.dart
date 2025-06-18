import 'package:flutter/material.dart';
import 'package:stocks/models/stocksmodel.dart';
import 'package:stocks/services/sharedpreference.dart';

class StockCard extends StatelessWidget {
  final StockModel stock;
  const StockCard({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        color: Colors.white,
       shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue.shade100, width: 1.0),
       borderRadius: BorderRadius.circular(12),),
       elevation: 2,
        child: ListTile(
          title: Text("${stock.symbol}"),
          subtitle: Text("${stock.sector}"),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("\$ ${stock.price}", style: TextStyle(fontSize: 16)),
        
              Text(
                " ${stock.change >= 0 ? '+' : ''}${stock.change.toStringAsFixed(2)}%",
                style: TextStyle(fontSize: 16, color: stock.change >= 0 ? Colors.green : Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
