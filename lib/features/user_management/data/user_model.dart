class UserModel {
  final int id;
  final String name;
  final String email;
  final String faculty;
  final String year;
  final String premiumStatus; // 'Active', 'Inactive', 'Expired'
  final String deviceFingerprint;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.faculty,
    required this.year,
    required this.premiumStatus,
    required this.deviceFingerprint,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? json['full_name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        faculty: json['faculty'] as String? ?? json['department'] as String? ?? '',
        year: json['year'] as String? ?? '1st Year',
        premiumStatus: json['premium_status'] as String? ??
            (json['is_active'] == true ? 'Active' : 'Inactive'),
        deviceFingerprint: json['device_fingerprint'] as String? ?? '',
      );

  static List<UserModel> mockList() => const [
        UserModel(
          id: 1,
          name: 'Robel Alex',
          email: 'robelalex@gmail.com',
          faculty: 'Engineering',
          year: '1st Year',
          premiumStatus: 'Active',
          deviceFingerprint: 'a128hsuxh838s098k',
        ),
        UserModel(
          id: 2,
          name: 'Natan Ayalew',
          email: 'natanayalew@gmail.com',
          faculty: 'Applied Science',
          year: '1st Year',
          premiumStatus: 'Active',
          deviceFingerprint: 'e458hsuxh838s098k',
        ),
        UserModel(
          id: 3,
          name: 'Kidist Abebe',
          email: 'kidistabebe@gmail.com',
          faculty: 'Applied Science',
          year: '1st Year',
          premiumStatus: 'Expired',
          deviceFingerprint: 'R568hsuxh838s098k',
        ),
      ];
}
