import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required TextEditingController controller,
    required String labelText,
  }) : _controller = controller,
        _labelText = labelText,
        super(key: key);

  final TextEditingController _controller;
  final String _labelText;

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
    );
  }
}
