import 'package:flutter/material.dart';
import 'package:flutter_todo_list/model/todo.dart';
import 'package:flutter_todo_list/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> todos = [];

  final TextEditingController todoController = TextEditingController();

  void addTodo() {
    setState(() {
      Todo newTodo = Todo(title: todoController.text, dateTime: DateTime.now());

      todos.add(newTodo);
    });

    todoController.clear();
  }

  void undoDeleteTodo(int index, Todo todo) {
    setState(() {
      todos.insert(index, todo);
    });
  }

  void onTodoDelete(Todo todo) {
    final todoIndex = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} removida com sucesso',
          style: TextStyle(color: Color(0xff060708)),
        ),
        backgroundColor: Colors.grey[200],
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () => undoDeleteTodo(todoIndex, todo),
          textColor: Color(0xff00d7f3),
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });

    Navigator.of(context).pop();
  }

  void showAlertDeleteAllTodos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo?'),
        content: Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: deleteAllTodos,
            child: Text('Apagar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma Tarefa',
                        ),
                        controller: todoController,
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: addTodo,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(4),
                        ),
                        backgroundColor: Color(0xff00b7f3),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Icon(Icons.add, size: 30, color: Colors.white),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Expanded(
                  child: todos.isEmpty
                      ? Text('Nada para fazer por enquanto')
                      : Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              for (Todo todo in todos)
                                TodoListItem(
                                  todo: todo,
                                  onDelete: onTodoDelete,
                                ),
                            ],
                          ),
                        ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${todos.length} tarefas pendendes',
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: todos.isEmpty ? null : showAlertDeleteAllTodos,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(4),
                        ),
                        backgroundColor: Color(0xff00b7f3),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Text(
                        'Limpar tudo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
