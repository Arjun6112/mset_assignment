import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pull_request.dart';

class PullRequestCard extends StatelessWidget {
  final PullRequest pullRequest;

  const PullRequestCard({super.key, required this.pullRequest});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return DateFormat('MMM d, yyyy').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  Color _getStateColor() {
    switch (pullRequest.state.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStateIcon() {
    switch (pullRequest.state.toLowerCase()) {
      case 'open':
        return Icons.merge_type;
      case 'closed':
        return Icons.close;
      default:
        return Icons.help_outline;
    }
  }

  String _getStateText() {
    return pullRequest.state[0].toUpperCase() + pullRequest.state.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label:
          'Pull request #${pullRequest.number}: ${pullRequest.title}, '
          'by ${pullRequest.authorUsername}, '
          'created ${_formatDate(pullRequest.createdAt)}, '
          'state: ${_getStateText()}',
      button: true,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            // Could open PR in browser or show details
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'PR #${pullRequest.number}: ${pullRequest.title}',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with author info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        pullRequest.authorAvatarUrl,
                      ),
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pullRequest.authorUsername,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _formatDate(pullRequest.createdAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Text(
                        '#${pullRequest.number}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  pullRequest.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Body/Description
                if (pullRequest.body != null &&
                    pullRequest.body!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    pullRequest.body!,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 12),

                // Footer with state
                Row(
                  children: [
                    Icon(_getStateIcon(), size: 16, color: _getStateColor()),
                    const SizedBox(width: 4),
                    Text(
                      _getStateText(),
                      style: TextStyle(
                        color: _getStateColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
