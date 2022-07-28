import 'package:flutter/material.dart';

class CustomDatePickerFormField extends StatelessWidget {
  const CustomDatePickerFormField({
    Key? key,
  required TextEditingController controller,
    required String labelText,
    required VoidCallback callback,
  }) : _controller = controller,
        _labelText = labelText,
        _callback = callback,
        super(key: key);

  final TextEditingController _controller;
  final String _labelText;
  final VoidCallback _callback;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: _labelText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$_labelText cannot be empty';
        }
        return null;
      },
      onTap: _callback,
    );
  }
}
