import 'package:flutter/material.dart';
import '../models/pull_request.dart';
import '../services/github_api_service.dart';

enum PullRequestStatus { initial, loading, loaded, error }

class PullRequestProvider with ChangeNotifier {
  final GitHubApiService _apiService = GitHubApiService();

  List<PullRequest> _pullRequests = [];
  PullRequestStatus _status = PullRequestStatus.initial;
  String? _errorMessage;

  List<PullRequest> get pullRequests => _pullRequests;
  PullRequestStatus get status => _status;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == PullRequestStatus.loading;
  bool get hasError => _status == PullRequestStatus.error;
  bool get hasData => _status == PullRequestStatus.loaded;

  Future<void> fetchPullRequests() async {
    _status = PullRequestStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _pullRequests = await _apiService.fetchPullRequests();
      _status = PullRequestStatus.loaded;
      _errorMessage = null;
    } catch (e) {
      _status = PullRequestStatus.error;
      _errorMessage = e.toString();
      _pullRequests = [];
    }

    notifyListeners();
  }

  Future<void> refresh() async {
    await fetchPullRequests();
  }

  void retry() {
    fetchPullRequests();
  }
}
