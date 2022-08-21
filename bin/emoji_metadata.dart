// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

const path = '../lib/generated/emoji_metadata.dart';

Future<int> main() async {
  final client = HttpClient();

  final locales = [
    'en',
    'ru',
  ];

  final data = <String, dynamic>{};

  for (final locale in locales) {
    final r = await client
        .getUrl(Uri.parse('https://translations.telegram.org/$locale/emoji'));

    r.headers.add('X-Requested-With', 'XMLHttpRequest');
    await r.flush();
    final response = (await (await r.close())
        .transform<String>(utf8.decoder)
        .transform<Object?>(json.decoder)
        .first) as Map<String, dynamic>;

    data[locale] = response;
  }

  client.close(force: true);

  final file = File('${dirname(Platform.script.path)}/$path');
  final handle = await file.open(mode: FileMode.write);
  await file.writeAsString(toEmojiAtlas(data), flush: true);
  await handle.close();
  print('Done.');
  return 0;
}

String toStringLiteral(String s) {
  return "'${s.codeUnits.map((int codeUnit) => '\\u{${codeUnit.toRadixString(16)}}').join()}'";
}

String toCategoryClass(List<String> emojiList) {
  return '''EmojiCategory(
  emojis: [
${emojiList.map((String emoji) => '    ${toStringLiteral(emoji)}').join(', \n')}
  ],
)''';
}

String toEmojiKeywordVocabulary(List<Map<String, dynamic>> emojiList) {
  return '''EmojiKeywordVocabulary(
  keywords: {
${emojiList.map((keyword) => '''    r${json.encoder.convert(keyword['k'] as String)}: EmojiKeyword(emojis: [
${(keyword['e'] as String).split(' ').map((String emoji) => '    ${toStringLiteral(emoji)}').join(', \n')}
],
)''').join(', \n')}
  
},
)''';
}

String toEmojiAtlas(Map<String, dynamic> data) {
  final emojiList = (data['en']['s']['emojiGroupedList'] as List)
      .cast<Map<String, dynamic>>();

  return '''import 'package:sticker_import/components/types/emoji.dart';

const kEmojiAtlas = EmojiAtlas(
  categories: {
${emojiList.map((emoji) => "    r${json.encoder.convert((emoji['t'] as String).replaceAll('&amp;', '&'))}: ${toCategoryClass((emoji['e'] as String).split(' '))}").join(', \n')}
  },
  keywordVocabularies: {
${data.entries.map((entry) {
    final locale = entry.key;
    final emojiList =
        (entry.value['s']['initKeywords'] as List).cast<Map<String, dynamic>>();
    return "    '$locale': ${toEmojiKeywordVocabulary(emojiList)}";
  }).join(', \n')}
  },
);
''';
}
