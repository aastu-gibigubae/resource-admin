class RecentActivityModel {
  final int id;
  final String type; // 'approval' | 'upload' | 'other'
  final String description;
  final String timeAgo;

  const RecentActivityModel({
    required this.id,
    required this.type,
    required this.description,
    required this.timeAgo,
  });

  static List<RecentActivityModel> mockList() => const [
        RecentActivityModel(
          id: 1,
          type: 'approval',
          description: 'Access approved for Sara Ayalew',
          timeAgo: '10m ago',
        ),
        RecentActivityModel(
          id: 2,
          type: 'upload',
          description: 'New resource uploaded: Data Structures Midterm 2024',
          timeAgo: '50m ago',
        ),
      ];
}
