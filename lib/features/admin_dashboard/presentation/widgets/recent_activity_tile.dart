import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../data/models/recent_activity_model.dart';

class RecentActivityTile extends StatelessWidget {
  final RecentActivityModel activity;

  const RecentActivityTile({super.key, required this.activity});

  IconData _iconForType(String type) {
    switch (type) {
      case 'premium_granted':
        return Icons.star;
      case 'report_resolved':
        return Icons.check_circle;
      case 'resource_uploaded':
        return Icons.upload_file;
      default:
        return Icons.info_outline;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.surface,
        child: Icon(
          _iconForType(activity.type),
          color: AppColors.primary,
          size: 18,
        ),
      ),
      title: Text(activity.description, style: AppTextStyles.bodyMedium),
      trailing: Text(_timeAgo(activity.timestamp), style: AppTextStyles.bodySmall),
    );
  }
}
