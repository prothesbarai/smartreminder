import 'subscription_plan_model.dart';

class SubscriptionPlans {
  static List<SubscriptionPlanModel> all = [
    SubscriptionPlanModel(id: "basic",name: "Basic", days: 7, price: 10),
    SubscriptionPlanModel(id: "standard", name: "Standard", days: 15, price: 25),
    SubscriptionPlanModel(id: "premium", name: "Premium", days: 30, price: 50),
    SubscriptionPlanModel(id: "gold", name: "Gold", days: 180, price: 150),
    SubscriptionPlanModel(id: "diamond", name: "Diamond", days: 365, price: 250),
  ];
}