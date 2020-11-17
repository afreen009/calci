import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String content;

  Todo({this.id, this.content});

  factory Todo.fromJson(DocumentSnapshot json) => Todo(
        id: json.id,
        content: json.data()['content'],
      );


  //To create a Todo
  Todo.createTodoFromMap(DocumentSnapshot doc){
      this.id=doc.id;
      this.content=doc.data()['content'];
  }

  Map<String, dynamic> toJson() => {
        'created': FieldValue.serverTimestamp(),
        'content': content,
      };
}
