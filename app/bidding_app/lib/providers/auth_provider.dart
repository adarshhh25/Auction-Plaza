import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Authentication State
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Auth State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService = AuthService();

  AuthNotifier() : super(AuthState()) {
    _checkAuthStatus();
  }

  /// Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    final isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      final user = await _authService.getCurrentUser();
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Login
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _authService.login(
      email: email,
      password: password,
    );

    if (response.success && response.data != null) {
      state = state.copyWith(
        user: response.data!.user,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(
        error: response.error?.message ?? 'Login failed',
        isLoading: false,
      );
      return false;
    }
  }

  /// Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _authService.register(
      name: name,
      email: email,
      password: password,
      role: role,
      phone: phone,
    );

    if (response.success && response.data != null) {
      state = state.copyWith(
        user: response.data!.user,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(
        error: response.error?.message ?? 'Registration failed',
        isLoading: false,
      );
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _authService.logout();
    state = AuthState();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Convenience providers
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
