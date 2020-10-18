

class Employee{
  int id;
  String name;
  String course;

  Employee({this.id, this.name, this.course});
  Map<String,dynamic>tomap(){
    var map=<String ,dynamic>{
      'name':name,
      'course':course,
    };
    return map;
  }
  Employee.fromMap(Map<String,dynamic>map){
    name=map[name]['name'];
    course=map[course]['course'];
  }
}