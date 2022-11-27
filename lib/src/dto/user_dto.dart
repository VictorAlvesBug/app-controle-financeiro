import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../enums/tipo_transacao_enum.dart';

class UserDTO {
  UserDTO({
    this.email = '',
    this.senha = '',
});

  final String email;
  final String senha;
}