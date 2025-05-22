import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/utils/Routes/routes.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

@override
Widget build(BuildContext context, WidgetRef ref) {
  final router = ref.watch(goRouterProvider);

  return MaterialApp.router(
    routerConfig: router,
    debugShowCheckedModeBanner: false,
    title: 'Stocks App',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white, // Default background
      primaryColor: Colors.blue.shade100,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.blue.shade100,
        background: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade100,
          foregroundColor: Colors.black,
        ),
      ),
    ),
  );
}

}



