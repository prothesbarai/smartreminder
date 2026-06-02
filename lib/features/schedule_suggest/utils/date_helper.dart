String getDateTitle(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day,);
  final itemDate = DateTime(date.year, date.month, date.day,);
  final difference = itemDate.difference(today).inDays;
  if (difference == 0) {return "Today";}
  if (difference == -1) {return "Yesterday";}
  if (difference == 1) {return "Tomorrow";}
  return "${date.day}/${date.month}/${date.year}";
}