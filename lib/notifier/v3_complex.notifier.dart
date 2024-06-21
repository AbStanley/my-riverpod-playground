import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo_notifier.provider.dart';

// Assume we have a provider for maxTodos
final maxTodosProvider = Provider<int>((ref) => 15);

class V3ComplexNotifier extends Notifier<Map<String, dynamic>> {
  String get initialUserName => ref.read(userNameProvider);
  int get maxTodos => ref.read(maxTodosProvider);

  @override
  Map<String, dynamic> build() {
    // We still watch todoProvider as we want to react to its changes
    final todos = ref.watch(todoProvider);

    return {
      'initialUserName': initialUserName,
      'currentUserName': initialUserName,
      'todoCount': todos.length,
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

  void updateCurrentUserName() {
    // Read the current userName without watching it
    final currentUserName = ref.read(userNameProvider);
    state = {
      ...state,
      'currentUserName': currentUserName,
    };
  }
}

// Update the provider to pass the required parameters
final v3ComplexProvider = NotifierProvider<V3ComplexNotifier, Map<String, dynamic>>(() {
  return V3ComplexNotifier();
});
