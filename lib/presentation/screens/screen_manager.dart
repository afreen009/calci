import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home/home.dart';
import 'loading/loading.dart';
import 'error/error.dart';

class ScreenManager extends StatelessWidget {
  final Future<FirebaseApp> _firebaseApp=Firebase.initializeApp();
  ScreenManager({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseApp,
        builder: (context,snapshot){
              if(snapshot.hasError){
                //Here return the error when the connection failed
                return Error();
              }
              else if (snapshot.connectionState==ConnectionState.done){
                //Here return the ScreenManager when all happen well
                return Home();
              }
              else{
                //Here returning a loader when the connection is waiting
                return Loading();
              }
        },  
      );
  }
}