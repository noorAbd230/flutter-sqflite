import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sqflite/db_helper.dart';
import 'package:flutter_app_sqflite/task_model.dart';




class NewTask extends StatefulWidget {

  Function function;

  NewTask(this.function);


  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  bool isComplete=false;

  String taskName;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(border:OutlineInputBorder(borderRadius: BorderRadius.circular(20)),),
              onChanged: (val){
            this.taskName=val;
            },
            ),
            Checkbox(value: isComplete ,onChanged: (val){
              isComplete=val;
              setState(() {});
            },),
            RaisedButton(onPressed: (){
             // taskList.add(Task(taskName,isComplete));
              setState(() {
                DBHelper.dbHelper.insertNewTask(Task(taskName: taskName,isComplete: isComplete));
                Navigator.pop(context);
                widget.function();
              });

            },
              child: Text('Add New Task'),)
          ],
        ),
      ),
    );
  }
}
