import 'package:flutter/material.dart';

class EmojiAtlas {
  final String fallbackLocale;
  final Map<String, EmojiCategory> categories;
  final Map<String, EmojiKeywordVocabulary> keywordVocabularies;

  const EmojiAtlas({
    required this.fallbackLocale,
    required this.categories,
    required this.keywordVocabularies,
  });

  bool isEmoji(String str) {
    for (final category in categories.values) {
      if (category.emojis.contains(str)) {
        return true;
      }
    }
    return false;
  }

  List<String> filterEmoji(String str) {
    final chars = str.characters.toList();

    return chars.where((emoji) => isEmoji(emoji)).toList();
  }

  List<String> searchEmoji(String locale, String query) {
    if (!keywordVocabularies.containsKey(locale)) {
      locale = fallbackLocale;
    }

    final keywords = keywordVocabularies[locale]!
        .keywords
        .keys
        .where((keyword) => keyword.startsWith(query));

    final emojis = keywords
        .map(
            (keyword) => keywordVocabularies[locale]!.keywords[keyword]!.emojis)
        .expand((emoji) => emoji)
        .toSet()
        .toList();

    return emojis;
  }
}

class EmojiCategory {
  final List<String> emojis;

  const EmojiCategory({required this.emojis});
}

class EmojiKeywordVocabulary {
  final Map<String, EmojiKeyword> keywords;

  const EmojiKeywordVocabulary({required this.keywords});
}

class EmojiKeyword {
  final List<String> emojis;

  const EmojiKeyword({required this.emojis});
}
