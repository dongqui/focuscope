import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'sign_in_with_google.dart'; // NoParams 재사용

@injectable
class SignInWithApple {
  final AuthRepository repository;

  SignInWithApple(this.repository);

  Future<Either<Failure, User>> call(NoParams params) {
    return repository.signInWithApple();
  }
}
