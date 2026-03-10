import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../providers/auth_provider.dart';

/// Splash Screen
/// 
/// Displays app logo and checks authentication status.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    try {
      // Show splash for minimum 2 seconds for better UX
      await Future.delayed(const Duration(seconds: 2));
      
      // Check if still mounted
      if (!mounted) return;
      
      debugPrint('🚀 Splash: Starting navigation...');
      
      // Wait for auth check to complete with timeout
      final authNotifier = ref.read(authProvider.notifier);
      int attempts = 0;
      while (ref.read(authProvider).isLoading && attempts < 5) {
        await Future.delayed(const Duration(milliseconds: 200));
        attempts++;
        debugPrint('⏳ Splash: Waiting for auth check... ($attempts/5)');
      }
      
      if (!mounted) return;
      
      // Check authentication status
      final authState = ref.read(authProvider);
      
      // Debug log
      debugPrint('🔍 Splash: Auth Status - ${authState.isAuthenticated}');
      debugPrint('🔍 Splash: Loading - ${authState.isLoading}');
      debugPrint('🔍 Splash: User - ${authState.user?.name ?? "null"}');
      
      // Force navigation based on auth status
      if (authState.isAuthenticated && authState.user != null) {
        debugPrint('✅ Navigating to /home');
        if (mounted) context.go('/home');
      } else {
        debugPrint('✅ Navigating to /login');
        if (mounted) context.go('/login');
      }
    } catch (e, stackTrace) {
      // If anything fails, navigate to login as fallback
      debugPrint('❌ Splash error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.gavel_rounded,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                'BidMaster',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Real-Time Auction Marketplace',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
