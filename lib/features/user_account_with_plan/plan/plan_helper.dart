import 'user_plan.dart';

int getDailyLimit(UserPlan plan) {
  switch (plan) {
    case UserPlan.free:
      return 1;
    case UserPlan.paid:
      return 2;
  }
}