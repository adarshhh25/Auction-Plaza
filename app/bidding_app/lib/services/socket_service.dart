import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../core/config/api_config.dart';
import 'secure_storage_service.dart';

/// Socket Service for real-time bidding
/// 
/// Manages Socket.IO connections for live auction updates.
class SocketService {
  IO.Socket? _socket;
  final SecureStorageService _storage = SecureStorageService();

  // Singleton pattern
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  /// Connect to Socket.IO server
  Future<void> connect() async {
    if (_socket != null && _socket!.connected) {
      return; // Already connected
    }

    final accessToken = await _storage.getAccessToken();

    _socket = IO.io(
      ApiConfig.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({
            'Authorization': 'Bearer $accessToken',
          })
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Socket connected: ${_socket!.id}');
    });

    _socket!.onDisconnect((_) {
      print('Socket disconnected');
    });

    _socket!.onError((error) {
      print('Socket error: $error');
    });
  }

  /// Disconnect from Socket.IO server
  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  /// Join auction room
  void joinAuction(String auctionId) {
    _socket?.emit('joinAuction', {'auctionId': auctionId});
    print('Joined auction: $auctionId');
  }

  /// Leave auction room
  void leaveAuction(String auctionId) {
    _socket?.emit('leaveAuction', {'auctionId': auctionId});
    print('Left auction: $auctionId');
  }

  /// Listen for bid updates
  void onBidUpdate(Function(dynamic) callback) {
    _socket?.on(ApiConfig.bidUpdateEvent, callback);
  }

  /// Listen for auction extended events
  void onAuctionExtended(Function(dynamic) callback) {
    _socket?.on(ApiConfig.auctionExtendedEvent, callback);
  }

  /// Listen for auction closed events
  void onAuctionClosed(Function(dynamic) callback) {
    _socket?.on(ApiConfig.auctionClosedEvent, callback);
  }

  /// Remove all listeners
  void removeAllListeners() {
    _socket?.off(ApiConfig.bidUpdateEvent);
    _socket?.off(ApiConfig.auctionExtendedEvent);
    _socket?.off(ApiConfig.auctionClosedEvent);
  }

  /// Check if socket is connected
  bool get isConnected => _socket?.connected ?? false;
}
