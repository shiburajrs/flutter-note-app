import 'package:flutter/material.dart';

import '../utils/text_style_utils.dart';

class DeleteNoteDialog extends StatelessWidget {
  final String noteTitle;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  DeleteNoteDialog({
    required this.noteTitle,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(backgroundColor: Colors.white,
      title: Text(
        'Delete Note',
        style: TextStyles.bold(fontSize: 16, color: Colors.red),
      ),
      content: Text(
        'Are you sure you want to delete the note "$noteTitle"? This action cannot be undone.',
        style: TextStyles.regular(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: TextStyles.medium(fontSize: 12, color: Colors.grey.withOpacity(0.8)),
          ),
        ),
        InkWell(onTap: () => onDelete(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.red,),
            child: Text(
              'Delete',
              style:  TextStyles.medium(fontSize: 12, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
