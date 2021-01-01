import 'package:flutter/cupertino.dart';
import 'package:flutter_app_sqflite/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DBHelper{
  DBHelper._();
  static DBHelper dbHelper = DBHelper._();
  static final String databaseName = "tasksDb.db";
  static final String tableName = "tasks";
  static final String taskIdColumnName = "id";
  static final String taskNameColumnName = "name";
  static final String taskIsCompleteColumnName = "isComplete";
  Database database;
  Future<Database> initDatabase() async {
    if(database ==null){
     return await createDatabase();
    }else{
      return database;
    }
  }
  Future<Database> createDatabase() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, databaseName); // databasesPath+'/demo.db'
      Database database = await openDatabase(path,version: 2,onCreate: (db,version){
        db.execute(
            'CREATE TABLE $tableName ($taskIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT, $taskNameColumnName TEXT NOT NULL, $taskIsCompleteColumnName INTEGER)');
      });
      return database;
    } on Exception catch (e) {
      print(e);
    }
  }

   insertNewTask(Task task) async{
    try {
      database = await initDatabase();
         int x = await database.insert(tableName, task.toJson());
         print(x);
    } on Exception catch (e) {
      print(e);
    }
  }


   selectAllTask() async {
    try {
      database = await initDatabase();
      List<Map> list = await database.query(tableName);
      // list.map((e) {
      //   if(e!=null){
      //     listTask.add(Task(taskName: e[taskNameColumnName],isComplete: e[taskIsCompleteColumnName]));
      //   }
      // });
      // for(var i=0; i<list.length; i++){
      //  list.map((e) => TaskWidget(task:Task(taskName: e[i]['name'],isComplete: e[i]['isComplete']))).toList();
      // }
      // print(list);
      // print(listTask);
      return list;
    } on Exception catch (e) {
      print(e);
    }
  }

    selectCompleteTask() async {
    try {
      database = await initDatabase();
         List<Map> list = await database.query(tableName,where: '$taskIsCompleteColumnName=?',whereArgs: [1]);
        return list;
    } on Exception catch (e) {
         print(e);
    }
  }

  selectIncompleteTask() async {
    try {
      database = await initDatabase();
      List<Map> list = await database.query(tableName,where: '$taskIsCompleteColumnName=?',whereArgs: [0]);
      return list;
    } on Exception catch (e) {
      print(e);
    }
  }
  updateTask(Task task) async {
    try {
      database = await initDatabase();
         int x= await database.update(tableName, task.toJson(),where: '$taskIdColumnName=?',whereArgs: [task.id]);

            print(x);


    } on Exception catch (e) {
          print(e);
    }
  }

  deleteTask(int id) async {
    try {
      database = await initDatabase();
      int x= await database.delete(tableName,where: '$taskIdColumnName=?',whereArgs: [id]);
      print(x);
    } on Exception catch (e) {
      print(e);
    }
  }

  // Future<int> getCount() async{
  //   database = await initDatabase();
  //   List<Map> x= await database.rawQuery('SELECT COUNT (*) FROM $tableName');
  //   int result = Sqflite.firstIntValue(x);
  //   return result;
  //
  // }
}