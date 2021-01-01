
import 'package:flutter_app_sqflite/db_helper.dart';

class Task{
  int id;
  String taskName;
  bool isComplete;
  Task({this.id,this.taskName, this.isComplete});
  toJson(){
    return {
      DBHelper.taskIdColumnName : this.id,
      DBHelper.taskNameColumnName : this.taskName,
      DBHelper.taskIsCompleteColumnName:this.isComplete ? 1 : 0
    };

  }
   fromJson(Map<String,dynamic> map){
    id = map[DBHelper.taskIdColumnName];
    taskName = map[DBHelper.taskNameColumnName];
    isComplete = map[DBHelper.taskIsCompleteColumnName]!=0;
  }
}