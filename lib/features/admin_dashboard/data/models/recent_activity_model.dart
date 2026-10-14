class RecentActivityModel {
  final int id;
  final String type;
  final String description;
  final DateTime timestamp;

  const RecentActivityModel({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
  });

  static List<RecentActivityModel> mockList() {
    final now = DateTime.now();
    return [
      RecentActivityModel(
        id: 1,
        type: 'premium_granted',
        description: 'Premium granted to student',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      RecentActivityModel(
        id: 2,
        type: 'report_resolved',
        description: 'Issue report #12 resolved',
        timestamp: now.subtract(const Duration(hours: 5)),
      ),
      RecentActivityModel(
        id: 3,
        type: 'resource_uploaded',
        description: 'Midterm 2024 uploaded to CS dept',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
