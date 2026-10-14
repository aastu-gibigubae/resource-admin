class PendingRequestModel {
  final int id;
  final String studentName;
  final String email;
  final String refNumber;
  final String amount;
  final String submittedAt;
  final String status;

  const PendingRequestModel({
    required this.id,
    required this.studentName,
    required this.email,
    required this.refNumber,
    required this.amount,
    required this.submittedAt,
    required this.status,
  });

  // Initials from student name
  String get initials {
    final parts = studentName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return studentName.substring(0, 2).toUpperCase();
  }

  factory PendingRequestModel.fromJson(Map<String, dynamic> json) {
    return PendingRequestModel(
      id: json['id'] as int? ?? 0,
      studentName: json['student_name'] as String? ??
          json['user']?['name'] as String? ?? 'Unknown',
      email: json['email'] as String? ??
          json['user']?['email'] as String? ?? '',
      refNumber: json['ref_number'] as String? ??
          json['transaction_ref'] as String? ?? 'N/A',
      amount: json['amount']?.toString() ?? '0',
      submittedAt: json['submitted_at'] as String? ??
          json['created_at'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
    );
  }

  static List<PendingRequestModel> mockList() => [
        const PendingRequestModel(
          id: 1,
          studentName: 'Abebe Kebede',
          email: 'abebekebede@gmail.com',
          refNumber: 'CBE-TNX-97123',
          amount: '150 ETB',
          submittedAt: 'Today, 09:12 AM',
          status: 'pending',
        ),
        const PendingRequestModel(
          id: 2,
          studentName: 'Sara Ayalew',
          email: 'saraayalew@gmail.com',
          refNumber: 'CBE-TNX-78499',
          amount: '150 ETB',
          submittedAt: 'Today, 04:12 AM',
          status: 'pending',
        ),
      ];
}
