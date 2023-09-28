import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';

class TodoNotifier extends StateNotifier<Map<String, List<Todo>>> {
  TodoNotifier() : super({});

  void addTodo(String category, Todo todo) {
    state[category] = [...(state[category] ?? []), todo];
    state = {...state};
  }

  void removeTodo(String category, String todoId) {
    if (state[category] == null) return;

    state[category]!.removeWhere((todo) => todo.id == todoId);
    if (state[category]!.isEmpty) {
      state.remove(category);
    }
    state = {...state};
  }

  void toggleTodoCompletion(String category, String todoId) {
    if (state[category] == null) return;
    var updatedTodos = state[category]!.map((todo) {
      if (todo.id == todoId) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();

    state[category] = updatedTodos;
    state = {...state};
  }

  List<Todo> getTodosByCategory(String category) {
    return state[category] ?? [];
  }

  int completedTodo(String category) {
    List<Todo> todos = state[category] ?? [];
    return todos
        .where((element) => element.isCompleted == true)
        .toList()
        .length;
  }

  int unCompletedTodo(String category) {
    List<Todo> todos = state[category] ?? [];
    return todos
        .where((element) => element.isCompleted == false)
        .toList()
        .length;
  }

  double taskCompletion(String category) {
    List<Todo> todos = state[category] ?? [];
    return (completedTodo(category) / todos.length);
  }
}
