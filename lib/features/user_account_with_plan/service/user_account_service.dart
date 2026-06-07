import 'package:flutter/cupertino.dart';
import 'package:smartreminder/core/service/hive_service.dart';
import '../models/user_account_hive_model.dart';

class UserAccountService {

  static final box = HiveService.userAccountBox;
  static const String key = "main_user";
  static final ValueNotifier<UserAccountHiveModel> notifier = ValueNotifier(getAccount());

  /// >>> Get or create user
  static UserAccountHiveModel getAccount() {
    final data = box.get(key);

    if (data == null) {
      final newUser = UserAccountHiveModel(
        userId: DateTime.now().millisecondsSinceEpoch.toString(),
        coinBalance: 0.0,
        activePlanId: null,
        subscriptionStartDate: null,
        subscriptionDays: null,
      );

      box.put(key, newUser);
      return newUser;
    }

    return data;
  }

  /// >>> Save user
  static void update(UserAccountHiveModel user) {
    box.put(key, user);
    notifier.value = user;
  }

  /// >>> Add balance
  static void addBalance(double amount) {
    final user = getAccount();
    user.coinBalance += amount;
    user.save();
    notifier.value = user;
  }

  /// >>> Deduct balance
  static bool deductBalance(double amount) {
    final user = getAccount();
    if (user.coinBalance < amount) return false;

    user.coinBalance -= amount;
    user.save();
    notifier.value = user;
    return true;
  }

  /// >>> Clear subscription (optional helper)
  static void clearSubscription() {
    final user = getAccount();

    user.activePlanId = null;
    user.subscriptionStartDate = null;
    user.subscriptionDays = null;

    user.save();
    notifier.value = user;
  }
}