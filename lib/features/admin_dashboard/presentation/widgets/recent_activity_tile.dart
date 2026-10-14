import 'package:flutter/material.dart';
import '../../data/models/recent_activity_model.dart';

class RecentActivityTile extends StatelessWidget {
  final RecentActivityModel activity;

  const RecentActivityTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isUpload = activity.type == 'upload';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(
            isUpload ? Icons.upload_outlined : Icons.check_circle_outline,
            size: 18,
            color: const Color(0xFF888888),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              activity.description,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            activity.timeAgo,
            style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}
