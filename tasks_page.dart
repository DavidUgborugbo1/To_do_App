import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/model/task.dart';
class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  double? _deviceHeight, _deviceWidth;
  String? content;
  Box? _box;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight! * 0.1,
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text("Daily Planner",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: _tasksWidget(),
        floatingActionButton: FloatingActionButton(
    onPressed: displayTaskPop,
        child: Icon(Icons.add),
    ),

    );
  }

  Widget _todoList(){
    return ListView.builder(itemBuilder: (BuildContext context, int index){

      return ListTile(
        title: Text("Workout"),
        subtitle: Text(DateTime.now().toString()),
        trailing: Icon(Icons.check_box_outline_blank),
      );
    });
  }
  

  Widget _tasksWidget(){
    return FutureBuilder( future: null,
        builder: (BuildContext context, AsyncSnapshot snapshot){
      if(snapshot.hasData){
        _box = snapshot.data;
        return Center();
      }else{
        return Center(child: const CircularProgressIndicator());
      }
    });
  }


  void displayTaskPop(){
    showDialog(
        context: context, builder:(BuildContext _context){
      return AlertDialog(
        title: const Text("Add a Task"),
        content: TextField(
          onSubmitted: (value){

            if(content != null){
              var task = Task(
                  todo: content!,
                  timeStamp: DateTime.now(),
                  done: false);
              _box!.add(task.toMap());

              setState(() {
                print(value);
                Navigator.pop(context);
              });
            }

          },

          onChanged: (value){
            setState(() {
              content = value;
              print(value);
            });
          },
        ),
      );
    });
  }
}
