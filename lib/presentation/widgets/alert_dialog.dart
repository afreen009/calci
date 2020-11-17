
import 'package:calculator/cubit/rebuild_fixer.dart';
import 'package:calculator/helpers/appTheme.dart';
import 'package:calculator/models/transaction.dart';
import 'package:calculator/models/user_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionDialog extends StatefulWidget {
  final User user;
  final String operationType;
  final Function addFunction;
  final String date;
  final double credit;
  final double debit;
  final String particular;
  final int indexOfTransaction;
  AddTransactionDialog({
    @required this.addFunction,
    this.date,
    this.operationType,
    this.user,
    this.credit,
    this.debit,
    this.particular,
    this.indexOfTransaction,
  })  : assert(user != null),
        assert(addFunction != null);

  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  TextEditingController _amountController;
  TextEditingController _particularController;
  String _currentDate;
  final _formKey = GlobalKey<FormState>();
  String _currentRadioValue;

  @override
  void initState() {
    _amountController = TextEditingController();
    _particularController = TextEditingController();
    _currentDate =
        '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}';
    //CHeck and complete field
    if (widget.date != null &&
        widget.credit != null &&
        widget.debit != null &&
        widget.particular != null &&
        widget.indexOfTransaction != null) {
      _currentRadioValue = widget.credit != 0
          ? widget.credit.toString()
          : widget.debit.toString();

      _currentDate = widget.date;

      _amountController.text = widget.credit != 0
          ? widget.credit.toString()
          : widget.debit.toString();

      _particularController.text = widget.particular;
    }
    _currentRadioValue = 'credit';
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _particularController.dispose();
    _currentRadioValue = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
            onPressed: () => _validateAndAddTransactionHandler(context),
            child: Text('Add')),
        FlatButton(
            onPressed: () => _cancelHandler(context), child: Text('Cancel')),
      ],
      content: Container(
        height: AppTheme.listItemHeight + 150,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FlatButton.icon(
                  onPressed: () => _showDatePicker(context),
                  icon: Icon(Icons.watch_later_outlined),
                  label: Text(_currentDate)),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _amountController,
                validator: (String value) {
                  if (value.isEmpty) return 'Enter an amount';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              TextFormField(
                controller: _particularController,
                validator: (String value) {
                  if (value.isEmpty) return 'Enter a particular name';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Particular',
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Credit(+)'),
                  Radio<String>(
                      value: 'credit',
                      groupValue: _currentRadioValue,
                      onChanged: _chageRadioState),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Debit(-)'),
                  Radio<String>(
                      value: 'debit',
                      groupValue: _currentRadioValue,
                      onChanged: _chageRadioState),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //Show DatePicker
  _showDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2050))
        .then((userDate) => this.setState(() {
              this._currentDate =
                  '${userDate.month}-${userDate.day}-${userDate.year}';
            }));
  }

  //Radio Handler
  void _chageRadioState(String value) => this.setState(() {
        this._currentRadioValue = value;
      });

  //Get and build a transaction Object
  Transaction get _buildAndGetTransactionObject => Transaction(
      transactionDate: _currentDate,
      particular: _particularController.text,
      credit: (_currentRadioValue == 'credit')
          ? double.parse(_amountController.text)
          : 0,
      debit: (_currentRadioValue == 'debit')
          ? double.parse(_amountController.text)
          : 0);

  void _validateAndAddTransactionHandler(BuildContext context) {
    if (this._formKey.currentState.validate()) {
      assert(widget.user != null);
      Transaction _transaction = _buildAndGetTransactionObject;

      if (widget.operationType != null) {
        widget.addFunction(_transaction, widget.user,
            indexOfTransaction: widget.indexOfTransaction,
            operationType: widget.operationType);
      } else {
        widget.addFunction(_transaction, widget.user);
      }
      //Send the transaction object
      BlocProvider.of<RebuildFixer>(context).rebuildUiForcely(true);
      _cancelHandler(context);
    }
  }

  //Cancel handler
  void _cancelHandler(BuildContext context) => Navigator.pop(context);

  // TextFormField(
  //               controller: _dateController,
  //               validator: (String value) {
  //                 if (value.isEmpty) return 'Enter a date';
  //                 return null;
  //               }
}
