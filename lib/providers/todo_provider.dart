import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../services/todo_notifier.dart';

final todoProvider =
    StateNotifierProvider<TodoNotifier, Map<String, List<Todo>>>(
  (ref) => TodoNotifier(),
);
