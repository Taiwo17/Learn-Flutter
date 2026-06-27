import 'package:flutter/material.dart';
import 'package:note_app/components/note_settings.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.text,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final String text;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 10, left: 25, right: 25),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        trailing: Builder(
          builder: (context) => IconButton(
            onPressed: () => showPopover(
              context: context,
              width: 100,
              height: 100,
              backgroundColor: Theme.of(context).colorScheme.surface,
              bodyBuilder: (context) => NoteSettings(
                onEditTap: onEditPressed,
                onDeleteTap: onDeletePressed,
              ),
            ),
            icon: Icon(Icons.more_vert),
          ),
        ),
        // trailing: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     IconButton(
        //       onPressed: onEditPressed,
        //       icon: Icon(
        //         Icons.edit,
        //         color: Theme.of(context).colorScheme.inversePrimary,
        //       ),
        //     ),
        //     IconButton(
        //       onPressed: onDeletePressed,
        //       icon: Icon(
        //         Icons.delete,
        //         color: Theme.of(context).colorScheme.inversePrimary,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
