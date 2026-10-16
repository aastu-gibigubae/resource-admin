import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../admin_dashboard/data/models/pending_request_model.dart';
import '../../providers/pending_requests_provider.dart';

const _navy = Color(0xFF0D2B6E);
const _amber = Color(0xFFF9A825);
const _greenDark = Color(0xFF2E7D32);
const _redOutline = Color(0xFFD32F2F);
const _avatarBg = Color(0xFFE8EAF6);
const _cardBorder = Color(0xFFE0E0E0);

class PendingRequestsPage extends ConsumerWidget {
  const PendingRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pendingRequestsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Pending Payment Requests',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        titleSpacing: 0,
      ),
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: _navy),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(pendingRequestsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (requests) => requests.isEmpty
            ? const Center(
                child: Text(
                  'No pending payment requests',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: requests.length,
                itemBuilder: (context, i) => _PendingCard(
                  request: requests[i],
                  onApprove: () => ref
                      .read(pendingRequestsProvider.notifier)
                      .approveRequest(requests[i].id),
                  onReject: () => ref
                      .read(pendingRequestsProvider.notifier)
                      .rejectRequest(requests[i].id),
                ),
              ),
      ),
    );
  }
}

// ─── Pending request card ─────────────────────────────────────────────────────

class _PendingCard extends StatefulWidget {
  final PendingRequestModel request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _PendingCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<_PendingCard> createState() => _PendingCardState();
}

class _PendingCardState extends State<_PendingCard> {
  bool _approving = false;
  bool _rejecting = false;

  @override
  Widget build(BuildContext context) {
    final busy = _approving || _rejecting;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: avatar + name/email + pending badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Initials avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _avatarBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    widget.request.initials,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _navy,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Name + email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.request.studentName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _navy,
                      ),
                    ),
                    Text(
                      widget.request.email,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF777777)),
                    ),
                  ],
                ),
              ),
              // Pending badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: _amber),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(
                    fontSize: 11,
                    color: _amber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Ref: ${widget.request.refNumber}  •  Amount: ${widget.request.amount}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
          ),
          const SizedBox(height: 2),
          Text(
            'Submitted: ${widget.request.submittedAt}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
          ),

          const SizedBox(height: 12),

          // Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: OutlinedButton(
                    onPressed: busy
                        ? null
                        : () async {
                            setState(() => _approving = true);
                            widget.onApprove();
                            if (mounted) setState(() => _approving = false);
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _greenDark,
                      side: const BorderSide(color: _greenDark),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.zero,
                    ),
                    child: _approving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: _greenDark))
                        : const Text('Approve Access',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: OutlinedButton(
                    onPressed: busy
                        ? null
                        : () async {
                            setState(() => _rejecting = true);
                            widget.onReject();
                            if (mounted) setState(() => _rejecting = false);
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _redOutline,
                      side: const BorderSide(color: _redOutline),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.zero,
                    ),
                    child: _rejecting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: _redOutline))
                        : const Text('Reject',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
