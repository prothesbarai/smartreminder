import 'subscription_plan_model.dart';

class SubscriptionPlans {
  static List<SubscriptionPlanModel> all = [
    SubscriptionPlanModel(id: "basic",name: "Basic", days: 7, price: 10),
    SubscriptionPlanModel(id: "standard", name: "Standard", days: 15, price: 25),
    SubscriptionPlanModel(id: "premium", name: "Premium", days: 30, price: 50),
  ];
}