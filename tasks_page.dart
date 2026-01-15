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

  String _formatDateTime(DateTime dateTime) {
    // Get day of week
    List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    String dayOfWeek = days[dateTime.weekday - 1];

    // Get hours and minutes with leading zeros
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return '$dayOfWeek $hour:$minute';
  }

  Widget _todoList(){
    List tasks = _box!.values.toList();
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index){
          var task = Task.fromMap(tasks[index]);

          // Format the timestamp to show day of week and time
          String formattedDate = _formatDateTime(task.timeStamp);

          return ListTile(
            title: Text(task.todo),
            subtitle: Text(formattedDate),
            trailing: task.done ? Icon(Icons.check_box_outlined,
              color: Colors.green,
            ):
            Icon(Icons.check_box_outline_blank),
            onTap: (){
              task.done = !task.done;
              _box!.putAt(index, task.toMap());

              setState(() {});
            },

            onLongPress: (){
              _box!.deleteAt(index);
              setState(() {});
            },
          );
        });
  }


  Widget _tasksWidget(){
    return FutureBuilder( future: Hive.openBox("Tasks"),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            _box = snapshot.data;
            return _todoList();
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
