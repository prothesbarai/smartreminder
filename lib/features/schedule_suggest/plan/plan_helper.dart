import 'user_plan.dart';

int getDailyLimit(UserPlan plan) {
  switch (plan) {
    case UserPlan.free:
      return 1;
    case UserPlan.paidBasic:
      return 2;
    case UserPlan.paidPro:
      return 5;
    case UserPlan.paidPremium:
      return 9999;
  }
}