import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/authentication/presentation/providers/auth_state_provider.dart';
import '../providers/core_providers.dart';

part 'analytics_auth_observer.g.dart';

@Riverpod(keepAlive: true)
class AnalyticsAuthObserver extends _$AnalyticsAuthObserver {
  @override
  void build() {
    ref.listen(authStateProvider, (previous, next) {
      final user = next.value;
      ref.read(analyticsServiceProvider).setUserId(user?.id);
    });
  }
}
