class RewardResult {
  final bool success;
  final int reward;
  final String rewardType;

  const RewardResult({required this.success, required this.reward, required this.rewardType,});

  factory RewardResult.failed() {
    return const RewardResult(success: false, reward: 0, rewardType: '',);
  }
}