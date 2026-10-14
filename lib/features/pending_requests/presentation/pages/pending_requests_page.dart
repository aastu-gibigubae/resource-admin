import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../admin_dashboard/presentation/widgets/pending_report_tile.dart';
import '../../providers/pending_requests_provider.dart';

class PendingRequestsPage extends ConsumerWidget {
  const PendingRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(pendingRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Reports'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: reportsAsync.when(
        loading: () => const AppLoader(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(pendingRequestsProvider),
        ),
        data: (reports) => reports.isEmpty
            ? const EmptyView(message: 'No pending reports')
            : ListView.separated(
                itemCount: reports.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => PendingReportTile(
                  report: reports[i],
                  onResolve: () => ref
                      .read(pendingRequestsProvider.notifier)
                      .resolveReport(reports[i].id),
                ),
              ),
      ),
    );
  }
}
