// First, let's create a simple provider for a user's name
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userNameProvider = Provider<String>((ref) => 'John Doe');

class TodoNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    // Using another provider's value in the build method
    final userName = ref.watch(userNameProvider);
    return ['$userName\'s first todo'];
  }

  void addTodo(String todo) {
    state = [...state, todo];
  }
}

// Provider for TodoNotifier
final todoProvider = NotifierProvider<TodoNotifier, List<String>>(() {
  return TodoNotifier();
});

// ComplexNotifier that uses both providers
class ComplexNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    // NOTE: Watch the providers you want to use in the build method
    final userName = ref.watch(userNameProvider);
    final todos = ref.watch(todoProvider);

    return {
      'userName': userName,
      'todoCount': todos.length,
    };
  }

  void addTodoAndUpdateCount(String todo) {
    // NOTE: Reading another provider's notifier to call its methods
    ref.read(todoProvider.notifier).addTodo(todo);

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
