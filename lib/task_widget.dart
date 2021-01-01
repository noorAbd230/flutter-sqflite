import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sqflite/db_helper.dart';
import 'package:flutter_app_sqflite/task_model.dart';



class TaskWidget extends StatefulWidget {

   List<Task> list;
  int count=0;
  Function function;

  TaskWidget({
    this.list,this.function
  });


  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return(widget.list== null || widget.list.isEmpty)
        ?
    Center(child: Text("NO TASKS ADDED"))
     : ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          return
            Card(
              color: Colors.grey[100],
              margin: EdgeInsets.all(10),
              child:
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (param) {
                            return AlertDialog(
                              title: Text('Alert'),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              content: Text(
                                  'You Will Delete A task, are you sure?'),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: GestureDetector(
                                    child: Text('OK', style: TextStyle(
                                        color: Colors.blueAccent),),
                                    onTap: () {
                                      setState(() {
                                        deleteTask(
                                            context, widget.list[index]);
                                        Navigator.pop(context);
                                        Future taskList = widget.function();
                                        taskList.then((value) {
                                          setState(() {
                                            widget.list = value;
                                            widget.list.length =
                                                value.length;
                                          });
                                        });
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: GestureDetector(
                                    child: Text('NO', style: TextStyle(
                                        color: Colors.blueAccent),),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },

                                  ),
                                ),
                              ],
                            );
                          }
                      );
                    },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),

                    ),
                    Text(widget.list[index].taskName),
                    Checkbox(value: widget.list[index].isComplete,
                      onChanged: (val) {
                        widget.list[index].isComplete =
                        !widget.list[index].isComplete;
                        setState(() {
                          DBHelper.dbHelper.updateTask(Task(
                              id: widget.list[index].id,
                              taskName: widget.list[index].taskName,
                              isComplete: val));
                          Future taskList = widget.function();
                          taskList.then((value) {
                            setState(() {
                              widget.list = value;
                              widget.list.length = value.length;
                            });
                          });
                        });
                        // if(widget.list.length!=0){

                        // }

                      },
                    )
                  ],
                ),
              ),


            );
        });
  }}

void deleteTask(BuildContext context, Task task) async{

   int x = await DBHelper.dbHelper.deleteTask(task.id);

   if(x!=0){
    final snakBar = SnackBar(content: Text('Task Deleted successfully'),);
    Scaffold.of(context).showSnackBar(snakBar);
   }

}