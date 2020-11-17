import 'package:calculator/todo/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'list_model.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
CollectionReference _todoCollection = _firestore.collection('todos');
List list = [];

class TodoService {
  static var sumd = 0;

  
  // Stream<List<Todo>> getAllTodos() {
  //   return _todoCollection.snapshots(includeMetadataChanges: true).map(
  //       (QuerySnapshot _querySnapshot) => _querySnapshot.docs
  //           .map((DocumentSnapshot _documentSnapshot) =>
  //               Todo.fromJson(_documentSnapshot))
  //           .toList());
  // }

  //Get from the server all the list of collection
  Stream<QuerySnapshot> getCollection(){
    return FirebaseFirestore.instance.collection("todos").snapshots(includeMetadataChanges: true);
  }

  Future<List<Map<dynamic, dynamic>>> getlistCollection() async {
    List<DocumentSnapshot> tempslist;
    List<Map<dynamic, dynamic>> lists = new List();
    CollectionReference collectionRef = FirebaseFirestore.instance.collection("todos");
    QuerySnapshot collectionSnapshot = await collectionRef.get();

    tempslist = collectionSnapshot.docs; // <--- ERROR

    lists = tempslist.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data();
    }).toList();

    return lists;
  }

  Future<List<ListModel>> getAllList(id) async {
    List users = List();
    final docs = await _todoCollection.get();
    print(docs);
    // docs.f((doc) {
    //   users.add(doc.data);
    // });
    // (QuerySnapshot _querySnapshot) => _querySnapshot.documents
    //     .map((DocumentSnapshot _documentSnapshot) =>
    //         ListModel.fromJson(_documentSnapshot))
    //     .toList());
  }

  CollectionReference get users => _firestore.collection('todos');
  getData(name) {
    return users.where('content', isEqualTo: '$name').get();
    // return await _firestore.collection(name).getDocuments();
  }

  Stream<DocumentSnapshot> provideDocumentFieldStream(name) {
    return FirebaseFirestore.instance.collection('todos').doc(name).snapshots();
  }
  // Stream<List<ListModel>> getAllTodosList(id,name) {
  //   final _todoCollectionList = _firestore.collection('todos').document(id).collection(name);
  //   return _todoCollectionList.snapshots(includeMetadataChanges: true).map(
  //       (QuerySnapshot _querySnapshot) => _querySnapshot.documents
  //           .map((DocumentSnapshot _documentSnapshot) =>
  //               ListModel.fromJson(_documentSnapshot))
  //           .toList());
  // }

  Future<void> addDocument(Todo todo) {
    return _todoCollection.doc().set(todo.toJson());
  }

  Future<void> deleteDocument(String id) {
    return _todoCollection.doc(id).delete();
  }

  Future<void> addDocumentList(list, String name) async {
    DocumentSnapshot doc = await _todoCollection.doc(name).get();
    List lists = doc.data()['data'];
    return _todoCollection.doc(name).update({
      'data': FieldValue.arrayUnion([list])
    });
    // return _todoCollection.document(name).setData(list);
  }

  Future<String> getcreditlist(id) async {
    DocumentSnapshot sp =
        await _firestore.collection("todos").doc(id).get();
    List clist = sp.data()['data'];

    List listc = [];
    for (var e in clist) {
      var credit = e['credit'];
      listc.add(int.parse(credit));
      print(credit);
    }
    var sumc = 0;
    sumc = clist.fold(0, (p, c) => p + c);
    print(sumc);
    return sumc.toString();
  }

  getdebitlist(id) async {
    DocumentSnapshot sp =
        await _firestore.collection("todos").doc(id).get();
    List dlist = sp.data()['data'];
    List listd = [];
    for (var e in dlist) {
      var debit = e['debit'];
      listd.add(int.parse(debit));
      print(debit);
    }

    sumd = listd.fold(0, (p, c) => p + c);
    print(sumd);
    return sumd.toString();
    // String sc = sumd.toString();
  }

  Future<void> getDocuments(String name) async {
    DocumentSnapshot doc = await _todoCollection.doc(name).get();
    List lists = doc.data()['data'];
    return lists;
    // return _todoCollection.document(name).setData(list);
  }
}
