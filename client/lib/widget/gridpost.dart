import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:rebeal/model/post.module.dart';

class GridPostWidget extends StatefulWidget {
  final LogModel logModel;
  const GridPostWidget({required this.logModel, super.key});

  @override
  State<GridPostWidget> createState() => _GridPostWidgetState();
}

class _GridPostWidgetState extends State<GridPostWidget> {
  // Removed switcher and switcherFunc

  @override
  Widget build(BuildContext context) {
    String formattedDate = "Date N/A";
    if (widget.logModel.createdAt.isNotEmpty) {
      try {
        DateTime parsedDate = DateTime.parse(widget.logModel.createdAt);
        formattedDate = DateFormat('MM/dd').format(parsedDate);
      } catch (e) {
        // Handle parsing error if necessary, for now, keeps "Date N/A"
      }
    }

    String displayName = widget.logModel.user?.displayName ?? "User";
    String intensityRating = widget.logModel.intensity_rating?.toString() ?? "-";

    return Card(
      color: Colors.grey[850], // Dark grey background for the card
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayName,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.grey[400], fontSize: 10),
                ),
              ],
            ),
            Spacer(), // Pushes intensity to the center
            Center(
              child: Text(
                '$intensityRating/5',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(), // Pushes notes to the bottom (if any, or maintains spacing)
            // Optionally, add a snippet of notes if space allows and it's desired
            // For example:
            // Text(
            //   widget.logModel.notes ?? '',
            //   style: TextStyle(color: Colors.grey[300], fontSize: 10),
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            // ),
          ],
        ),
      ),
    );
  }
}
