import 'package:flutter/material.dart';
import '../../data/models/pending_report_model.dart';
import '../../../../../core/widgets/app_button.dart';

class PendingReportTile extends StatelessWidget {
  final PendingReportModel report;
  final VoidCallback onResolve;
  final bool isResolving;

  const PendingReportTile({
    super.key,
    required this.report,
    required this.onResolve,
    this.isResolving = false,
  });

  IconData _iconForReason(String reason) {
    switch (reason) {
      case 'broken_file':
        return Icons.broken_image;
      case 'wrong_file':
        return Icons.description;
      case 'incorrect_category':
        return Icons.category;
      case 'poor_quality':
        return Icons.star_border;
      default:
        return Icons.report;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    final readable = text.replaceAll('_', ' ');
    return readable[0].toUpperCase() + readable.substring(1);
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
      leading: Icon(_iconForReason(report.reason)),
      title: Text(_capitalize(report.reason)),
      subtitle: Text(
        'Resource #${report.resourceId} • ${_timeAgo(report.createdAt)}',
      ),
      trailing: AppButton(
        label: 'Resolve',
        onPressed: isResolving ? null : onResolve,
        isLoading: isResolving,
        isFullWidth: false,
      ),
    );
  }
}
