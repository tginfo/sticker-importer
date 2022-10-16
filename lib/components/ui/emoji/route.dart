import 'package:flutter/material.dart';
import 'package:sticker_import/components/ui/emoji/grid.dart';
import 'package:sticker_import/components/ui/emoji/picker.dart';
import 'package:sticker_import/generated/emoji_metadata.dart';
import 'package:sticker_import/generated/l10n.dart';

class EmojiPickerScreen extends StatefulWidget {
  const EmojiPickerScreen({
    required this.emojis,
    required this.placeholder,
    this.singleEmojiMode = false,
    super.key,
  });

  final Set<String> emojis;
  final bool singleEmojiMode;
  final String placeholder;

  @override
  State<EmojiPickerScreen> createState() => _EmojiPickerScreenState();
}

class _EmojiPickerScreenState extends State<EmojiPickerScreen> {
  late Set<String> emojis;

  @override
  void initState() {
    super.initState();

    emojis = Set.from(widget.emojis);
  }

  void handleEmoji(String emoji) {
    if (widget.singleEmojiMode) {
      emojis.clear();
      emojis.add(emoji);
      Navigator.of(context).pop(emojis);
      return;
    }

    if (emojis.length >= 20) return;

    setState(() {
      emojis.add(emoji);
    });
  }

  void removeEmoji(String emoji) {
    setState(() {
      emojis.remove(emoji);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop<Set<String>>(emojis);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).choose_emoji),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () async {
                final r = await showSearch(
                  context: context,
                  delegate: EmojiSearchDelegate(
                    emojis: emojis,
                    removeEmoji: removeEmoji,
                    addEmoji: (s) {
                      if (widget.singleEmojiMode) Navigator.of(context).pop();
                      handleEmoji(s);
                    },
                    singleEmojiMode: widget.singleEmojiMode,
                    placeholder: widget.placeholder,
                  ),
                );

                if (!mounted || r == null || r.isEmpty) return;

                // ignore: unawaited_futures
                EmojiPicker.updateRecents(r, context);
              },
            )
          ],
        ),
        body: Column(
          children: [
            if (!widget.singleEmojiMode)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: PickedEmojiList(
                    emojis: emojis,
                    removeEmoji: removeEmoji,
                    placeholder: widget.placeholder,
                  ),
                ),
              ),
            Expanded(
              child: EmojiPicker(
                onEmojiSelected: (emoji) {
                  handleEmoji(emoji);
                },
                onBackspacePressed: () {
                  removeEmoji(emojis.last);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PickedEmojiList extends StatelessWidget {
  const PickedEmojiList({
    Key? key,
    required this.emojis,
    required this.removeEmoji,
    required this.placeholder,
  }) : super(key: key);

  final Set<String> emojis;
  final void Function(String emoji) removeEmoji;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 70),
      child: _PickedEmojiListContent(
        emojis: emojis,
        removeEmoji: removeEmoji,
        placeholder: placeholder,
      ),
    );
  }
}

class _PickedEmojiListContent extends StatelessWidget {
  const _PickedEmojiListContent({
    Key? key,
    required this.emojis,
    required this.removeEmoji,
    required this.placeholder,
  }) : super(key: key);

  final Set<String> emojis;
  final void Function(String emoji) removeEmoji;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    if (emojis.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          placeholder,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        for (final emoji in emojis)
          Card(
            child: EmojiButton(
              emoji: emoji,
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: ListTile(
                        leading: const Icon(Icons.delete_rounded),
                        title: Text(S.of(context).remove),
                        onTap: () {
                          removeEmoji(emoji);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class EmojiSearchDelegate extends SearchDelegate<String> {
  EmojiSearchDelegate({
    required this.emojis,
    required this.removeEmoji,
    required this.addEmoji,
    required this.placeholder,
    required this.singleEmojiMode,
  });

  final Set<String> emojis;
  final void Function(String emoji) removeEmoji;
  final void Function(String emoji) addEmoji;
  final String placeholder;
  final bool singleEmojiMode;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_rounded),
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

    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          if (!singleEmojiMode)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: PickedEmojiList(
                  emojis: emojis,
                  removeEmoji: (e) => setState(() => removeEmoji(e)),
                  placeholder: placeholder,
                ),
              ),
            ),
          Expanded(
            child: EmojiGridViewBuilder(
              category: list,
              onEmojiSelected: (e) => setState(() => addEmoji(e)),
            ),
          ),
        ],
      );
    });
  }
}
