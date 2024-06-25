import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final TextStyle titleTextStyle;
  final TextStyle messageTextStyle;

  const ConfirmDialog({super.key, 
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
    required this.titleTextStyle,
    required this.messageTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: titleTextStyle,),
      content: Text(message, style: messageTextStyle,),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}