class Transaction {
  double credit, debit;
  String particular;
  String transactionDate;

  Transaction(
      {double credit,
      double debit,
      String particular,
      String transactionDate}) {
    this.credit = credit;
    this.debit = debit;
    this.particular = particular;

    ///Initalisation of the date
    this.transactionDate = transactionDate;

    //Assertion chechings
    assert(credit != null);
    assert(debit != null);
    assert(particular != null);
    assert(transactionDate != null);
  }

  ///To turn a transaction to map format
  Map<String, dynamic> transactionToMap() => {
        'particular': this.particular,
        'credit': this.credit,
        'debit': this.debit,
        'created': this.transactionDate
      };

  ///To turn a map to transaction format
  //  Transaction.mapToTransaction(Map<String, dynamic> data) {
  //   this.particular = data['particular'];
  //   this.credit = data['credit'];
  //   this.debit = data['debit'];
  //   this.transactionDate = data['created'];
  // }
  ///To turn a map to transaction format
  Transaction.mapToTransaction(Map<String, dynamic> data) {
    this.particular = data['particular'];
    this.credit = data['credit'];
    this.debit = data['debit'];
    this.transactionDate = data['created'];
  }
}
