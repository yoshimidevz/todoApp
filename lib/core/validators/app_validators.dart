import '../messages/app_messages.dart';

class AppValidators {
  static String? todoTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    if (value.trim().length < 3) return 'Mínimo 3 caracteres';
    return null;
  }
}