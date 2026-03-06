import 'package:flutter/material.dart';

class AttachmentTile extends StatelessWidget {

  final String file;

  const AttachmentTile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_file),
          const SizedBox(width: 8),
          Expanded(child: Text(file)),
        ],
      ),
    );
  }
}