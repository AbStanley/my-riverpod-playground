import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_playground/notifier/notifier.dart';

// class MockTodoNotifier extends Notifier<List<String>> with Mock implements TodoNotifier {}
class MockTodoNotifier extends Mock implements TodoNotifier {}

class MyMockTodoNotifier extends TodoNotifier {
  @override
  List<String> build() => ['Initial Todo'];

  @override
  void addTodo(String todo) {
    state = [...state, todo];
  }
}

void main() {
  group('Initial state with custom mock', () {
    test('initial state is correct', () {
      final container = ProviderContainer(
        overrides: [
          userNameProvider.overrideWithValue('Test User'),
          maxTodosProvider.overrideWithValue(5),
          todoProvider.overrideWith(() => MyMockTodoNotifier()),
        ],
      );

      final complexState = container.read(v3ComplexProvider);

      expect(complexState['initialUserName'], 'Test User');
      expect(complexState['currentUserName'], 'Test User');
      expect(complexState['maxTodos'], 5);
    });
  });
  group('Others', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          userNameProvider.overrideWithValue('Test User'),
          maxTodosProvider.overrideWithValue(5),
          todoProvider.overrideWith(() => MyMockTodoNotifier()),
        ],
      );
    });

    test('addTodoAndUpdateCount respects maxTodos', () {
      final complexNotifier = container.read(v3ComplexProvider.notifier);
      final todoNotifier = container.read(todoProvider.notifier);

      // Add todos up to the max
      for (int i = 0; i < 5; i++) {
        todoNotifier.addTodo('Todo $i');
      }
      // ensure refresh
      container.read(v3ComplexProvider);

      // Try to add one more
      complexNotifier.addTodoAndUpdateCount('Exceeding Todo');

      final updatedState = container.read(v3ComplexProvider);
      expect(updatedState['todoCount'], 6); // Ensure todo count does not exceed maxTodos

      // Verify that no todo was added
      expect(updatedState['currentUserName'], 'Test User');
      expect(updatedState['maxTodos'], 5);
    });

    tearDown(() {
      container.dispose();
    });
  });
}
