import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sticker_import/components/flutter/fade_in_image.dart';
import 'package:sticker_import/components/flutter/vk_image.dart';
import 'package:sticker_import/components/types/account.dart';
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
        final section = widget.sections[index];
        final account = AccountData.of(context)!.account;

        return FutureBuilder(
          future: section.getContent(),
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
              final layout = snapshot.data!.layout;

              return VkStickerStoreLayoutWidget(
                layout: layout,
                account: account,
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
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

class VkStickerStoreLayoutWidget extends StatelessWidget {
  const VkStickerStoreLayoutWidget({
    Key? key,
    required this.layout,
    required this.account,
  }) : super(key: key);

  final List<VkStickerStoreLayout> layout;
  final Account account;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: layout.length,
      itemBuilder: (context, index) {
        final item = layout[index];

        if (item is VkStickerStoreLayoutSeparator) {
          return const Divider();
        }

        if (item is VkStickerStoreLayoutHeader) {
          return ListTile(
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
              height: 145,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: item.packs.length,
                itemBuilder: (context, index) {
                  final pack = item.packs[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
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
                  );
                },
              ),
            );
          } else if (item.type == VkStickerStoreLayoutPackListType.list) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 5),
              primary: false,
              shrinkWrap: true,
              itemExtent: 100,
              itemCount: item.packs.length,
              itemBuilder: (context, index) {
                final pack = item.packs[index];

                return SizedBox(
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
                            Text(pack.title),
                            Text(
                              pack.author,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }

        if (item is VkStickerStoreLayoutStickersList) {
          return GridView.builder(
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

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                            child: VkStoreEntityImage(
                          url: sticker.sticker.thumbnail,
                          isAnimated:
                              sticker.pack?.styles[0].isAnimated ?? false,
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
              );
            },
          );
        }

        iLog('Unknown item type: ${item.runtimeType}');

        return Container();
      },
    );
  }
}

class VkPackImage extends VkStoreEntityImage {
  VkPackImage({
    super.key,
    required VkStickerStorePack pack,
    required super.account,
  }) : super(
          url: 'https://vk.com/sticker/packs/${pack.id}/icon/square.png',
          isAnimated: pack.styles[0].isAnimated,
        );
}

class VkStoreEntityImage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 90,
          height: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImagePlaceholder(
              image: VKGetImageProvider(
                url,
                account.vk,
              ),
              width: 90,
              height: 90,
            ),
          ),
        ),
        if (isAnimated)
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
    final account = AccountData.of(context)!.account;

    return Scaffold(
      appBar: AppBar(
        title: Text(section.title),
        titleTextStyle: Theme.of(context).textTheme.headline6!.copyWith(
          fontFamilyFallback: ['sans-serif', 'AppleColorEmoji'],
          inherit: true,
        ),
      ),
      body: FutureBuilder(
        future: section.getContent(),
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
            final layout = snapshot.data!.layout;

            return VkStickerStoreLayoutWidget(
              layout: layout,
              account: account,
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
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

  Future<VkStickerStoreContent> requestSearchSection(
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

    return await section.getContent();
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
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
            final section = snapshot.data as VkStickerStoreContent;

            if (section.layout.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    S.of(context).no_sticker_search_results,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return VkStickerStoreLayoutWidget(
              layout: section.layout,
              account: account,
            );
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
