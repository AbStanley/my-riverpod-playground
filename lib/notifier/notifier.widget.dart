// Example usage in a widget
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'notifier_example.dart';

class ComplexWidget extends ConsumerWidget {
  const ComplexWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complexState = ref.watch(complexProvider);
    final complexNotifier = ref.read(complexProvider.notifier);

    return Column(
      children: [
        Text('User: ${complexState['userName']}'),
        Text('Todo Count: ${complexState['todoCount']}'),
        ElevatedButton(
          onPressed: () => complexNotifier.addTodoAndUpdateCount('New Todo'),
          child: const Text('Add Todo'),
        ),
      ],
    );
  }
}
