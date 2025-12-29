import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/pull_request_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/pull_request_card.dart';
import '../widgets/pull_request_shimmer.dart';

class PullRequestListScreen extends StatefulWidget {
  const PullRequestListScreen({super.key});

  @override
  State<PullRequestListScreen> createState() => _PullRequestListScreenState();
}

class _PullRequestListScreenState extends State<PullRequestListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Fetch pull requests on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PullRequestProvider>().fetchPullRequests();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await context.read<PullRequestProvider>().refresh();
  }

  void _handleRetry() {
    context.read<PullRequestProvider>().retry();
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pop();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _toggleTheme() {
    context.read<ThemeProvider>().toggleTheme();

    _animationController.forward(from: 0.0);
  }

  void _showTokenInfo() {
    final token = context.read<AuthProvider>().token;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.vpn_key, size: 24),
            SizedBox(width: 8),
            Text('Stored Token'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Simulated token stored securely:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                token ?? 'No token',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This demonstrates secure token storage using SharedPreferences.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.code),
            SizedBox(width: 4),
            Text('GitHub Pull Requests'),
          ],
        ),
        actions: [
          // Token info button
          IconButton(
            icon: const Icon(Icons.vpn_key),
            tooltip: 'Show Token',
            onPressed: _showTokenInfo,
          ),

          // Theme toggle button
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip: isDark ? 'Light Mode' : 'Dark Mode',
              onPressed: _toggleTheme,
            ),
          ),

          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Consumer<PullRequestProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.pullRequests.isEmpty) {
            return const PullRequestShimmer();
          }

          if (provider.hasError) {
            return _buildErrorState(provider.errorMessage);
          }

          if (provider.pullRequests.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.pullRequests.length,
              itemBuilder: (context, index) {
                final pr = provider.pullRequests[index];
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: PullRequestCard(pullRequest: pr),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Unknown error occurred',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _handleRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Open Pull Requests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'There are no open pull requests at the moment.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
