import 'package:chat_app/data/repository/profile_repository_impl.dart';
import 'package:chat_app/domain/usecases/profile/edit_name.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditNameUsecaseImpl extends EditNameUsecase {
  EditNameUsecaseImpl(this.profileRepositoryImpl);
  final ProfileRepositoryImpl profileRepositoryImpl;

  @override
  void execute(String newName, BuildContext context) {
    profileRepositoryImpl.editProfileName(newName, context);
  }
}
