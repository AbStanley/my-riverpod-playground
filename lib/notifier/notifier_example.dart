import 'package:flutter_riverpod/flutter_riverpod.dart';

// First, let's create a simple provider for a user's name
final userNameProvider = Provider<String>((ref) => 'John Doe');

// Now, let's create a TodoNotifier
class TodoNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    // Using another provider's value in the build method
    final userName = ref.watch(userNameProvider);
    return ['${userName}\'s first todo'];
  }

  void addTodo(String todo) {
    state = [...state, todo];
  }
}

// Provider for TodoNotifier
final todoProvider = NotifierProvider<TodoNotifier, List<String>>(() {
  return TodoNotifier();
});

// Now, let's create a ComplexNotifier that uses both providers
class ComplexNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    // Using another provider's value to populate the initial state
    final userName = ref.watch(userNameProvider);
    final todos = ref.watch(todoProvider);

    return {
      'userName': userName,
      'todoCount': todos.length,
    };
  }

  void addTodoAndUpdateCount(String todo) {
    // Accessing another provider's notifier to call its method
    ref.read(todoProvider.notifier).addTodo(todo);

    // Updating own state
    state = {
      ...state,
      'todoCount': state['todoCount'] + 1,
    };
  }
}

// Provider for ComplexNotifier
final complexProvider = NotifierProvider<ComplexNotifier, Map<String, dynamic>>(() {
  return ComplexNotifier();
});

// Example usage in a widget

