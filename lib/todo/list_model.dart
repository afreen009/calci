import 'package:cloud_firestore/cloud_firestore.dart';

class ListModel {
  String id;
  String transaction;
  String credit;
  String debit;
  String particular;
  ListModel(
      {this.id, this.transaction, this.credit, this.debit, this.particular});

  factory ListModel.fromJson(DocumentSnapshot json) => ListModel(
        transaction: json.data()['transaction'],
        credit: json.data()['credit'],
        debit: json.data()['debit'],
        particular: json.data()['particular'],
      );

  Map<String, dynamic> toJson() => {
        'transaction': transaction,
        'credit': credit,
        'debit': debit,
        'particular': particular
      };
}
