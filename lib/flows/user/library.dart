import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sticker_import/flows/user/store/store.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/store.dart';
import 'package:sticker_import/services/connection/user_list.dart';
import 'package:sticker_import/utils/debugging.dart';

class AddedStickerPacksRoute extends StatefulWidget {
  const AddedStickerPacksRoute({
    super.key,
  });

  @override
  State<AddedStickerPacksRoute> createState() => _AddedStickerPacksRouteState();
}

class _AddedStickerPacksRouteState extends State<AddedStickerPacksRoute> {
  late VkStickerLibrary library;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    library = VkStickerLibrary(AccountData.of(context).account!);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).active),
              Tab(text: S.of(context).purchased),
            ],
          ),
          title: Text(S.of(context).my_stickers),
        ),
        body: TabBarView(children: [
          StickerPacksList(library: library, activeOnly: true),
          StickerPacksList(library: library, activeOnly: false),
        ]),
      ),
    );
  }
}

class StickerPacksList extends StatefulWidget {
  const StickerPacksList({
    super.key,
    required this.library,
    required this.activeOnly,
  });

  final VkStickerLibrary library;
  final bool activeOnly;

  @override
  State<StickerPacksList> createState() => _StickerPacksListState();
}

class _StickerPacksListState extends State<StickerPacksList> {
  final List<VkStickerStorePack> packs = [];

  Future<bool> getContent() async {
    if (isEnd) return false;
    try {
      final res = await widget.library.getStickerLibrary(
        page: page,
        activeOnly: widget.activeOnly,
      );
      page++;
      if (res.length < VkStickerLibrary.perPage) {
        setState(() {
          isEnd = true;
        });
      }

      packs.addAll(res);
      isInProgress = false;
      return true;
    } catch (e) {
      iLog(e);
      isInProgress = false;
      rethrow;
    }
  }

  int page = 0;

  bool isInProgress = true;
  bool isEnd = false;

  ScrollController? scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (scrollController != null) {
      scrollController!.removeListener(ac);
    }

    scrollController = PrimaryScrollController.of(context);
    scrollController!.addListener(ac);
  }

  void ac() => appendContent();

  void appendContent() {
    if (!mounted) return;
    if (isInProgress || isEnd || scrollController == null) return;
    if (scrollController!.position.pixels >
        scrollController!.position.maxScrollExtent - 200) {
      final l = packs.length;
      isInProgress = true;
      scheduleMicrotask(() async {
        await getContent();
        if (packs.length != l && mounted) {
          setState(() {});

          scheduleMicrotask(() {
            appendContent();
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    initialLoad = getContent();
  }

  late final Future<bool> initialLoad;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: initialLoad,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (snapshot.hasData) {
          if (packs.isEmpty) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Opacity(
                        opacity: 0.2,
                        child: Icon(Icons.add_reaction_rounded, size: 128),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).no_added_stickers,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context).no_added_stickers_help,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          Timer.run(() {
            appendContent();
          });
          return VkStickerStoreLayoutWidgetPackList(
            id: 'packs',
            packs: packs,
            scrollController: scrollController,
            isLoading: !isEnd,
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
