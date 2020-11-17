import 'package:flutter_bloc/flutter_bloc.dart';

class RebuildFixer extends Cubit<bool> {
  RebuildFixer(state) : super(state);

  //Rebuild UI Forcely
  rebuildUiForcely(bool val) {
    emit(val);
  }
}
