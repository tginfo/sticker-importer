import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sticker_import/generated/l10n.dart';

class EmojiPickerScreen extends StatelessWidget {
  const EmojiPickerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).choose_emoji),
      ),
      body: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          Navigator.of(context).pop<String>(emoji.emoji);
        },
        onBackspacePressed: () {
          Navigator.of(context).pop<String>('');
        },
        config: Config(
          columns: 7,
          emojiSizeMax: 32.0,
          verticalSpacing: 0,
          horizontalSpacing: 0,
          initCategory: Category.RECENT,
          bgColor: Theme.of(context).scaffoldBackgroundColor,
          indicatorColor: (isDark
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary),
          iconColor: Colors.grey,
          iconColorSelected: (isDark
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary),
          progressIndicatorColor: (isDark
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary),
          backspaceColor: (isDark
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary),
          showRecentsTab: true,
          recentsLimit: 28,
          noRecentsText: S.of(context).no_recents,
          noRecentsStyle: Theme.of(context).textTheme.subtitle2!,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
      ),
    );
  }
}
