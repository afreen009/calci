
import 'package:calculator/models/transaction.dart';
import 'package:calculator/models/user_transaction.dart';
import 'package:calculator/services/transaction_services.dart';
import 'package:flutter/material.dart';

class UserCreateAlert extends StatefulWidget {
  final TransactionService _transactionService =
      TransactionService.getTransactionServiceInstance;
  @override
  _UserCreateAlertState createState() => _UserCreateAlertState();
}

class _UserCreateAlertState extends State<UserCreateAlert> {
  TextEditingController _usernameController;

  @override
  initState() {
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(labelText: 'Name'),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Enter a name for the user';
          }
          return null;
        },
      ),
      actions: [
        FlatButton(
            onPressed: _validateNameAndCreateUserField, child: Text('Add')),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel'))
      ],
    );
  }

  _validateNameAndCreateUserField() {
    if (_usernameController.text.isNotEmpty) {
      User _user = User(name: _usernameController.text, transactionList: <Transaction>[]);
      widget._transactionService.createAUser(userData: _user.userToMap());
      Navigator.pop(context);
    }
  }
}
