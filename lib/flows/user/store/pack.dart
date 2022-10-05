import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sticker_import/components/ui/store_button_style.dart';
import 'package:sticker_import/export/controllers/vk_store.dart';
import 'package:sticker_import/flows/export/progress.dart';
import 'package:sticker_import/flows/user/store/store.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/services/connection/store.dart';
import 'package:sticker_import/utils/debugging.dart';

void vkStoreStickerPackPopup({
  required VkStickerStorePack pack,
  required Account account,
  required BuildContext context,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    builder: (context) => VkStickerStorePackBottomSheet(
      pack: pack,
      account: account,
    ),
  );
}

class VkStickerStorePackBottomSheet extends StatefulWidget {
  const VkStickerStorePackBottomSheet({
    Key? key,
    required this.pack,
    required this.account,
  }) : super(key: key);

  final VkStickerStorePack pack;
  final Account account;

  @override
  State<VkStickerStorePackBottomSheet> createState() =>
      _VkStickerStorePackBottomSheetState();
}

class _VkStickerStorePackBottomSheetState
    extends State<VkStickerStorePackBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      builder: (context) {
        final top = MediaQuery.of(context).systemGestureInsets.top;
        return Padding(
          padding: EdgeInsets.only(top: top),
          //top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    S.of(context).sticker_pack,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Share.share(
                        widget.pack.domain,
                        subject:
                            '${widget.pack.title}\n\n${widget.pack.description}',
                      );
                    },
                    icon: const Icon(Icons.share_rounded),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      color: Colors.grey.withAlpha(20),
                      height: 120,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: VkPackImage(
                              pack: widget.pack,
                              account: widget.account,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.pack.title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  widget.pack.author,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.withAlpha(20),
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 15,
                      ),
                      child: Text(widget.pack.description),
                    ),
                    if (widget.pack.styles[0].isAnimated)
                      Container(
                        color: Colors.grey.withAlpha(20),
                        child: Card(
                          margin: const EdgeInsets.all(15),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            title: Text(
                                S.of(context).animated_stickers_support_note),
                            subtitle: Text(
                              '${S.of(context).animated_stickers_support_note_text}\n\n${S.of(context).not_all_animated}',
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.onSecondary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              child:
                                  const Icon(Icons.slow_motion_video_rounded),
                            ),
                          ),
                        ),
                      ),
                    GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: widget.pack.styles[0].stickers!.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        mainAxisExtent: 100,
                      ),
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return VkStoreEntityImage(
                          url: widget.pack.styles[0].stickers![index].thumbnail,
                          account: widget.account,
                          isAnimated: false,
                        );
                      },
                    ),
                    const Divider(),
                    FutureBuilder(
                      future: widget.pack.getContent(widget.account),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          iLog(snapshot.error);
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: Text(snapshot.error.toString()),
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: snapshot.data!.layout.length,
                          itemBuilder: (context, index) {
                            return VkStickerStoreLayoutWidget(
                              layout: snapshot.data!.layout[index],
                              account: widget.account,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: storeButtonStyle(context).copyWith(
                                padding: MaterialStateProperty.all(
                              const EdgeInsets.all(15),
                            )),
                            child: Text(S.of(context).import_to_telegram),
                            onPressed: () async {
                              final settings = await showModalBottomSheet<
                                  VkStickerStoreImportSettings?>(
                                context: context,
                                builder: (context) =>
                                    VkStickerStoreImportSettingsBottomSheet(
                                  style: widget.pack.styles[0],
                                  account: widget.account,
                                ),
                              );

                              if (settings == null) {
                                return;
                              }

                              if (!mounted) return;

                              // ignore: unawaited_futures
                              Navigator.of(context).push<dynamic>(
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) {
                                    return ExportProgressFlow(
                                      controller: VkStoreExportController(
                                        account: widget.account,
                                        isAnimated: settings.isAnimated,
                                        isWithBorder: settings.isWithBorder,
                                        style: widget.pack.styles[0],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onClosing: () {},
    );
  }
}

class VkStickerStoreImportSettings {
  final bool isWithBorder;
  final bool isAnimated;

  VkStickerStoreImportSettings({
    this.isWithBorder = false,
    this.isAnimated = false,
  });
}

class VkStickerStoreImportSettingsBottomSheet extends StatefulWidget {
  const VkStickerStoreImportSettingsBottomSheet({
    Key? key,
    required this.style,
    required this.account,
  }) : super(key: key);

  final VkStickerStoreStyle style;
  final Account account;

  @override
  VkStickerStoreImportSettingsBottomSheetState createState() =>
      VkStickerStoreImportSettingsBottomSheetState();
}

class VkStickerStoreImportSettingsBottomSheetState
    extends State<VkStickerStoreImportSettingsBottomSheet> {
  bool isWithBorder = false;
  bool isAnimated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    S.of(context).import_settings,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              if (widget.style.isAnimated)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(S.of(context).animated_pack),
                    subtitle: Text(
                        '${S.of(context).animated_pack_info}\n\n${S.of(context).not_all_animated}'),
                  ),
                ),
              if (widget.style.isAnimated)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                            VkStickerStoreImportSettings(isAnimated: false),
                          );
                        },
                        child: Text(S.of(context).still),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        style: storeButtonStyle(context),
                        onPressed: () {
                          Navigator.of(context).pop(
                            VkStickerStoreImportSettings(isAnimated: true),
                          );
                        },
                        child: Text(S.of(context).animated),
                      )
                    ],
                  ),
                ),
              if (!widget.style.isAnimated)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(S.of(context).with_border_title),
                    subtitle: Text(S.of(context).with_border_info),
                  ),
                ),
              if (!widget.style.isAnimated)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                            VkStickerStoreImportSettings(isWithBorder: true),
                          );
                        },
                        child: Text(S.of(context).with_border),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        style: storeButtonStyle(context),
                        onPressed: () {
                          Navigator.of(context).pop(
                            VkStickerStoreImportSettings(isWithBorder: false),
                          );
                        },
                        child: Text(S.of(context).without_border),
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
