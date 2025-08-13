import 'package:flutter/material.dart';
import 'package:flutter_todo_list/model/todo.dart';
import 'package:flutter_todo_list/repositories/todo_repository.dart';
import 'package:flutter_todo_list/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  String? todoInputErrorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((list) {
      setState(() {
        todos = list;
      });
    });
  }

  void addTodo() {
    String text = todoController.text;

    if (text.isEmpty) {
      setState(() {
        todoInputErrorText = 'O título não pode ser vazio.';
      });

      return;
    }

    setState(() {
      Todo newTodo = Todo(title: text, dateTime: DateTime.now());

      todos.add(newTodo);
    });

    todoController.clear();

    todoRepository.saveTodoList(todos);
  }

  void undoDeleteTodo(int index, Todo todo) {
    setState(() {
      todos.insert(index, todo);
    });

    todoRepository.saveTodoList(todos);
  }

  void onTodoDelete(Todo todo) {
    final todoIndex = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    todoRepository.saveTodoList(todos);

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

  void clearTodoInputErrorText() {
    if (todoInputErrorText == null) return;

    setState(() {
      todoInputErrorText = null;
    });
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
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma Tarefa',
                          errorText: todoInputErrorText,
                        ),
                        controller: todoController,
                        onChanged: (_) => clearTodoInputErrorText(),
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
                      ? Center(child: Text('Nada para fazer por enquanto'))
                      : ListView.builder(
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            return TodoListItem(
                              todo: todos[index],
                              onDelete: onTodoDelete,
                            );
                          },
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
