import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sticker_import/components/ui/emoji/grid.dart';
import 'package:sticker_import/components/ui/emoji/picker.dart';
import 'package:sticker_import/generated/emoji_metadata.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/settings/settings.dart';

class EmojiPickerScreen extends StatefulWidget {
  const EmojiPickerScreen({Key? key}) : super(key: key);

  @override
  State<EmojiPickerScreen> createState() => _EmojiPickerScreenState();
}

class _EmojiPickerScreenState extends State<EmojiPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).choose_emoji),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () async {
              final r = await showSearch(
                context: context,
                delegate: EmojiSearchDelegate(),
              );

              if (!mounted || r == null || r.isEmpty) return;

              // ignore: unawaited_futures
              SettingsStorage.of('activity')
                  .get<String?>('recentEmojis')
                  .then((l) {
                SettingsStorage.of('activity').set<String>(
                  'recentEmojis',
                  jsonEncode(
                    [r]
                        .followedBy(
                            (jsonDecode(l ?? '[]') as List).whereType<String>())
                        .toSet()
                        .toList()
                        .take(35),
                  ),
                );
              });

              Navigator.of(context).pop<String>(r);
            },
          )
        ],
      ),
      body: EmojiPicker(
        onEmojiSelected: (emoji) {
          Navigator.of(context).pop<String>(emoji);
        },
        onBackspacePressed: () {
          Navigator.of(context).pop<String>('');
        },
      ),
    );
  }
}

class EmojiSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return searchEmoji(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return searchEmoji(context, query);
  }
}

Widget searchEmoji(BuildContext context, String query) {
  query = query.toLowerCase().trim();

  if (query.isEmpty) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              S.of(context).emoji_type_to_search,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  final list = kEmojiAtlas.searchEmoji(S.of(context).code, query);

  if (list.isEmpty) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              S.of(context).no_emoji_matches,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  return EmojiGridViewBuilder(
    category: list,
    onEmojiSelected: (emoji) {
      Navigator.of(context).pop<String>(emoji);
    },
  );
}
