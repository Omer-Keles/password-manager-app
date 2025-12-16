import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInput extends StatelessWidget {
  const PinInput({
    super.key,
    required this.controller,
    required this.label,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: 4,
      autofocus: true,
      keyboardType: TextInputType.number,
      obscureText: true,
      style: const TextStyle(letterSpacing: 12),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: label, counterText: ''),
      onSubmitted: (_) => onSubmitted?.call(),
    );
  }
}
