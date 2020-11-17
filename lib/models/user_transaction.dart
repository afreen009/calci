import 'transaction.dart';

class User {
  String userID; //Represent the docID
  String name; // Here is store the nalme of the user
  String userCreationDate;
  List<dynamic> transactionList;

  User({name, transactionList}) {
    this.name = name;
    this.transactionList = transactionList;

    //Initialisation of the date
    userCreationDate = DateTime.now().toString();
    //Assertion chechings
    assert(name != null);
    assert(transactionList != null);
    assert(userCreationDate != null);
  }

  //Turn a user to map
  Map<String, dynamic> userToMap() => {
        'name': this.name,
        'created': this.userCreationDate.toString(),
        'transactionList': getMappedTransactionList
      };

  //Calculate credit total amount
  double get calculateCreditAmount {
    double creditAmount = 0;

    transactionList.forEach((transaction) {
      creditAmount += transaction.credit;
    });
    return creditAmount;
  }

  //Calculate debit total amount
  double get calculateDebitAmount {
    double debitAmount = 0;

    //Calculation
    transactionList.forEach((transaction) {
      debitAmount += transaction.debit;
    });
    return debitAmount;
  }

  //Calulate balance amount
  double get calculateBalanceAmount =>
      calculateCreditAmount - calculateDebitAmount;

  //Update transaction
  void updateTransactionList(
      {int index, double credit, double debit, String particular}) {
    transactionList[index].credit = credit;
    transactionList[index].debit = debit;
    transactionList[index].particular = particular;
  }

  //Turn Document SNaphot to User
  User.fromDocumentSnaphot(String docId, Map<String, dynamic> data) {
    this.userID = docId;
    this.name = data['name'];
    this.userCreationDate = data['created'];
    //Loop through data to create transaction List
    if (data['transactionList'].length != 0) {
      this.transactionList = data['transactionList'].map((transaction) {
        print(transaction);
        return Transaction.mapToTransaction(transaction);
      }).toList();
    } else {
      this.transactionList = [];
    }
  }

  //Turn List of transaction to map for storage
  List<dynamic> get getMappedTransactionList => this
      .transactionList
      .map((transaction) => transaction.transactionToMap())
      .toList();
}
