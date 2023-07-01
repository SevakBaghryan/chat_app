import 'package:chat_app/data/repository/profile_repository_impl.dart';
import 'package:chat_app/domain/usecases/profile/edit_secondname.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditSecondNameUseCaseImpl extends EditSecondNameUseCase {
  EditSecondNameUseCaseImpl(this.profileRepositoryImpl);
  final ProfileRepositoryImpl profileRepositoryImpl;

  @override
  void execute(String newSecondName, BuildContext context) {
    profileRepositoryImpl.editProfileSecondName(newSecondName, context);
  }
}
