import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/auction/auction_detail_screen.dart';
import '../screens/bids/my_bids_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../screens/profile/profile_screen.dart';

/// GoRouter Refresh Notifier
/// 
/// Used to rebuild GoRouter when authentication state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(this._ref) {
    _ref.listen(authProvider, (previous, next) {
      // Notify router to rebuild when auth state changes
      if (previous?.isAuthenticated != next.isAuthenticated ||
          previous?.isLoading != next.isLoading) {
        print('🔄 Router refresh triggered - Auth changed');
        notifyListeners();
      }
    });
  }

  final Ref _ref;
}

/// App Router Configuration
/// 
/// Handles navigation and route guards with GoRouter.
final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshStream(ref);
  
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register');
      final isSplash = state.matchedLocation == '/splash';

      print('🧭 Router redirect: ${state.matchedLocation} | Auth: $isAuthenticated | Loading: $isLoading');

      // Show splash first - always allow
      if (isSplash) {
        return null;
      }

      // Don't redirect while auth is being checked (unless on splash)
      if (isLoading && !isSplash) {
        print('⏳ Auth still loading, staying on current route');
        return null;
      }

      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isAuthRoute) {
        print('🔒 Not authenticated, redirecting to /login');
        return '/login';
      }

      // If authenticated and trying to access auth routes
      if (isAuthenticated && isAuthRoute) {
        print('✅ Authenticated on auth route, redirecting to /home');
        return '/home';
      }

      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Home
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Auction Details
      GoRoute(
        path: '/auction/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AuctionDetailScreen(auctionId: id);
        },
      ),

      // My Bids
      GoRoute(
        path: '/my-bids',
        builder: (context, state) => const MyBidsScreen(),
      ),

      // Wallet
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletScreen(),
      ),

      // Profile
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
