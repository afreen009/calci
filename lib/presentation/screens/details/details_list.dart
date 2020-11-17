
import 'package:calculator/cubit/rebuild_fixer.dart';
import 'package:calculator/helpers/appTheme.dart';
import 'package:calculator/models/transaction.dart' as Transaction;
import 'package:calculator/models/user_transaction.dart';
import 'package:calculator/presentation/screens/loading/loading.dart';
import 'package:calculator/presentation/screens/error/error.dart';
import 'package:calculator/presentation/widgets/alert_dialog.dart';
import 'package:calculator/presentation/widgets/details_list_item.dart';
import 'package:calculator/services/pdf/pdf_creator.dart';
import 'package:calculator/services/transaction_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsList extends StatelessWidget {
  final User user;
  final TransactionService _transactionService =
      TransactionService.getTransactionServiceInstance;
  DetailsList({@required this.user}) : assert(user != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: StreamBuilder<DocumentSnapshot>(
            stream: _transactionService.fetchOneUsersTransaction(
                userID: user.userID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot _doc = snapshot.data;
                double _creditTotalAmount = 0;
                double _balanceTotalAmount = 0;
                double _debitTotalAmount = 0;
                _doc['transactionList'].forEach((dynamic transaction) {
                  Transaction.Transaction _transaction =
                      Transaction.Transaction.mapToTransaction(transaction);
                  _creditTotalAmount += _transaction.credit;
                  _debitTotalAmount += _transaction.debit;
                  _balanceTotalAmount +=
                      (_transaction.credit - _transaction.debit);
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
        floatingActionButton: _buildFLoatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          title: Text(this.user.name),
          centerTitle: true,
          actions: [
            StreamBuilder(
              stream: _transactionService.fetchOneUsersTransaction(
                  userID: user.userID),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Error();
                else if (snapshot.hasData) {
                  DocumentSnapshot _doc = snapshot.data;
                  User _user = User.fromDocumentSnaphot(_doc.id, _doc.data());
                  return IconButton(
                      icon: Icon(Icons.playlist_add),
                      onPressed: () => _showDialog(context, _user));
                }
                return Loading();
              },
            )
          ],
        ),
        body: BlocBuilder<RebuildFixer, bool>(builder: (context, unsedVal) {
          return StreamBuilder<DocumentSnapshot>(
              stream: _transactionService.fetchOneUsersTransaction(
                  userID: user.userID),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Error();
                else if (snapshot.hasData) {
                  //Get documents
                  DocumentSnapshot _doc = snapshot.data;
                  User _user = User.fromDocumentSnaphot(_doc.id, _doc.data());

                  if (_user.transactionList.length == 0) {
                    return Center(child: Text('No transactions yet'));
                  }
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildHeader(),
                      ),
                      _buildList(_user)
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
        }));
  }

  //This function build the entire Transaction Items
  SliverList _buildList(User _user) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return DetailsListItem(
          user: _user,
          addFunction: _addFunction,
          credit: _user.transactionList[index].credit,
          debit: _user.transactionList[index].debit,
          date: _user.transactionList[index].transactionDate,
          indexOfTransaction: index,
          particular: _user.transactionList[index].particular,
        );
      }, childCount: _user.transactionList.length),
    );
  }

  Container _buildHeader() {
    return Container(
        decoration: BoxDecoration(
            color: AppTheme.creditColor,
            borderRadius: BorderRadius.circular(25)),
        margin: const EdgeInsets.only(top: 7, left: 7, right: 7),
        child: ListTile(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Date'),
                Text('Particular'),
                Text('Credit ₹'),
                Text('Debit ₹')
              ]),
        ));
  }

  //Build floatingAction Button
  Padding get _buildFLoatingActionButton => Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.smallSpacing + 55),
      child: StreamBuilder<DocumentSnapshot>(
          stream:
              _transactionService.fetchOneUsersTransaction(userID: user.userID),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Container();
            else if (snapshot.hasData) {
              //Get documents
              DocumentSnapshot _doc = snapshot.data;
              User _user = User.fromDocumentSnaphot(_doc.id, _doc.data());

              if (_user.transactionList.length == 0) {
                return FloatingActionButton(
                  onPressed: null,
                  child:
                      Icon(Icons.print_disabled, color: AppTheme.creditColor),
                  tooltip: 'View rapport',
                );
              }
              return FloatingActionButton(
                onPressed: () async =>
                    await PdfCreator.createOneUserRapport(_user),
                child: Icon(Icons.print, color: AppTheme.creditColor),
                tooltip: 'View rapport',
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }));

  //SHow ALertDialog
  _showDialog(context, User user) {
    showDialog(
        context: context,
        child: AddTransactionDialog(user: user, addFunction: _addFunction));
  }

  //addFunction declaration
  void _addFunction(Transaction.Transaction transaction, User user,
      {int indexOfTransaction, String operationType: 'add'}) {
    assert(user != null);
    if (operationType == 'add') {
      user.transactionList.add(transaction);
      _transactionService.addAndUpdateuserTransactionsList(
          docId: user.userID,
          newTransactionList: user.getMappedTransactionList);
    } else {
      //For update
      user.transactionList[indexOfTransaction] = transaction;
      _transactionService.addAndUpdateuserTransactionsList(
          docId: user.userID,
          newTransactionList: user.getMappedTransactionList);
    }
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
