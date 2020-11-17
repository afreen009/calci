import 'dart:io';


import 'package:calculator/pdf/pdf_view.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf_test/PdfPreviewScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:universal_html/html.dart' as html;

import 'list_model.dart';
import 'todo_list_page.dart';
import 'todo_service.dart';

class ListPage extends StatefulWidget {
  final String id;
  final String name;
  final int index;
  ListPage(this.id, this.name, this.index);
  @override
  _ListPageState createState() => _ListPageState(id, name, index);
}

class _ListPageState extends State<ListPage> {
  var id;
  var name;
  int indexes;
  _ListPageState(this.id, this.name, this.indexes);
  final TodoService _todoService = TodoService();

  String transaction;
  TextEditingController _transactionController;
  String amount;

  String particular;
  String values = '';
  List clist = [];
  List plist = [];
  List lengths;
  int selectedRadio;
  String credit;
  String debit;
  Color color;
  var count;
  List pdflist = [];
  List lists = [];

  List responseList;
  List ininlistc = [];
  List ininlistd = [];
  List incl = [];
  List indl = [];
  var cred = 0;
  var deb = 0;
  static Color blue = const Color.fromRGBO(76, 134, 180,1);
static Color lightblue = const Color.fromRGBO(178, 203, 227,1);
  @override
  void initState() {
    var dt = DateTime.now();
    var newFormat = DateFormat("dd-MM-yyyy");
    String updatedDt = newFormat.format(dt);
    _transactionController = TextEditingController(text: updatedDt);
    super.initState();
    selectedRadio = 0;
    transaction = updatedDt;
    print(transaction);
    print(id);
    print(name);
    print(indexes);
    
  }

  gets() async {
    responseList = await _todoService.getlistCollection();
    print('here is d$responseList');
    for (var i = 0; i < responseList.length; i++) {
      if (responseList[i].containsKey('data')) {
        List bufferc = [];
        List bufferd = [];
        for (int k = 0; k < responseList[i]['data'].length; k++) {
          var c = responseList[i]['data'][k]['credit'];
          var deb = responseList[i]['data'][k]['debit'];
          bufferc.add(int.parse(c));
          bufferd.add(int.parse(deb));
        }
        incl.add((bufferc));
        indl.add((bufferd));
      }
    }
    print(incl);
    for (int l = 0; l < incl.length; l++) {
      cred = (incl[l]).fold(0, (p, c) => p + c);
      ininlistc.add(cred);
    }
    print(ininlistc);
    for (int d = 0; d < indl.length; d++) {
      deb = (indl[d]).fold(0, (p, c) => p + c);
      ininlistd.add(deb);
    }
    print(ininlistd);
  }

  final pdf = pw.Document();

  void selectRadio(int val) {
    setState(() {
      print("inside selectRadio method $val");
      selectedRadio = val;
    });
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/account.pdf");

    file.writeAsBytesSync(pdf.save());
  }
void handleClick(String value,) async{
  // DocumentReference docRef = FirebaseFirestore.instance.collection('todos').doc(docid);
  // DocumentSnapshot doc =await docRef.get();
  // List data = doc.data['data'];
    switch (value) {
      case 'update':{

break;
      }
        
      case 'delete':
        break;
    }
}

 void showPopup(Offset offset,index,transations,particular,credit,debit) {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        maxColumn: 2,
        items: [
          MenuItem(title: 'Edit', image: Icon(Icons.edit, color: Colors.white)),
          MenuItem(title: 'Delete',image: Icon(Icons.delete, color: Colors.white,)),
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(rect: Rect.fromPoints(offset, offset));
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(MenuItemProvider item) {
    print('Click menu -> ${item.menuTitle}');
    if(item.menuTitle == 'Edit'){
     showDialog<void>(
                        context: context,
                        builder: (
                          BuildContext context,
                        ) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: AlertDialog(
                              content: StatefulBuilder(
                                builder:
                                    (BuildContext context, StateSetter setState) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextFormField(
                                        keyboardType: TextInputType.phone,
                                        controller: _transactionController,
                                      ),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            InputDecoration(hintText: 'Amount.'),
                                        onChanged: (String value) {
                                          amount = value;
                                        },
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                            hintText: 'Particular.'),
                                        onChanged: (String value) {
                                          particular = value;
                                        },
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text('Credit(+)'),
                                          Radio(
                                            groupValue: selectedRadio,
                                            activeColor: Colors.green,
                                            onChanged: (int val) {
                                              print("Radio $val");
                                              setState(() {
                                                selectRadio(val);
                                              });
                                            },
                                            value: 1,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text("Debit(-) "),
                                          Radio(
                                            groupValue: selectedRadio,
                                            activeColor: Colors.blue,
                                            onChanged: (int val) {
                                              print("Radio $val");
                                              setState(() {
                                                selectRadio(val);
                                              });
                                            },
                                            value: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text('Add'),
                                  onPressed: () async {
                                    print(values);
                                    if (selectedRadio == 1) {
                                      setState(() {
                                        credit = amount;
                                        debit = 0.toString();
                                      });
                                    } else if (selectedRadio == 2) {
                                      setState(() {
                                        debit = amount;
                                        credit = 0.toString();
                                      });
                                    }
                                    final ListModel list = ListModel(
                                        id: id,
                                        transaction: _transactionController.text,
                                        credit: credit,
                                        debit: debit,
                                        particular: particular);
                                    Navigator.of(context).pop();

                                    // await _todoService.addDocumentList(
                                    //     list.toJson(), id);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        });
    }
    else if(item.menuTitle =='Delete') {
      
    }
  }

  void onDismiss() {
    print('Menu is dismiss');
  }
  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TodoListPage())),
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: blue,
          title: Text(name),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.playlist_add),
                  onTap: () {
                    showDialog<void>(
                        context: context,
                        builder: (
                          BuildContext context,
                        ) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: AlertDialog(
                              content: StatefulBuilder(
                                builder:
                                    (BuildContext context, StateSetter setState) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextFormField(
                                        keyboardType: TextInputType.phone,
                                        controller: _transactionController,
                                      ),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            InputDecoration(hintText: 'Amount.'),
                                        onChanged: (String value) {
                                          amount = value;
                                        },
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                            hintText: 'Particular.'),
                                        onChanged: (String value) {
                                          particular = value;
                                        },
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text('Credit(+)'),
                                          Radio(
                                            groupValue: selectedRadio,
                                            activeColor: Colors.green,
                                            onChanged: (int val) {
                                              print("Radio $val");
                                              setState(() {
                                                selectRadio(val);
                                              });
                                            },
                                            value: 1,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text("Debit(-) "),
                                          Radio(
                                            groupValue: selectedRadio,
                                            activeColor: Colors.blue,
                                            onChanged: (int val) {
                                              print("Radio $val");
                                              setState(() {
                                                selectRadio(val);
                                              });
                                            },
                                            value: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text('Add'),
                                  onPressed: () async {
                                    print(values);
                                    if (selectedRadio == 1) {
                                      setState(() {
                                        credit = amount;
                                        debit = 0.toString();
                                      });
                                    } else if (selectedRadio == 2) {
                                      setState(() {
                                        debit = amount;
                                        credit = 0.toString();
                                      });
                                    }
                                    final ListModel list = ListModel(
                                        id: id,
                                        transaction: _transactionController.text,
                                        credit: credit,
                                        debit: debit,
                                        particular: particular);
                                    Navigator.of(context).pop();

                                    await _todoService.addDocumentList(
                                        list.toJson(), id);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        });
                  },
                ),
                SizedBox(width: 10),
                // InkWell(
                //   child: Icon(Icons.more_vert),
                //   onTap: () {
                //     return Positioned(
                //       top: 51,
                //       right: 10,
                //       child: Container(
                //         height: 30,
                //         child: Text('Save as PDF'),
                //       ),
                //     );
                //   },
                // ),
                // PopupMenuButton<String>(
                //   onSelected: writeOnPdf(),
                //   child:,
                // itemBuilder: (BuildContext context) {
                //   return {'Save as pdf'}.map((String choice) {
                //     return PopupMenuItem<String>(
                //       value: choice,
                //       child: Text(choice),
                //     );
                //   }).toList();
                // },
                // ),
                SizedBox(width: 10)
              ],
            )
          ],
        ),
        body: Stack(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('todos').snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data.docs[indexes].data()['data'] == null) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 1.6,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.playlist_add),
                        Text("No data"),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                      height: MediaQuery.of(context).size.height / 1.6,
                      child: Center(child: Text(snapshot.error)));
                } else if (snapshot.data.docs[indexes].data == null) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.playlist_add),
                        Text("No data"),
                      ],
                    ),
                  );
                }
                lengths = snapshot.data.docs[indexes].data()['data'];
                print(lengths);
                twoD(list) {
                  lists.add(list);
                }

                for (int i = 0; i <= lengths.length - 1; i++) {
                  var dsum = lengths[i]['debit'];
                  plist.add(int.parse(dsum));
                  var csum = lengths[i]['credit'];
                  clist.add(int.parse(csum));
                  pdflist.add([
                    lengths[i]['transaction'].toString(),
                    lengths[i]['particular'].toString(),
                    lengths[i]['credit'].toString(),
                    lengths[i]['debit'].toString()
                  ]);
                  twoD(list);
                }
                gets();
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          height: 40,
                          color: Colors.grey[100],
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: width / 4.5,
                                  child: Center(
                                    child: Text(
                                      "Date",
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width / 4.5,
                                  child: Center(
                                    child: Text(
                                      "Particular",
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width / 4.5,
                                  child: Center(
                                    child: Text(
                                      "Credit (₹)",
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width / 4.5,
                                  child: Center(
                                    child: Text(
                                      "Debit (₹)",
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                    width: width / 20,
                                    child: Center(
                                        child: InkWell(
                                      child: Icon(
                                        Icons.file_download,
                                        color: Colors.green,
                                      ),
                                      onTap: () async {
                                        print("uhohugihvuyyuviiivhiiyv$pdflist");
                                        await reportView(pdflist);
                                      },
                                    )))
                              ])),
                    ),
                    Positioned(
                      top: 41,
                      left: 0,
                      right: 0,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: height / 1.4,
                            child: ListView.builder(
                                itemCount: lengths.length,
                                itemBuilder: (context, index) {
                                  print(pdflist);
                                  return GestureDetector(
                                    onTapUp: (TapUpDetails details) {
                    showPopup(details.globalPosition,index,lengths[index]['transaction'].toString(),lengths[index]['particular']
                                                      .toString(),lengths[index]['credit'].toString(),lengths[index]['debit'].toString(),);
                  },
                                                                      child: Container(
                                          height: 40,
                                          child: Row(children: [
                                            Container(
                                              width:
                                                  MediaQuery.of(context).size.width / 4.3,
                                              child: Center(
                                                child: Text(
                                                  lengths[index]['transaction']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: color),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  MediaQuery.of(context).size.width / 4.3,
                                              child: Center(
                                                child: Text(
                                                  lengths[index]['particular']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  MediaQuery.of(context).size.width / 4.3,
                                              child: Center(
                                                child: Text(
                                                  lengths[index]['credit'].toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  MediaQuery.of(context).size.width / 4.3,
                                              child: Center(
                                                child: Text(
                                                  lengths[index]['debit'].toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ])),
                                  );
                                },
                              ),
                          ),
                          // Container(),
                        ],
                      ),
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   left: 0,
                    //   right: 0,
                    //   child: Container(
                    //     height: 90,
                    //     child: Row(children: <Widget>[
                    //       Container(
                    //         color: Colors.green[100],
                    //         width: MediaQuery.of(context).size.width / 3,
                    //         child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Text("Credit(ij)\n "),
                    //               Text("₹" + ininlistc[indexes].toString())
                    //             ]),
                    //       ),
                    //       Container(
                    //         color: Colors.grey[400],
                    //         width: MediaQuery.of(context).size.width / 3,
                    //         child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Text("Debit(ij)\n"),
                    //               Text("₹" + ininlistd[indexes].toString())
                    //             ]),
                    //       ),
                    //       Container(
                    //         color: Colors.amber,
                    //         width: MediaQuery.of(context).size.width / 3,
                    //         child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Text("Balance"),
                    //               Text("₹" +
                    //                   (ininlistc[indexes] - ininlistd[indexes])
                    //                       .toString())
                    //             ]),
                    //       ),
                    //     ]),
                    //   ),
                    // )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
