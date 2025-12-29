import 'package:flutter_test/flutter_test.dart';
import 'package:mset_assignment/models/pull_request.dart';

void main() {
  group('PullRequest Model Tests', () {
    test('should create PullRequest from JSON', () {
      final json = {
        'id': 123456,
        'number': 42,
        'title': 'Test PR',
        'body': 'This is a test PR description',
        'user': {
          'login': 'testuser',
          'avatar_url': 'https://example.com/avatar.png',
        },
        'created_at': '2025-01-01T12:00:00Z',
        'html_url': 'https://github.com/test/repo/pull/42',
        'state': 'open',
      };

      final pr = PullRequest.fromJson(json);

      expect(pr.id, 123456);
      expect(pr.number, 42);
      expect(pr.title, 'Test PR');
      expect(pr.body, 'This is a test PR description');
      expect(pr.authorUsername, 'testuser');
      expect(pr.authorAvatarUrl, 'https://example.com/avatar.png');
      expect(pr.state, 'open');
      expect(pr.htmlUrl, 'https://github.com/test/repo/pull/42');
    });

    test('should handle null body in JSON', () {
      final json = {
        'id': 123456,
        'number': 42,
        'title': 'Test PR',
        'body': null,
        'user': {
          'login': 'testuser',
          'avatar_url': 'https://example.com/avatar.png',
        },
        'created_at': '2025-01-01T12:00:00Z',
        'html_url': 'https://github.com/test/repo/pull/42',
        'state': 'open',
      };

      final pr = PullRequest.fromJson(json);

      expect(pr.body, null);
    });

    test('should convert PullRequest to JSON', () {
      final pr = PullRequest(
        id: 123456,
        number: 42,
        title: 'Test PR',
        body: 'Test body',
        authorUsername: 'testuser',
        authorAvatarUrl: 'https://example.com/avatar.png',
        createdAt: DateTime.parse('2025-01-01T12:00:00Z'),
        htmlUrl: 'https://github.com/test/repo/pull/42',
        state: 'open',
      );

      final json = pr.toJson();

      expect(json['id'], 123456);
      expect(json['number'], 42);
      expect(json['title'], 'Test PR');
      expect(json['body'], 'Test body');
      expect(json['user']['login'], 'testuser');
      expect(json['state'], 'open');
    });
  });
}
