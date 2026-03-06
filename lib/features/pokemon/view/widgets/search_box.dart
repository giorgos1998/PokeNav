import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController textController;
  final Function(String) onSearchPressed;

  const SearchBox({
    super.key,
    required this.textController,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: textController,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Search pokemon...',
          filled: true,
          fillColor: Colors.grey.withAlpha(60),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            padding: EdgeInsets.zero,
            onPressed: () => onSearchPressed(textController.text),
          ),
        ),
        onSubmitted: (value) => onSearchPressed(textController.text),
      ),
    );
  }
}
