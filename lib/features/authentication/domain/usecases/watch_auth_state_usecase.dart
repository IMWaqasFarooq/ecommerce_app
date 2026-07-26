import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  WatchAuthStateUseCase(this._repository);
  final AuthRepository _repository;

  Stream<AppUser?> call() => _repository.watchAuthState();
}
