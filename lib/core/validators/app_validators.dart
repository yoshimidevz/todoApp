
class AppValidators {
  static String? todoTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    if (value.trim().length < 3) return 'Mínimo 3 caracteres';
    return null;
  }

  static String? dueDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    if (value.length < 10) return 'Data incompleta, formato DD/MM/AAAA';

    final parts = value.split('/');
    final day   = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year  = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return 'Data inválida';

    final date = DateTime.tryParse('$year-$month-$day');
    if (date == null) return 'Data inválida';

    if (date.isBefore(DateTime.now())) return 'Data inválida';
    return null;
  }
}