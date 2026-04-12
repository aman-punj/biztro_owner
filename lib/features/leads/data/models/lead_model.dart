class LeadModel {
  const LeadModel({
    required this.userId,
    required this.userName,
    this.mobileNo,
    this.leadDate,
    this.city,
    this.leadStatus,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      userId: json['UserId'] as int? ?? 0,
      userName: json['UserName'] as String? ?? 'Unknown',
      mobileNo: json['MobileNo'] as String?,
      leadDate: json['LeadDate'] as String?,
      city: json['City'] as String?,
      leadStatus: json['LeadStatus'] as String?,
    );
  }

  final int userId;
  final String userName;
  final String? mobileNo;
  final String? leadDate;
  final String? city;
  final String? leadStatus;
}
