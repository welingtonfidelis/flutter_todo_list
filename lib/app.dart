import 'package:flutter/material.dart';
import 'package:flutter_todo_list/pages/todo_list_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TodoListPage(), debugShowCheckedModeBanner: false);
  }
}
