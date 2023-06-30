import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class SignUpUseCase {
  Future<void> execute(BuildContext context, String email, String name,
      String secondName, String password, String confirmPassword, File? image);
}

// Huvver xapi es hinch tijera ara, huva vavshe hnaral en clean architecturyyyy

// Bayc de huncy Maratna asum - Djvarutyuny ta taza hnaravorutyuna araj qinali