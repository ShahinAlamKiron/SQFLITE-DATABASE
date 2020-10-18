import 'dart:async';
import 'package:path/path.dart';
import 'package:sqf_lite/Model_Page/Employee_Model.dart';
import 'package:sqflite/sqflite.dart';

class DBManager{
   Database _database;
   static const String Path_Name="Employee.db";
   static const String Table_Name="Employee";
   static const String Colum_Id="id";
   static const String Colum_Name="name";
   static const String Colum_Course="course";

   Future opendb()async{
     if(_database==null){
       _database=await openDatabase(join(await getDatabasesPath(),Path_Name),
       version: 1,
       onCreate: (Database db,int version)async{
         await db.execute("CREATE TABLE $Table_Name($Colum_Id INTEGER PRIMARY KEY autoincrement,$Colum_Name TEXT,$Colum_Course TEXT)");
       });
     }
   }

   Future insertDb(Employee employee)async{
     await opendb();
     return await _database.insert(Table_Name,employee.tomap());

   }

  Future<List<Employee>> getdb()async{
     final List<Map<String,dynamic>>map=await _database.query(Table_Name);
     return List.generate(map.length, (index){
       return Employee(
         id: map[index]['id'],
         name: map[index]['name'],
         course: map[index]['course'],
       );
     });
   }

   Future updatedb(Employee employee)async{
     await opendb();
     return await _database.update(Table_Name,employee.tomap(),where: "id-?",whereArgs: [employee.id]);
   }

   Future deletedb(int id)async{
     await opendb();
     return await _database.delete(Table_Name,where: "id=?",whereArgs: [id]);
   }
}