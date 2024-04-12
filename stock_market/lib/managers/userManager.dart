import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_market/adapter/firebaseAdapter.dart';
import 'package:stock_market/models/myTransaction.dart';
import 'package:stock_market/models/myUser.dart';

class UserManager extends StateNotifier<MyUser> {
  final StateNotifierProviderRef ref;
  final FirebaseAdapter firebaseA = FirebaseAdapter();

  UserManager(this.ref) : super(MyUser.empty() );

  void loadData() async {
    state = await firebaseA.userData();
  }

  bool buy(MyTransaction t) {
    if(state.balance <= 0) {
      return false;
    }
    if(state.balance-t.amount <= 0) {
      return false;
    }



    return true;
  }


}

final userManager = StateNotifierProvider<UserManager,MyUser>((ref) {
  return UserManager(ref);
});