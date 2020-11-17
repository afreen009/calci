
import 'package:calculator/helpers/appTheme.dart';
import 'package:calculator/models/user_transaction.dart';
import 'package:calculator/services/transaction_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'alert_dialog.dart';

class DetailsListItem extends StatelessWidget {
  final String date;
  final User user;
  final double credit;
  final double debit;
  final String particular;
  final int indexOfTransaction;
  final Function addFunction;
  final TransactionService _transactionService =
      TransactionService.getTransactionServiceInstance;

  DetailsListItem({
    this.date,
    this.user,
    this.addFunction,
    this.particular,
    this.credit,
    this.debit,
    this.indexOfTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      margin: const EdgeInsets.only(top: 7, left: 7, right: 7),
      child: ListTile(
        title: PopupMenuButton<String>(
            offset: Offset(350, 10),
            onSelected: (String value) => _handlePopMenuAction(context, value),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(date),
                  Text(particular),
                  Text('${credit.toString()} ₹'),
                  Text('${debit.toString()} ₹')
                ]),
            itemBuilder: (context) {
              return ['Edit', 'Delete'].map((operation) {
                return PopupMenuItem(
                    value: operation,
                    child: Row(
                      children: [
                        operation == 'Edit'
                            ? Icon(Icons.edit, color: AppTheme.creditColor)
                            : Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                        Text(operation)
                      ],
                    ));
              }).toList();
            }),
      ),
    );
  }

  //Handle actions
  _handlePopMenuAction(BuildContext context, String value) {
    if (value == 'Edit') {
      showDialog(
          context: context,
          child: AddTransactionDialog(
            operationType: 'edit',
            addFunction: this.addFunction,
            credit: credit,
            debit: debit,
            date: date,
            user: this.user,
            indexOfTransaction: indexOfTransaction,
            particular: particular,
          ));
    }
    //So the action is to delete
    else {
      this.user.transactionList.removeAt(this.indexOfTransaction);
      _transactionService
          .addAndUpdateuserTransactionsList(
              docId: this.user.userID,
              newTransactionList: this.user.getMappedTransactionList,
              operationType: 'delete')
          .then(_showToast);
    }
  }

  _showToast(String message) => Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.green,
      fontSize: 16.0);
}
