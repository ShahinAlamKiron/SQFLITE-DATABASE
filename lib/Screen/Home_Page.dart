import 'package:flutter/material.dart';
import 'package:sqf_lite/Model_Page/Employee_Model.dart';
import 'package:sqf_lite/Services_Page/Employee_Services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final DBManager dbManager=new DBManager();
  Employee employee;
  List<Employee>_listemployee;

  TextEditingController _nameControlar=new TextEditingController();
  TextEditingController _courseControlar=new TextEditingController();
  GlobalKey<FormState>_globalKey=GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Sqflite"),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.grey,
            borderRadius: BorderRadius.circular(6)),
            margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Form(
              key: _globalKey,
              child: Column(
                children: [

                  TextFormField(
                    controller: _nameControlar,
                    validator: (val){
                      if(val.isEmpty){
                        return "Input not value";
                      }return null;
                    },
                    decoration: InputDecoration(
                      focusedBorder:OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        labelText: "Enter Name",
                    labelStyle: TextStyle(color: Colors.white)),
                  ),

                  SizedBox(height: 15,),

                  TextFormField(
                    controller: _courseControlar,
                    validator: (val){
                      if(val.isEmpty){
                        return "Input not value";
                      }return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder:OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      border: OutlineInputBorder(),
                        labelText: "Enter Course"),
                  ),

                  SizedBox(height: 15,),

                  Container(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.green,
                      child: Text("Save Data",style: TextStyle(color: Colors.white,fontSize: 20),),
                        onPressed: validbutton),)
                ],
              ),
            ),
          ),
          Expanded(child:
           Container(
             margin: EdgeInsets.symmetric(horizontal: 20),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(6),
               color: Colors.grey
             ),
             child:FutureBuilder(
               future: dbManager.getdb(),
               builder:(context,snapshot){
                 if(snapshot.hasData){
                   _listemployee=snapshot.data;
                   return ListView.builder(
                     itemCount: _listemployee==null?0:_listemployee.length,
                       itemBuilder: (context,int index){
                       Employee data=_listemployee[index];
                     return ListTile(
                       title: Text(data.name,style: TextStyle(fontSize: 20,color: Colors.white),),
                       subtitle: Text(data.course,style: TextStyle(fontSize: 15,color: Colors.yellow),),
                       leading: CircleAvatar(child: Text(data.id.toString()),),
                       trailing: IconButton(icon: Icon(Icons.delete),
                         color: Colors.red,
                         onPressed: (){
                           dbManager.deletedb(data.id);
                           setState(() {
                           _listemployee.removeAt(index);
                         });
                         },),
                     );
                   });
                 }return Center(child: CircularProgressIndicator(),);
               },
             ),))

        ],
      ),
    );
  }

  void validbutton() {
    if(_globalKey.currentState.validate()){
      if(employee==null){
        Employee em=Employee(name: _nameControlar.text,course: _courseControlar.text,);
        dbManager.insertDb(em).then((id) => {
          _nameControlar.clear(),
          _courseControlar.clear(),
          print("added value${id}"),
        });
      }
    }
  }
}
