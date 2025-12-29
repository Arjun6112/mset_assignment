import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pull_request.dart';

class GitHubApiService {
  // Using this repository as an example - replace with actual assignment repo
  static const String owner = 'flutter';
  static const String repo = 'flutter';
  static const String baseUrl = 'https://api.github.com';

  // Fetch open pull requests
  Future<List<PullRequest>> fetchPullRequests() async {
    try {
      final url = Uri.parse('$baseUrl/repos/$owner/$repo/pulls?state=open');

      final response = await http.get(
        url,
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => PullRequest.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        throw Exception('API rate limit exceeded. Please try again later.');
      } else if (response.statusCode == 404) {
        throw Exception('Repository not found.');
      } else {
        throw Exception('Failed to load pull requests: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: Failed to connect to GitHub API');
    }
  }

  // Update repository configuration
  void updateRepository(String newOwner, String newRepo) {
    // This could be used to make the app configurable
    // For now, using hardcoded values
  }
}
