import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/app_user.dart';
import 'auth_providers.dart';

part 'auth_state_provider.g.dart';

// Passive read of who's signed in - updates automatically, no manual push needed from AuthController.
@riverpod
class AuthState extends _$AuthState {
  @override
  Stream<AppUser?> build() {
    return ref.watch(watchAuthStateUseCaseProvider)();
  }
}
