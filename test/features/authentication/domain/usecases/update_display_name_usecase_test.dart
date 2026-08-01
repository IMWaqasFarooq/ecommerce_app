import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/features/authentication/domain/entities/app_user.dart';
import 'package:ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app/features/authentication/domain/usecases/update_display_name_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late UpdateDisplayNameUseCase useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = UpdateDisplayNameUseCase(repository);
  });

  const user = AppUser(id: '1', email: 'demo@velora.dev', displayName: 'New Name');

  test('delegates to the repository with the new display name', () async {
    when(() => repository.updateDisplayName('New Name')).thenAnswer((_) async => const Right(user));

    final result = await useCase('New Name');

    expect(result, const Right<Failure, AppUser>(user));
    verify(() => repository.updateDisplayName('New Name')).called(1);
  });

  test('propagates a failure from the repository', () async {
    when(
      () => repository.updateDisplayName(any()),
    ).thenAnswer((_) async => const Left(Failure.unauthorized()));

    final result = await useCase('New Name');

    expect(result, const Left<Failure, AppUser>(Failure.unauthorized()));
  });
}
