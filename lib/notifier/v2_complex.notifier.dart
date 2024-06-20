import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo_notifier.provider.dart';

class V2ComplexNotifier extends Notifier<Map<String, dynamic>> {
  // Add final variables here
  final String appVersion;
  final int maxTodos;

  // Constructor to initialize final variables
  V2ComplexNotifier({
    required this.appVersion,
    this.maxTodos = 10,
  });

  @override
  Map<String, dynamic> build() {
    final userName = ref.watch(userNameProvider);
    final todos = ref.watch(todoProvider);

    return {
      'userName': userName,
      'todoCount': todos.length,
      'appVersion': appVersion,
      'maxTodos': maxTodos,
    };
  }

  void addTodoAndUpdateCount(String todo) {
    final currentTodos = ref.read(todoProvider);
    if (currentTodos.length < maxTodos) {
      ref.read(todoProvider.notifier).addTodo(todo);

      state = {
        ...state,
        'todoCount': state['todoCount'] + 1,
      };
    }
  }
}

final v2ComplexProvider = NotifierProvider<V2ComplexNotifier, Map<String, dynamic>>(() {
  return V2ComplexNotifier(
    appVersion: '1.0.0',
    maxTodos: 15,
  );
});
