import 'package:chat_app/data/repository/auth_repository_impl.dart';
import 'package:chat_app/domain/usecases/auth/signout.dart';

class SignOutUseCaseImpl extends SignOutUseCase {
  SignOutUseCaseImpl(this.authRepositoryImpl);
  final AuthRepositoryImpl authRepositoryImpl;

  @override
  Future<void> execute() async {
    await authRepositoryImpl.signOut();
  }
}
