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
