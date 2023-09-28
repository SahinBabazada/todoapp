import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/todo.dart';
import '../providers/todo_provider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  final String category;
  const AddTaskScreen({super.key, required this.category});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final todoProv = ref.watch(todoProvider.notifier);
    const uuid = Uuid();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'New Task',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What tasks are you planning to perform?"),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(90, 137, 230, 1),
          isExtended: true,
          onPressed: () {
            todoProv.addTodo(
              widget.category,
              Todo(
                id: uuid.v1(),
                isCompleted: false,
                description: _descriptionController.text,
              ),
            );
            Navigator.pop(context);
          },
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
