import 'package:flutter/material.dart';
import 'package:flutter_app_sqflite/db_helper.dart';
import 'package:flutter_app_sqflite/new_task.dart';
import 'package:flutter_app_sqflite/task_model.dart';
import 'package:flutter_app_sqflite/task_widget.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

TabController tabController;
class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> with SingleTickerProviderStateMixin{


  List<Task> list = List<Task>();
  getAllTask() async{
    list = List<Task>();
    var taskList = await DBHelper.dbHelper.selectAllTask();

    taskList.forEach((element) {
      setState(() {
        list.add(
            Task(id: element[DBHelper.taskIdColumnName],taskName: element[DBHelper.taskNameColumnName],isComplete: element[DBHelper.taskIsCompleteColumnName]!=0));
      });
    });
  }
  @override
  void initState() {
    super.initState();
    tabController=TabController(length: 3,vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Todo'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            controller: tabController,
            tabs: [
              Tab(text: 'All Tasks',),
              Tab(text: 'Complete Tasks',),
              Tab(text: 'Incomplete Tasks',),
            ],isScrollable: true,),
        ),
        drawer: Drawer(),

        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                // physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  AllTasks(list: list,function: (){
                    getAllTask();
                  },),
                  CompleteTasks(),
                  IncompleteTasks()
                ],
              ),
            ),

          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,color: Colors.white,),
          backgroundColor: Colors.blueAccent,
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context){
              return NewTask(getAllTask);
            }));
          },
        ),

      );
  }
}

class AllTasks extends StatefulWidget {
  Function function;
  final List<Task> list;
  AllTasks({this.function,this.list});
  @override
  _AllTasksState createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  @override
  void initState() {
    super.initState();
    widget.function();
  }
  myFun(){
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context)  {
    return Container(
      child: TaskWidget(list: widget.list,function: widget.function,),
    );
  }
}

class CompleteTasks extends StatefulWidget {
  @override
  _CompleteTasksState createState() => _CompleteTasksState();
}

class _CompleteTasksState extends State<CompleteTasks> {

  List<Task> list = List<Task>();
  getCompleteTask() async{
    list = List<Task>();
    var taskList = await DBHelper.dbHelper.selectCompleteTask();

    taskList.forEach((element) {
      setState(() {
        list.add(
            Task(id: element[DBHelper.taskIdColumnName],taskName: element[DBHelper.taskNameColumnName],isComplete: element[DBHelper.taskIsCompleteColumnName]!=0));
      });
    });
  }
  @override
  void initState() {
    super.initState();
    getCompleteTask();
  }
  myFun(){
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: TaskWidget(list: list,function: getCompleteTask,),
    );
  }
}
class IncompleteTasks extends StatefulWidget {
  @override
  _IncompleteTasksState createState() => _IncompleteTasksState();
}

class _IncompleteTasksState extends State<IncompleteTasks> {

  List<Task> list = List<Task>();
  getInCompleteTask() async{
    list = List<Task>();
    var taskList = await DBHelper.dbHelper.selectIncompleteTask();

    taskList.forEach((element) {
      setState(() {
        list.add(
            Task(id: element[DBHelper.taskIdColumnName],taskName: element[DBHelper.taskNameColumnName],isComplete: element[DBHelper.taskIsCompleteColumnName]!=0));
      });
    });
  }
  @override
  void initState() {
    super.initState();
    getInCompleteTask();
  }

  myFun(){
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TaskWidget(list: list,function: getInCompleteTask,),
    );
  }
}