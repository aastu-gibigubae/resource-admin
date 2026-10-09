import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/secure_storage.dart';

enum SplashStatus { loading, authenticated, unauthenticated }

class SplashNotifier extends AsyncNotifier<SplashStatus> {
  @override
  Future<SplashStatus> build() async {
    // Minimum 2-second display
    await Future.delayed(const Duration(seconds: 2));
    final storage = ref.read(secureStorageProvider);
    final token = await storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      return SplashStatus.authenticated;
    }
    return SplashStatus.unauthenticated;
  }
}

final splashProvider = AsyncNotifierProvider<SplashNotifier, SplashStatus>(
  SplashNotifier.new,
);
