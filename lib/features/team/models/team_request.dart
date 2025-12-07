class TeamRequest {
  final String id;
  final String requesterId;
  final String requesterName;
  final String hackathonId;
  final String hackathonName;
  final String title;
  final String description;
  final List<String> requiredSkills;
  final int teamSize;
  final DateTime createdAt;
  final bool isActive;

  TeamRequest({
    required this.id,
    required this.requesterId,
    required this.requesterName,
    required this.hackathonId,
    required this.hackathonName,
    required this.title,
    required this.description,
    required this.requiredSkills,
    required this.teamSize,
    required this.createdAt,
    this.isActive = true,
  });

  factory TeamRequest.fromMap(String id, Map<String, dynamic> data) {
    return TeamRequest(
      id: id,
      requesterId: data['requesterId'] ?? '',
      requesterName: data['requesterName'] ?? '',
      hackathonId: data['hackathonId'] ?? '',
      hackathonName: data['hackathonName'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      teamSize: data['teamSize'] ?? 2,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requesterId': requesterId,
      'requesterName': requesterName,
      'hackathonId': hackathonId,
      'hackathonName': hackathonName,
      'title': title,
      'description': description,
      'requiredSkills': requiredSkills,
      'teamSize': teamSize,
      'createdAt': createdAt,
      'isActive': isActive,
    };
  }

  TeamRequest copyWith({
    String? id,
    String? requesterId,
    String? requesterName,
    String? hackathonId,
    String? hackathonName,
    String? title,
    String? description,
    List<String>? requiredSkills,
    int? teamSize,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return TeamRequest(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      hackathonId: hackathonId ?? this.hackathonId,
      hackathonName: hackathonName ?? this.hackathonName,
      title: title ?? this.title,
      description: description ?? this.description,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      teamSize: teamSize ?? this.teamSize,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
