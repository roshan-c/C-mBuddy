import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For time ago formatting
import 'package:rebeal/model/post.module.dart';
import 'package:rebeal/styles/color.dart'; // For ReBeal colors if needed

class FeedPostWidget extends StatefulWidget {
  final LogModel logModel;
  const FeedPostWidget({required this.logModel, super.key});

  @override
  State<FeedPostWidget> createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget> {
  // Removed switcher logic

  String _formatTimeAgo(String createdAtStr) {
    try {
      DateTime createdAt = DateTime.parse(createdAtStr);
      Duration difference = DateTime.now().difference(createdAt);

      if (difference.inDays > 7) {
        return DateFormat('MMM d, yyyy').format(createdAt);
      } else if (difference.inDays >= 1) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return "Invalid date";
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[400]),
          SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          Expanded(child: Text(value, style: TextStyle(color: Colors.white, fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.logModel.user;
    final timeAgo = _formatTimeAgo(widget.logModel.createdAt);
    final userLocation = user?.localisation?.isNotEmpty == true ? " • ${user!.localisation}" : "";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: ReBealColor.ReBealDarkGrey, // Using a color from the app's theme
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: user?.profilePic != null && user!.profilePic!.isNotEmpty
                    ? CachedNetworkImageProvider(user.profilePic!)
                    : null,
                child: user?.profilePic == null || user!.profilePic!.isEmpty
                    ? Icon(Icons.person, size: 20)
                    : null,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? "Anonymous",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '$timeAgo$userLocation',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Icon(Icons.more_horiz, color: Colors.white), // Optional: for future actions menu
            ],
          ),
          SizedBox(height: 12),

          // Body: Log Details
          if (widget.logModel.notes != null && widget.logModel.notes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.logModel.notes!,
                style: TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
              ),
            ),
          
          Divider(color: Colors.grey[700], height: 16),

          _buildDetailRow(Icons.star_outline, "Intensity", "${widget.logModel.intensity_rating ?? '-'}/5"),
          _buildDetailRow(Icons.timer_outlined, "Duration", widget.logModel.duration_minutes != null ? "${widget.logModel.duration_minutes} mins" : null),
          _buildDetailRow(Icons.location_on_outlined, "Location", widget.logModel.location),
          if (widget.logModel.was_partner_involved ?? false)
             _buildDetailRow(Icons.people_outline, "Partner Involved", "Yes"),

          // TODO: Add custom tags display if that becomes part of LogModel and UI

          SizedBox(height: 8),
          // Footer: Actions (e.g., edit, delete - for future implementation)
          // For now, no interactive footer elements from original PostModel (comments/likes)
        ],
      ),
    );
  }
}
