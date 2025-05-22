import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stocks/utils/Routes/routes_path.dart';
import 'package:stocks/views/screens/homepage.dart';
import 'package:stocks/views/screens/login/loginpage.dart';
import 'package:stocks/views/screens/watchlist/watchlist.dart';


final isLoggedInProvider = StateProvider<bool>((ref) => false);

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.login,
    routes: [
      GoRoute(
        path: RoutePaths.login,
        name: 'login',
        builder: (context, state) => Loginpage(),
      ),
      GoRoute(
        path: RoutePaths.home, 
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    

      GoRoute(
        path: RoutePaths.watchlist,
        name: 'watchlist',
        builder: (context, state) => const WatchlistPage(),
      ),
    ],

    errorBuilder: 
        (context, state) =>
            Scaffold(body: Center(child: Text('Page Not Found'))),
  );
});
