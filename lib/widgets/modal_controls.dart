import 'package:flutter/material.dart';

class ModalControls extends StatelessWidget {
  const ModalControls({
    super.key,
    required this.onConfirm,
  });

  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
          onPressed: Navigator.of(context).pop,
          style: TextButton.styleFrom(
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: onConfirm,
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            "Save",
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
