import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

Future reportView(lists) async {
  print("inside pdf");
  final Document pdf = Document();
  print(lists);
  //
  Widget contentTable(Context context) {
    const tableHeaders = [
      'Transaction date',
      'Particular',
      'Credit',
      'Debit',
    ];
    print("lists.length");
    return Table.fromTextArray(
      border: null,
      cellAlignment: Alignment.centerLeft,
      headerDecoration: BoxDecoration(
        borderRadius: 2,
        // color: Colors.red,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
        3: Alignment.center,
        4: Alignment.centerRight,
      },
      headerStyle: TextStyle(
        // color: _baseTextColor,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      cellStyle: const TextStyle(
        // color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: BoxDecoration(
        border: BoxBorder(
          bottom: true,
          // color: accentColor,
          width: .5,
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        lists.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => lists[row][col],
        ),
      ),
    );
  }

  pdf.addPage(MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                    BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Text('Report',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
            Header(
                level: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Account Manager', textScaleFactor: 2),
                    ])),
            // // Header(level: 1, text: 'Bill'),
            // Text("Ship To : $name"),
            // Paragraph(text: address),
            // Padding(padding: const EdgeInsets.all(10)),
            // Expanded(
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Container(
            //         alignment: Alignment.topRight,
            //         padding: const EdgeInsets.only(bottom: 8, left: 30),
            //         height: 72,
            //         child: PdfLogo(),
            //       ),
            //       // Container(
            //       //   color: baseColor,
            //       //   padding: pw.EdgeInsets.only(top: 3),
            //       // ),
            //     ],
            //   ),
            // ),
            // Table.fromTextArray(context: context, data: [list]),
            contentTable(context),
            // Text(" Total amount : $total ( $paymentStatus)")
            // for (var i = 0; i <= lists.length; i++) Text(lists[i].toString()),
          ]));
  //save PDF
  // final bytes = pdf.save();
  // final blob = html.Blob([bytes], 'application/pdf');
  // final url = html.Url.createObjectUrlFromBlob(blob);
  // final anchor = html.document.createElement('a') as html.AnchorElement
  //   ..href = url
  //   ..style.display = 'none'
  //   ..download = 'account.pdf';
  // html.document.body.children.add(anchor);
  // anchor.click();
  // html.document.body.children.remove(anchor);
  // html.Url.revokeObjectUrl(url);
  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/account.pdf';
  final File file = File(path);
  // List<int> bytes = pdf.save();
  // await file.writeAsBytes(bytes, flush: true);
  file.writeAsBytes(pdf.save());

//Open the PDF document in mobile
  OpenFile.open('$dir/account.pdf');

  // await file.writeAsBytes(pdf.save());
//   // return file;
//   // final mainRefernce = FirebaseDatabase.instance.reference().child('Database');
//   // final mainReference = FirebaseDatabase.instance.reference().child('Database');
//   Future getPdfAndUpload() async {
//     var rng = new Random();
//     String randomName = "";
//     for (var i = 0; i < 20; i++) {
//       print(rng.nextInt(100));
//       randomName += rng.nextInt(100).toString();
//     }
//     String fileName = '$randomName.pdf';
//     print(fileName);
//     print('${file.readAsBytesSync()}');

//     // void documentFileUpload(String str) {
//     //   var data = {"PDF": str, "mobile": mobile};
//     //   mainReference.child("Documents").child('pdf').set(data).then((v) {});
//     // }

//     // Future savePdf(List<int> asset, String name) async {
//     //   StorageReference reference = FirebaseStorage.instance.ref().child(name);
//     //   StorageUploadTask uploadTask = reference.putData(asset);
//     //   String url = await (await uploadTask.onComplete).ref.getDownloadURL();
//     //   print(url);
//     //   documentFileUpload(url);
//     //   return url;
//     // }

//     // savePdf(file.readAsBytesSync(), fileName);
//   }

//   getPdfAndUpload();
}
