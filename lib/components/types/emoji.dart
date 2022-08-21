class EmojiAtlas {
  final Map<String, EmojiCategory> categories;
  final Map<String, EmojiKeywordVocabulary> keywordVocabularies;

  const EmojiAtlas({
    required this.categories,
    required this.keywordVocabularies,
  });
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
