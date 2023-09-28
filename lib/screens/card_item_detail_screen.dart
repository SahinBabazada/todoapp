import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/card_item_model.dart';
import '../providers/todo_provider.dart';
import 'add_task_screen.dart';

class CardItemDetailScreen extends ConsumerWidget {
  final CardItemModel cardItem;
  const CardItemDetailScreen({super.key, required this.cardItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var todoProv = ref.watch(todoProvider);
    final todoAction = ref.watch(todoProvider.notifier);

    var todos = todoProv[cardItem.cardTitle];
    int unCompletedTaskCount = (todos == null)
        ? 0
        : todos
            .where((element) => element.isCompleted == false)
            .toList()
            .length;
    int completedTaskCount = (todos == null)
        ? 0
        : todos.where((element) => element.isCompleted == true).toList().length;

    double perc =
        (completedTaskCount / (completedTaskCount + unCompletedTaskCount));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Hero(
        tag: cardItem.cardTitle,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 1, color: Colors.black38)),
                child: Icon(cardItem.icon, size: 24.0, color: Colors.blue),
              ),
              const SizedBox(height: 20.0),
              Text("$unCompletedTaskCount Tasks",
                  style: const TextStyle(fontSize: 18.0, color: Colors.grey)),
              const SizedBox(height: 10.0),
              Text(cardItem.cardTitle, style: const TextStyle(fontSize: 32.0)),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                        value: ((perc.isInfinite || perc.isNaN) ? 0 : perc)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                      '${((perc.isInfinite || perc.isNaN) ? 0 : perc * 100).toStringAsFixed(0)} %')
                ],
              ),
              const SizedBox(height: 40.0),
              (todos != null)
                  ? Expanded(
                      child: ListView.separated(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              color: Colors.red,
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              todoAction.removeTodo(
                                  cardItem.cardTitle, todos[index].id);
                            },
                            child: Material(
                              color: Colors.white,
                              child: ListTile(
                                leading: Checkbox(
                                  value: todos[index].isCompleted,
                                  onChanged: (bool? value) {
                                    todoAction.toggleTodoCompletion(
                                        cardItem.cardTitle, todos[index].id);
                                  },
                                ),
                                title: Text(todos[index].description),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: Divider(thickness: 0.2, color: Colors.black),
                          );
                        },
                      ),
                    )
                  : const Text("You have no task"),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(_fadeRoute(AddTaskScreen(category: cardItem.cardTitle)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Route _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: animation.drive(Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInBack))),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 700),
    );
  }
}
