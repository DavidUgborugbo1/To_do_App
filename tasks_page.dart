import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  double? _deviceHeight, _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight! * 0.1,
        title: const Text("Welcome to my To Do App"),
      ),
      body: _tasksWidget(),
        floatingActionButton: FloatingActionButton(
    onPressed: displayTaskPop,
        child: Icon(Icons.add),
    ),

    );
  }


  Widget _tasksWidget(){
    return Container();
  }


  void displayTaskPop(){
    showDialog(
        context: context, builder:(BuildContext _context){
      return AlertDialog(
        title: const Text("Add a Task"),
        content: TextField(),
      );
    });
  }
}
