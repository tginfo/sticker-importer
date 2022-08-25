import 'package:flutter/material.dart';

class EmojiButton extends StatelessWidget {
  const EmojiButton({
    required this.emoji,
    required this.onPressed,
    super.key,
  });
  final String emoji;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24.0, fontFamily: 'AppleColorEmoji'),
      ),
    );
  }
}

class EmojiGridViewBuilder extends StatelessWidget {
  const EmojiGridViewBuilder({
    Key? key,
    required this.category,
    required this.onEmojiSelected,
  }) : super(key: key);

  final List<String> category;
  final void Function(String emoji) onEmojiSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: category.length,
      itemBuilder: (context, index) {
        final emoji = category[index];
        return EmojiButton(
          emoji: emoji,
          onPressed: () => onEmojiSelected(emoji),
        );
      },
    );
  }
}
