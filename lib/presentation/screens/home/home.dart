
import 'package:calculator/helpers/appTheme.dart';
import 'package:calculator/models/user_transaction.dart';
import 'package:calculator/presentation/screens/loading/loading.dart';
import 'package:calculator/presentation/screens/error/error.dart';
import 'package:calculator/presentation/widgets/transaction_list_item.dart';
import 'package:calculator/presentation/widgets/user_create_alert.dart';
import 'package:calculator/services/pdf/pdf_creator.dart';
import 'package:calculator/services/transaction_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  //Get our singleton firebaseService object
  final TransactionService _transactionService =
      TransactionService.getTransactionServiceInstance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: StreamBuilder(
            stream: _transactionService.fetchAllUsersTransaction(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot> _docs = snapshot.data.docs;
                double _creditTotalAmount = 0;
                double _balanceTotalAmount = 0;
                double _debitTotalAmount = 0;
                _docs.forEach((userTransaction) {
                  User user = User.fromDocumentSnaphot(
                      userTransaction.id, userTransaction.data());
                  _creditTotalAmount += user.calculateCreditAmount;
                  _debitTotalAmount += user.calculateDebitAmount;
                  _balanceTotalAmount += user.calculateBalanceAmount;
                });
                return Container(
                  height: 50,
                  child: Row(
                    children: [
                      _buildCustomContainer('Credit',
                          _creditTotalAmount.toString(), AppTheme.creditColor),
                      _buildCustomContainer('Debit',
                          _debitTotalAmount.toString(), AppTheme.debitColor),
                      _buildCustomContainer('Balance',
                          _balanceTotalAmount.toString(), Colors.blue[100]),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text('Dashboard'),
          centerTitle: true,
          actions: [
            StreamBuilder(
              stream: _transactionService.fetchAllUsersTransaction(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Error();
                else if (snapshot.hasData) {
                  //Get documents
                  List<QueryDocumentSnapshot> _docs = snapshot.data.docs;
                  //Instead retuning the listView itself
                  return IconButton(
                      icon: Icon(
                        Icons.print,
                        color: Colors.white,
                      ),
                      onPressed: () async =>
                          await PdfCreator.createAllUsersRapports(
                              _docs.map((doc) {
                            User user =
                                User.fromDocumentSnaphot(doc.id, doc.data());
                            return user;
                          }).toList()));
                }
                //Loading
                return Loading();
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showDialog(context),
          child: Icon(Icons.add, color: Colors.white),
          tooltip: 'Create a user',
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.generalOutSpacing - 10,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: _transactionService.fetchAllUsersTransaction(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Error();
                else if (snapshot.hasData) {
                  //Get documents
                  List<QueryDocumentSnapshot> _docs = snapshot.data.docs;
                  if (snapshot.data.size == 0) {
                    return Center(child: Text('No User yet'));
                  }

                  //Instead retuning the listView itself
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.size,
                    itemBuilder: (context, index) {
                      User user = User.fromDocumentSnaphot(
                          _docs[index].id, _docs[index].data());
                      return TransactionListItem(user: user);
                    },
                  );
                }
                //Loading
                return Loading();
              },
            )));
  }

  _showDialog(BuildContext context) {
    showDialog(context: context, child: UserCreateAlert());
  }

  //Build container
  Expanded _buildCustomContainer(
      String nameOfField, String amount, Color color) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(boxShadow: [], color: color),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(nameOfField,
                  style: AppTheme.generalTextStyle
                      .copyWith(fontWeight: FontWeight.w100)),
              Text('$amount ₹', style: AppTheme.generalTextStyle),
            ],
          )),
    );
  }
}
