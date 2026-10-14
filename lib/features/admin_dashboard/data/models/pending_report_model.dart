class PendingReportModel {
  final int id;
  final int resourceId;
  final int reporterId;
  final String reason;
  final String? otherText;
  final String status;
  final DateTime createdAt;

  const PendingReportModel({
    required this.id,
    required this.resourceId,
    required this.reporterId,
    required this.reason,
    this.otherText,
    required this.status,
    required this.createdAt,
  });

  factory PendingReportModel.fromJson(Map<String, dynamic> json) =>
      PendingReportModel(
        id: json['id'] as int,
        resourceId: json['resource_id'] as int,
        reporterId: json['reporter_id'] as int,
        reason: json['reason'] as String,
        otherText: json['other_text'] as String?,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  static List<PendingReportModel> listFromJson(List<dynamic> json) =>
      json.map((e) => PendingReportModel.fromJson(e as Map<String, dynamic>)).toList();
}
