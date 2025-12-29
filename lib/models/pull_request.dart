class PullRequest {
  final int id;
  final int number;
  final String title;
  final String? body;
  final String authorUsername;
  final String authorAvatarUrl;
  final DateTime createdAt;
  final String htmlUrl;
  final String state;

  PullRequest({
    required this.id,
    required this.number,
    required this.title,
    this.body,
    required this.authorUsername,
    required this.authorAvatarUrl,
    required this.createdAt,
    required this.htmlUrl,
    required this.state,
  });

  factory PullRequest.fromJson(Map<String, dynamic> json) {
    return PullRequest(
      id: json['id'] as int,
      number: json['number'] as int,
      title: json['title'] as String,
      body: json['body'] as String?,
      authorUsername: json['user']['login'] as String,
      authorAvatarUrl: json['user']['avatar_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      htmlUrl: json['html_url'] as String,
      state: json['state'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'body': body,
      'user': {'login': authorUsername, 'avatar_url': authorAvatarUrl},
      'created_at': createdAt.toIso8601String(),
      'html_url': htmlUrl,
      'state': state,
    };
  }
}
