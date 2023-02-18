import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApps()));
}

const list = [Todo(id: '1', description: 'description', completed: false)];

final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});

class MyApps extends ConsumerWidget {
  const MyApps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('To Do'),
          actions: [
            GestureDetector(
              onTap: () {
                int ss = 1;
                ss += 1;
                ref.watch(todosProvider.notifier).addTodo(Todo(
                    id: ss.toString(),
                    description: 'Lots of Work',
                    completed: false));
              },
              child: const Icon(Icons.abc),
            )
          ],
        ),
        body: const TodoListView(),
      ),
    );
  }
}

class TodoListView extends ConsumerWidget {
  const TodoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todosProvider);

    return ListView(
      children: [
        for (final todo in todos)
          CheckboxListTile(
            value: todo.completed,
            onChanged: (value) =>
                ref.read(todosProvider.notifier).toggle(todo.id),
            title: Text(todo.description),
          ),
      ],
    );
  }
}

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super(list);

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void removeTodo(String todoId) {
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  void toggle(String todoId) {
    state = [
      for (final todo in state)
        if (todo.id == todoId)
          todo.copyWith(completed: !todo.completed)
        else
          todo,
    ];
  }
}

@immutable
class Todo {
  const Todo(
      {required this.id, required this.description, required this.completed});

  final String id;
  final String description;
  final bool completed;

  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}
