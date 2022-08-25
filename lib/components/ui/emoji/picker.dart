import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sticker_import/components/types/emoji.dart';
import 'package:sticker_import/components/ui/emoji/grid.dart';
import 'package:sticker_import/generated/emoji_metadata.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/settings/settings.dart';
import 'package:sticker_import/utils/debugging.dart';

class EmojiPicker extends StatefulWidget {
  const EmojiPicker({
    required this.onEmojiSelected,
    required this.onBackspacePressed,
    super.key,
  });

  final void Function(String emoji) onEmojiSelected;
  final void Function() onBackspacePressed;

  @override
  EmojiPickerState createState() => EmojiPickerState();
}

class EmojiPickerState extends State<EmojiPicker> {
  late TabController tabController;
  late Future<List<EmojiUiCategory>> categories;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    categories = EmojiUiCategory.fromMap(context, kEmojiAtlas.categories);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EmojiUiCategory>>(
        future: categories,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return EmojiPage(
              categories: snapshot.data!,
              onEmojiSelected: widget.onEmojiSelected,
              onBackspacePressed: widget.onBackspacePressed,
            );
          } else if (snapshot.hasError) {
            // log error
            iLog(snapshot.error);
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }
}

class EmojiPage extends StatefulWidget {
  const EmojiPage({
    Key? key,
    required this.categories,
    required this.onEmojiSelected,
    required this.onBackspacePressed,
  }) : super(key: key);

  final List<EmojiUiCategory> categories;
  final void Function(String emoji) onEmojiSelected;
  final void Function() onBackspacePressed;

  @override
  State<EmojiPage> createState() => _EmojiPageState();
}

class _EmojiPageState extends State<EmojiPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      initialIndex: widget.categories[0].emojis.isEmpty ? 1 : 0,
      length: widget.categories.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TabBar(
                controller: tabController,
                isScrollable: false,
                labelPadding: EdgeInsets.zero,
                tabs: widget.categories
                    .map(
                      (category) => Tab(
                        icon: Icon(
                          category.icon,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.backspace),
              onPressed: () {
                widget.onBackspacePressed();
              },
            ),
          ],
        ),
        Flexible(
          child: TabBarView(
            controller: tabController,
            children: widget.categories.map((category) {
              return EmojiGrid(
                category: category,
                onEmojiSelected: (e) {
                  SettingsStorage.of('activity').set<String>(
                    'recentEmojis',
                    jsonEncode(
                      [e]
                          .followedBy(widget.categories[0].emojis)
                          .toSet()
                          .toList(),
                    ),
                  );

                  widget.onEmojiSelected(e);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class EmojiGrid extends StatefulWidget {
  const EmojiGrid({
    required this.category,
    required this.onEmojiSelected,
    super.key,
  });
  final EmojiUiCategory category;
  final void Function(String emoji) onEmojiSelected;
  @override
  EmojiGridState createState() => EmojiGridState();
}

class EmojiGridState extends State<EmojiGrid> {
  @override
  Widget build(BuildContext context) {
    if (widget.category.emojis.isEmpty) {
      return Center(
        child: Text(S.of(context).no_recent_emoji),
      );
    }

    return EmojiGridViewBuilder(
      category: widget.category.emojis,
      onEmojiSelected: widget.onEmojiSelected,
    );
  }
}

class EmojiUiCategoryStub {
  final String name;
  final IconData icon;

  const EmojiUiCategoryStub({
    required this.name,
    required this.icon,
  });
}

class EmojiUiCategory {
  final String name;
  final IconData icon;
  final List<String> emojis;

  const EmojiUiCategory({
    required this.name,
    required this.icon,
    required this.emojis,
  });

  static Future<List<EmojiUiCategory>> fromMap(
      BuildContext context, Map<String, EmojiCategory> map) async {
    final recentEmojiString = S.of(context).recent_emoji;

    final dataMap = <String, EmojiUiCategoryStub>{
      'Smileys & People': EmojiUiCategoryStub(
        name: S.of(context).smileys_and_people,
        icon: Icons.emoji_emotions_rounded,
      ),
      'Animals & Nature': EmojiUiCategoryStub(
        name: S.of(context).animals_and_nature,
        icon: Icons.emoji_nature_rounded,
      ),
      'Food & Drink': EmojiUiCategoryStub(
        name: S.of(context).food_and_drink,
        icon: Icons.emoji_food_beverage_rounded,
      ),
      'Activity': EmojiUiCategoryStub(
        name: S.of(context).activity,
        icon: Icons.emoji_people_rounded,
      ),
      'Travel & Places': EmojiUiCategoryStub(
        name: S.of(context).travel_and_places,
        icon: Icons.emoji_transportation_rounded,
      ),
      'Objects': EmojiUiCategoryStub(
        name: S.of(context).objects,
        icon: Icons.emoji_objects_rounded,
      ),
      'Symbols': EmojiUiCategoryStub(
        name: S.of(context).symbols,
        icon: Icons.emoji_symbols_rounded,
      ),
      'Flags': EmojiUiCategoryStub(
        name: S.of(context).flags,
        icon: Icons.emoji_flags_rounded,
      ),
    };

    final recentEmojis = (jsonDecode(
            await SettingsStorage.of('activity').get<String?>('recentEmojis') ??
                '[]') as List)
        .whereType<String>()
        .toList();

    return <EmojiUiCategory>[
      EmojiUiCategory(
          name: recentEmojiString,
          icon: Icons.access_time_rounded,
          emojis: recentEmojis),
    ].followedBy(map.entries.map((entry) {
      final stub = dataMap[entry.key]!;
      return EmojiUiCategory(
        name: stub.name,
        icon: stub.icon,
        emojis: entry.value.emojis,
      );
    })).toList();
  }
}
