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

    final dayStr   = day.toString().padLeft(2, '0');
    final monthStr = month.toString().padLeft(2, '0');

    final date = DateTime.tryParse('$year-$monthStr-$dayStr');
    if (date == null) return 'Data inválida';

    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (date.isBefore(today)) return 'Data no passado';

    return null;
  }

  static String? existingTodo(String? value, String category, List<Map<String, String>> todos) {
    if (value == null || value.trim().isEmpty) return null;
    final exists = todos.any((t) =>
      t['title'] == value.trim() && t['category'] == category
    );
    if (exists) return 'Já existe uma tarefa com esse título nessa categoria';
    return null;
  }
}