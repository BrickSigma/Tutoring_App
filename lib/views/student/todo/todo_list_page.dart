import 'package:flutter/material.dart';
import 'package:tutoring_app/controllers/main_controller.dart';
import 'package:tutoring_app/controllers/tasks_controller.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  ToDoListPageState createState() => ToDoListPageState();
}

class ToDoListPageState extends State<ToDoListPage> {
  final TasksController controller =
      TasksController(MainController.instance.user.tasks);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Add a task',
                suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      controller.addTask(_textController.text);
                      _textController.clear();
                    }),
              ),
            ),
          ),
          ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    final task = controller.tasks[index];
                    return ListTile(
                      title: Text(
                        task['task'],
                        style: TextStyle(
                          decoration: task['completed']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      leading: Checkbox(
                        value: task['completed'],
                        onChanged: (_) =>
                            controller.toggleTaskCompletion(index),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
