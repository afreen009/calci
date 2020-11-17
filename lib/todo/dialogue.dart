// import 'package:flutter/material.dart';
// import 'package:flutter_app/todo/list_model.dart';

// class Dialogue extends StatefulWidget {
//   String id;
//   String name;
//   Dialogue(this.id, this.name);
//   @override
//   _DialogueState createState() => _DialogueState(id, name);
// }

// class _DialogueState extends State<Dialogue> {
//   var id;
//   var name;
//   _DialogueState(this.id, this.name);
//   int count = 0;
//   String transaction;
//   String amount;
//   String particular;
//   // int groupValue = -1;
//   String values = '';
//   List list = [];
//   int selectedRadio;
//   String credit;
//   String debit;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     count = 0;
//     selectedRadio = 0;
//   }

//   void selectRadio(int val) {
//     setState(() {
//       selectedRadio = val;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: Column(
//         children: <Widget>[
//           TextField(
//             decoration: InputDecoration(hintText: 'Transaction Date.'),
//             onChanged: (String value) {
//               transaction = value;
//             },
//           ),
//           TextField(
//             decoration: InputDecoration(hintText: 'Amount.'),
//             onChanged: (String value) {
//               amount = value;
//             },
//           ),
//           TextField(
//             decoration: InputDecoration(hintText: 'Particular.'),
//             onChanged: (String value) {
//               particular = value;
//             },
//           ),
//           Row(
//             children: <Widget>[
//               Text('Credit(+)'),
//               Radio(
//                 groupValue: selectedRadio,
//                 activeColor: Colors.green,
//                 onChanged: (val) {
//                   print("Radio $val");
//                   selectRadio(val);
//                 },
//                 value: 1,
//               ),
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               Text("Debit(-)"),
//               Radio(
//                 groupValue: selectedRadio,
//                 activeColor: Colors.blue,
//                 onChanged: (val) {
//                   print("Radio $val");
//                   selectRadio(val);
//                 },
//                 value: 2,
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: <Widget>[
//         RaisedButton(
//           child: Text('Add'),
//           onPressed: () async {
//             print(values);
//             final ListModel list = ListModel(
//                 id: id,
//                 content: name,
//                 transaction: transaction,
//                 credit: "credit",
//                 amount: amount,
//                 particular: particular);
//             // Navigator.of(context).pop();
//             // await _todoService.addDocumentList(
//             //     list.toJson(), id);

//             // Firestore.instance
//             //     .collection("todos")
//             //     .where("name", isEqualTo: name)
//             //     .getDocuments()
//             //     .then((value) {
//             //   value.documents.forEach((result) {
//             //     print(result.data);
//             //   });
//             // });
//           },
//         ),
//         FlatButton(
//           child: Text('Cancel'),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         )
//       ],
//     );
//   }
// }
