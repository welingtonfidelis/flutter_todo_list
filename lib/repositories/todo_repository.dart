import 'dart:convert';

import 'package:flutter_todo_list/model/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

const TODO_LIST_KEY = 'todo_list';

class TodoRepository {
  // TodoRepository() {
  //   SharedPreferences.getInstance().then(
  //     (instance) => sharedPreferences = instance,
  //   );
  // }

  late SharedPreferences sharedPreferences;

  void saveTodoList(List<Todo> todos) {
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(TODO_LIST_KEY, jsonString);
  }

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =
        sharedPreferences.getString(TODO_LIST_KEY) ?? '[]';

    final List jsonDecoded = json.decode(jsonString);

    return jsonDecoded.map((item) => Todo.fromJson(item)).toList();
  }
}
