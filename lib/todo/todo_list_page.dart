import 'package:calculator/todo/todo_model.dart';
import 'package:calculator/todo/todo_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'calculator.dart';
import 'list.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _TodoListPageState extends State<TodoListPage> {
  final TodoService _todoService = TodoService();
   static Color blue = const Color.fromRGBO(76, 134, 180,1);
static Color lightblue = const Color.fromRGBO(178, 203, 227,1);
  TextEditingController controller = new TextEditingController();

  String todoContent;
  String todoUpdate;
  bool check;
  List d;
  List ininClist = [];
  List ininDlist = [];
  List inc = [];
  List ind = [];
  var cred ;
  var deb ;
  int totalC =0;
  int totalD=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> get(List<QueryDocumentSnapshot> docs) async {
    d = docs.map((doc) {
      return doc.data();
    }).toList();
    // print('here is d$d');
    for (var i = 0; i < d.length; i++) {
      if (d[i].containsKey('data') == false) {
        ininClist.add(0);
        ininDlist.add(0);
      }
      else if (d[i].containsKey('data')) {
        cred = d[i]['data'].map((m)=>int .parse(m['credit'])).reduce((a,b)=>a+b);
        ininClist.add(cred);
        deb = d[i]['data'].map((m)=>int .parse(m['debit'])).reduce((a,b)=>a+b);
        print(deb);
        ininDlist.add(deb);
        totalC += d[i]['data'].map((m)=>int .parse(m['credit'])).reduce((a,b)=>a+b);
        totalD += d[i]['data'].map((m)=>int .parse(m['debit'])).reduce((a,b)=>a+b);
        // List bufferc = [];
        // List bufferd = [];
        // for (int k = 0; k < d[i]['data'].length; k++) {
        //   var c = d[i]['data'][k]['credit'];
        //   var deb = d[i]['data'][k]['debit'];
        //   bufferc.add(int.parse(c));
        //   bufferd.add(int.parse(deb));
        // }
        // inc.add((bufferc));
        // ind.add((bufferd));
      }
      // totalC = ininClist.reduce((p, c) => p + c);
    // print("totalcredit$totalC");
    // totalD = ininDlist.reduce((d, e) => d + e);
    // print("totaldebit$totalD");
    }
    // totalC = ininClist.fold(0,(value, element) => value+element);
    // print(totalC.runtimeType);
    print(totalC);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SimpleCalculator())),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        // drawer: NavDrawer(totalC,totalD),
        appBar: AppBar(
          backgroundColor: blue,
          automaticallyImplyLeading: false,
          title: Text("DashBoard"),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: _todoService.getCollection(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: blue,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('No data'));
            }
            
            List<DocumentSnapshot> todosForGet = snapshot.data.docs;
            final List<Todo> todos = todosForGet.map((todo) {
              return Todo.createTodoFromMap(todo);
            }).toList();
            totalC=0;
            totalD=0;
            get(todosForGet);
            return Stack(
              children: [
                Container(
                    height: height,
                    child: SingleChildScrollView(
                                          child: Container(
                        height:height/1.3,
                        child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 16.0);
                            },
                            itemCount: todos.length,
                            padding: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                            itemBuilder: (context, index) {
                              final Todo todo = todos[index];
                              return GestureDetector(
                                child: Container(
                                  height: 140,
                                  decoration: BoxDecoration(
                // border: Border.all(width: 0.3),
                color: Colors.white,
                                  ),
                                  child: Stack(children: [
                // await _todoService.deleteDocument(todo.id);
                Positioned(
                      top: 10,
                      left: 12,
                      child: Row(
                        children: [
                          Text(
                            todo.content,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: blue),
                          ),
                        ],
                      )),
                Positioned(
                      top: 10,
                      right: 10,
                      child: Row(
                        children: [
                          // GestureDetector(
                          //   child: Container(
                          //       decoration: BoxDecoration(
                          //         color: Colors.green,
                          //         borderRadius:
                          //             BorderRadius.circular(8.0),
                          //       ),
                          //       child: Icon(
                          //         Icons.edit,
                          //         color: Colors.white,
                          //       )),
                          //   onTap: () async {
                          //     setState(() {
                          //       check = false;
                          //     });
                          //     showDialog(
                          //         context: context,
                          //         builder: (context) {
                          //           return AlertDialog(
                          //             content: TextField(
                          //               decoration: InputDecoration(
                          //                   hintText:
                          //                       'Enter Account name'),
                          //               onChanged: (String value) {
                          //                 setState(() {
                          //                   todoUpdate = value;
                          //                   print(todo.id);
                          //                 });
                          //               },
                          //             ),
                          //             actions: <Widget>[
                          //               RaisedButton(
                          //                 child: Text('Add'),
                          //                 onPressed: () async {
                          //                   final Todo todo = Todo(
                          //                       content: todoUpdate);
                          //                   Navigator.pop(context);
                          //                   for (var i = 0;
                          //                       i < todos.length;
                          //                       i++) {
                          //                     if (todos[i]
                          //                         .content
                          //                         .contains(
                          //                             todoUpdate)) {
                          //                       print("duplicate");
                          //                       setState(() {
                          //                         check = true;
                          //                       });
                          //                     }
                          //                   }
                          //                   if (check == true) {
                          //                     showDialog(
                          //                         context: context,
                          //                         builder: (context) {
                          //                           Future.delayed(
                          //                               Duration(
                          //                                   seconds: 1),
                          //                               () {
                          //                             Navigator.of(
                          //                                     context)
                          //                                 .pop(true);
                          //                           });
                          //                           return AlertDialog(
                          //                             title: Text(
                          //                                 'Duplicate entry'),
                          //                           );
                          //                         });
                          //                   } else {
                          //                     var id = todo.id;
                          //                     final Firestore _db =
                          //                         Firestore.instance;
                          //                     final collection =
                          //                         'todos';
                          //                     final documentId = '$id';

                          //                     // print(snapShot);
                          //                     // await Firestore.instance
                          //                     //     .collection('todos')
                          //                     //     .document(todo.id)
                          //                     //     .updateData({
                          //                     //   'content': todoUpdate
                          //                     // });
                          //                     // _todoService
                          //                     //     .updateDocument(
                          //                     //         todoUpdate,
                          //                     //         todo.id);
                          //                   }
                          //                 },
                          //               ),
                          //               FlatButton(
                          //                 child: Text('Cancel'),
                          //                 onPressed: () {
                          //                   Navigator.pop(context);
                          //                 },
                          //               )
                          //             ],
                          //           );
                          //         });
                          //   },
                          // ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: blue,
                                )),
                            onTap: () async {
                              await _todoService
                                  .deleteDocument(todo.id);
                            },
                          )
                        ],
                      )),
                SizedBox(
                  height: 120,
                ),
                Positioned(
                  top: 65,
                  left: 2,
                  right: 2,
                  child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 65,
                          width: 105,
                          decoration: BoxDecoration(
                              // border: Border.all(width: 0.3),
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0))),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                "Credit(ij)",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              ininClist.length == 0
                                  ? Text("₹ 0")
                                  : ininClist[index] == ''
                                      ? Text("0")
                                      : Text("₹" +
                                          ininClist[index].toString())
                            ],
                          ),
                        ),
                        Container(
                          height: 65,
                          width: 105,
                          decoration: BoxDecoration(
                              // border: Border.all(width: 0.3),
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0))),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                "Debit(ij)",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              ininDlist.length == 0
                                  ? Text("0")
                                  : ininDlist[index] == ''
                                      ? Text("0")
                                      : Text("₹" +
                                          ininDlist[index].toString())
                            ],
                          ),
                        ),
                        Container(
                          height: 65,
                          width: 105,
                          decoration: BoxDecoration(
                              // border: Border.all(width: 0.3),
                              color: blue,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0))),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                "Balance",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              ininClist.length == 0
                                  ? Text("0")
                                  : ininDlist[index] == ''
                                      ? Text("0")
                                      : Text("₹ " +
                                          (ininClist[index] -
                                                  ininDlist[index])
                                              .toString())
                            ],
                          ),
                        ),
                      ],
                  ),
                )
                                  ]),
                                ),
                                onTap: () {
                                  Navigator.push(
                context,
                MaterialPageRoute(
                      builder: (context) =>
                          ListPage(todo.id, todo.content, index)),
                                  );
                                },
                              );
                            }),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 46,
                  right: 10,
                  child: FloatingActionButton(
                    backgroundColor: blue,
                    onPressed: () {
                      setState(() {
                        check = false;
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: TextField(
                                textCapitalization:TextCapitalization.words,
                                decoration: InputDecoration(
                                    hintText: 'Enter customer name.'),
                                onChanged: (String value) {
                                  todoContent = value;
                                },
                              ),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text('Add'),
                                  onPressed: () async {
                                    final Todo todo =
                                        Todo(content: todoContent);
                                    Navigator.pop(context);
                                    for (var i = 0; i < todos.length; i++) {
                                      if (todos[i]
                                          .content
                                          .contains(todoContent)) {
                                        print("duplicate");
                                        setState(() {
                                          check = true;
                                        });
                                      }
                                    }
                                    if (check == true) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 1),
                                                () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              title: Text('Duplicate entry'),
                                            );
                                          });
                                    } else {
                                      ininClist.clear();
                                      ininDlist.clear();
                                      await _todoService.addDocument(todo);
                                    }
                                  },
                                ),
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                    child: Icon(Icons.add),
                  ),
                ),
                Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 45,
                        child: Row(children: <Widget>[
                          Container(
                            color: Colors.grey[200],
                            width: MediaQuery.of(context).size.width / 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Credit(ij)"),
                                  Text("₹" + totalC.toString())
                                ]),
                          ),
                          Container(
                            color: Colors.grey[400],
                            width: MediaQuery.of(context).size.width / 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Debit(ij)"),
                                  Text("₹" + totalD.toString())
                                ]),
                          ),
                          Container(
                            color: blue,
                            width: MediaQuery.of(context).size.width / 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Balance"),
                                  Text("₹" +
                                      (totalC -totalD)
                                          .toString())
                                ]),
                          ),
                        ]),
                      ),
                    )
              ],
              
            );
          },
          
        ),
        
      ),
    );
  }
}
