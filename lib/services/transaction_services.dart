import 'transaction_helpers.dart';

class TransactionService with TransactionHelpers {
  static TransactionService _transactionService = TransactionService._();

  //A private constructor
  TransactionService._();

  //Get singleton instance
  static get getTransactionServiceInstance {
    if (_transactionService != null) {
      return _transactionService;
    }
    //Reinitialize the instance
    _transactionService = TransactionService._();
    return _transactionService;
  }
}
