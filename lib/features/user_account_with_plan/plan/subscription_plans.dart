import 'subscription_plan_model.dart';

class SubscriptionPlans {
  static List<SubscriptionPlanModel> all = [
    SubscriptionPlanModel(id: "basic",name: "Basic", days: 2, price: 30),
    SubscriptionPlanModel(id: "standard", name: "Standard", days: 7, price: 260),
    SubscriptionPlanModel(id: "premium", name: "Premium", days: 15, price: 480),
    SubscriptionPlanModel(id: "gold", name: "Gold", days: 30, price: 890),
    SubscriptionPlanModel(id: "diamond", name: "Diamond", days: 180, price: 1600),
    SubscriptionPlanModel(id: "platinum", name: "Platinum", days: 360, price: 3000),
  ];
}