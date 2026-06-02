import 'package:smartreminder/core/service/hive_service.dart';
import '../models/user_account_hive_model.dart';

class UserAccountService {

  static final box = HiveService.userAccountBox;
  static const String key = "main_user";

  static UserAccountHiveModel getAccount() {
    final data = box.get(key);
    if (data == null) {
      final newUser = UserAccountHiveModel(userId: DateTime.now().millisecondsSinceEpoch.toString(), balance: 0.0, plan: 'free',);
      box.put(key, newUser);
      return newUser;
    }
    return data;
  }

  static void update(UserAccountHiveModel user) {
    box.put(key, user);
  }

  static void addBalance(double amount) {
    final user = getAccount();
    user.balance += amount;
    user.save();
  }

  static bool deductBalance(double amount) {
    final user = getAccount();
    if (user.balance < amount) return false;
    user.balance -= amount;
    user.save();
    return true;
  }

  static void updatePlan(String plan) {
    final user = getAccount();
    user.plan = plan;
    user.save();
  }
}