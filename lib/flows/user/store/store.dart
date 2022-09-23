import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sticker_import/components/flutter/fade_in_image.dart';
import 'package:sticker_import/components/flutter/vk_image.dart';
import 'package:sticker_import/components/types/account.dart';
import 'package:sticker_import/flows/user/store/pack.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/services/connection/store.dart';
import 'package:sticker_import/utils/debugging.dart';

class VkStickerStoreRoute extends StatefulWidget {
  const VkStickerStoreRoute({super.key});

  @override
  State<VkStickerStoreRoute> createState() => _VkStickerStoreRouteState();
}

class _VkStickerStoreRouteState extends State<VkStickerStoreRoute> {
  late Account account;
  late VkStickerStore store;
  PageController? pageController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    account = AccountData.of(context)!.account;
    store = VkStickerStore(account: account);
    pageController?.dispose();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: store.getSections(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          iLog(snapshot.error);
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).sticker_store),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          final sections = snapshot.data!;

          return DefaultTabController(
            length: sections.length,
            child: Scaffold(
              appBar: AppBar(
                title: Text(S.of(context).sticker_store),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search_rounded),
                    tooltip: S.of(context).search_stickers,
                    onPressed: () {
                      showSearch<VkStickerStorePack?>(
                        context: context,
                        delegate: VkStickerStoreSearchDelegate(
                          account: account,
                        ),
                      );
                    },
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  labelStyle:
                      Theme.of(context).primaryTextTheme.bodyText1!.copyWith(
                    fontFamilyFallback: ['sans-serif', 'AppleColorEmoji'],
                    inherit: true,
                  ),
                  onTap: (value) {
                    scheduleMicrotask(() {
                      pageController!.animateToPage(
                        value,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  tabs: sections
                      .map(
                        (section) => Tab(
                          text: section.title,
                        ),
                      )
                      .toList(),
                ),
              ),
              body: StickerStoreBody(
                sections: sections,
                pageController: pageController!,
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).sticker_store),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class StickerStoreBody extends StatefulWidget {
  const StickerStoreBody({
    super.key,
    required this.sections,
    required this.pageController,
  });

  final List<VkStickerStoreSection> sections;
  final PageController pageController;

  @override
  State<StickerStoreBody> createState() => _StickerStoreBodyState();
}

class _StickerStoreBodyState extends State<StickerStoreBody> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      itemBuilder: (context, index) {
        return VkStickerStoreLayoutPage(
          section: widget.sections[index],
          account: AccountData.of(context)!.account,
        );
      },
      onPageChanged: (value) {
        final tabController = DefaultTabController.of(context)!;

        if (tabController.index != value && !tabController.indexIsChanging) {
          tabController.animateTo(value);
        }
      },
    );
  }
}

class VkStickerStoreLayoutPage extends StatefulWidget {
  const VkStickerStoreLayoutPage({
    super.key,
    required this.section,
    required this.account,
    this.onEmpty,
  });

  final VkStickerStoreSection section;
  final Account account;
  final Widget Function(BuildContext)? onEmpty;

  @override
  State<VkStickerStoreLayoutPage> createState() =>
      _VkStickerStoreLayoutPageState();
}

class _VkStickerStoreLayoutPageState extends State<VkStickerStoreLayoutPage> {
  String? nextFrom;

  Future<bool> getContent() async {
    if (isEnd) return false;
    try {
      final res = await widget.section.getPageContent(nextFrom);
      print('NEXTFROM $nextFrom -> ${res.nextFrom}');
      if (res.list.isEmpty || res.nextFrom == null) isEnd = true;
      nextFrom = res.nextFrom;
      layout.addAll(res.list);
      isInProgress = false;
      return true;
    } catch (e) {
      iLog(e);
      isInProgress = false;
      rethrow;
    }
  }

  List<VkStickerStoreLayout> layout = [];

  bool isInProgress = true;
  bool isEnd = false;

  ScrollController? scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (scrollController != null) {
      scrollController!.removeListener(appendContent);
    }

    scrollController = PrimaryScrollController.of(context);
    scrollController!.addListener(appendContent);
  }

  void appendContent() {
    if (!mounted) return;
    final scrollController = PrimaryScrollController.of(context)!;
    if (isInProgress || isEnd) return;
    if (scrollController.position.pixels >
        scrollController.position.maxScrollExtent - 200) {
      final l = layout.length;
      isInProgress = true;
      scheduleMicrotask(() async {
        await getContent();
        if (layout.length != l) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getContent(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          iLog(snapshot.error);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          if (layout.isEmpty && widget.onEmpty != null) {
            return widget.onEmpty!(context);
          }

          List<VkStickerStoreLayout> localLayout = layout;

          if (!isEnd) {
            localLayout = localLayout.followedBy(
              <VkStickerStoreLayout>[
                const VkStickerStoreLayoutLoader(),
              ],
            ).toList();
          }

          return ListView.builder(
            itemCount: localLayout.length,
            itemBuilder: (context, index) {
              return VkStickerStoreLayoutWidget(
                layout: localLayout[index],
                account: widget.account,
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class VkStickerStoreLayoutWidget extends StatelessWidget {
  const VkStickerStoreLayoutWidget({
    Key? key,
    required this.layout,
    required this.account,
  }) : super(key: key);

  final VkStickerStoreLayout layout;
  final Account account;

  @override
  Widget build(BuildContext context) {
    final item = layout;
    if (item is VkStickerStoreLayoutSeparator) {
      return Divider(
        key: ValueKey(item),
      );
    }

    if (item is VkStickerStoreLayoutHeader) {
      return ListTile(
        key: ValueKey(item),
        title: Text(
          item.title,
          style: const TextStyle(
            fontFamilyFallback: ['sans-serif', 'AppleColorEmoji'],
            inherit: true,
          ),
        ),
        trailing: item.buttons.isNotEmpty
            ? TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return AccountData(
                          account: account,
                          child: VkStickerStoreSectionRoute(
                            section: VkStickerStoreSection(
                              title: item.title,
                              id: item.buttons[0].sectionId,
                              account: account,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.unfold_more),
                label: Text(item.buttons[0].title),
              )
            : null,
      );
    }

    if (item is VkStickerStoreLayoutPackList) {
      if (item.type == VkStickerStoreLayoutPackListType.slider) {
        return SizedBox(
          key: ValueKey(item),
          height: 145,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: item.packs.length,
            itemBuilder: (context, index) {
              final pack = item.packs[index];

              return PackButton(
                key: ValueKey(pack),
                pack: pack,
                account: account,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: SizedBox(
                    width: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VkPackImage(
                          pack: pack,
                          account: account,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(pack.title),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      } else if (item.type == VkStickerStoreLayoutPackListType.list) {
        return ListView.builder(
          key: ValueKey(item),
          padding: const EdgeInsets.symmetric(vertical: 5),
          primary: false,
          shrinkWrap: true,
          itemExtent: 100,
          itemCount: item.packs.length,
          itemBuilder: (context, index) {
            final pack = item.packs[index];

            return PackButton(
              key: ValueKey(pack),
              pack: pack,
              account: account,
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: VkPackImage(
                        pack: pack,
                        account: account,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pack.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            pack.author,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }

    if (item is VkStickerStoreLayoutStickersList) {
      return GridView.builder(
        key: ValueKey(item),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        primary: false,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisExtent: 215,
          maxCrossAxisExtent: 145,
        ),
        itemCount: item.stickers.length,
        itemBuilder: (context, index) {
          final sticker = item.stickers[index];

          return PackButton(
            key: ValueKey(sticker),
            pack: sticker.pack,
            account: account,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
              child: SizedBox(
                width: 145,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 145,
                      height: 145,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: VkStoreEntityImage(
                        url: sticker.sticker.thumbnail,
                        isAnimated: sticker.pack?.styles[0].isAnimated ?? false,
                        account: account,
                      )),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(sticker.pack?.styles[0].title ?? ''),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    if (item is VkStickerStoreLayoutLoader) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    iLog('Unknown item type: ${item.runtimeType}');

    return Container(
      key: ValueKey(item),
    );
  }
}

class VkPackImage extends VkStoreEntityImage {
  VkPackImage({
    super.key,
    required VkStickerStorePack pack,
    required super.account,
  }) : super(
          url: 'https://vk.com/sticker/packs/${pack.id}/icon/square_2x.png',
          isAnimated: pack.styles[0].isAnimated,
        );
}

class VkStoreEntityImage extends StatefulWidget {
  const VkStoreEntityImage({
    super.key,
    required this.url,
    required this.isAnimated,
    required this.account,
  });

  final String url;
  final bool isAnimated;
  final Account account;

  @override
  State<VkStoreEntityImage> createState() => _VkStoreEntityImageState();
}

class _VkStoreEntityImageState extends State<VkStoreEntityImage> {
  bool _wasAnimated = false;
  late VKGetImageProvider provider;

  bool get wasAnimated {
    if (_wasAnimated) {
      return true;
    }

    _wasAnimated = true;
    return false;
  }

  @override
  void initState() {
    super.initState();

    provider = VKGetImageProvider(
      widget.url,
      widget.account.vk,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: 90,
          height: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: wasAnimated
                ? Image(image: provider)
                : FadeInImagePlaceholder(
                    image: provider,
                    width: 90,
                    height: 90,
                  ),
          ),
        ),
        if (widget.isAnimated)
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_circle_fill_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
      ],
    );
  }
}

class VkStickerStoreSectionRoute extends StatelessWidget {
  const VkStickerStoreSectionRoute({
    Key? key,
    required this.section,
  }) : super(key: key);

  final VkStickerStoreSection section;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(section.title),
        titleTextStyle: Theme.of(context).textTheme.headline6!.copyWith(
          fontFamilyFallback: ['sans-serif', 'AppleColorEmoji'],
          inherit: true,
        ),
      ),
      body: VkStickerStoreLayoutPage(
        section: section,
        account: AccountData.of(context)!.account,
      ),
    );
  }
}

class VkStickerStoreSearchDelegate extends SearchDelegate<VkStickerStorePack?> {
  VkStickerStoreSearchDelegate({
    required this.account,
  });

  final Account account;

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
        close(context, null);
      },
    );
  }

  Future<VkStickerStoreSection> requestSearchSection(
      BuildContext context) async {
    final searchResultsString = S.of(context).search_results;
    final response = await account.vk.call(
      'catalog.getStickersSearch',
      <String, dynamic>{
        'query': query,
      },
    );

    final section = VkStickerStoreSection(
      title: searchResultsString,
      id: response.asJson()['response']['catalog']['default_section'] as String,
      account: account,
    );

    return section;
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<VkStickerStoreSection>(
        future: requestSearchSection(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            iLog(snapshot.error);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            return VkStickerStoreLayoutPage(
                section: snapshot.data!,
                account: account,
                onEmpty: (BuildContext context) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        S.of(context).no_sticker_search_results,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                });
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text(S.of(context).search_stickers),
    );
  }
}

class PackButton extends StatelessWidget {
  const PackButton({
    super.key,
    required this.pack,
    required this.account,
    required this.child,
  });

  final VkStickerStorePack? pack;
  final Account account;
  final Widget child;

  void action(BuildContext context) async {
    if (pack == null) {
      return;
    }

    vkStoreStickerPackPopup(pack: pack!, account: account, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => action(context),
        child: FocusableActionDetector(
          actions: {
            ButtonActivateIntent: CallbackAction(
              onInvoke: (action) async {
                this.action(context);
                return null;
              },
            ),
          },
          child: child,
        ),
      ),
    );
  }
}
