import 'package:hive/hive.dart';
part 'user_account_hive_model.g.dart';

@HiveType(typeId: 2)
class UserAccountHiveModel extends HiveObject {

  @HiveField(0)
  String userId;

  @HiveField(1)
  double balance;

  @HiveField(2)
  String? activePlanId;

  @HiveField(3)
  DateTime? subscriptionStartDate;

  @HiveField(4)
  int? subscriptionDays;

  UserAccountHiveModel({
    required this.userId,
    required this.balance,
    required this.activePlanId,
    this.subscriptionStartDate,
    this.subscriptionDays,
  });
}