import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sticker_import/flows/user/store/store.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/services/connection/store.dart';

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
  ButtonStyle storeButtonStyle(BuildContext context) {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
        ),
        overlayColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.primary.withAlpha(50)),
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(15),
        ));
  }

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
                  color: Theme.of(context).canvasColor,
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
                    icon: const Icon(Icons.close),
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
                            style: storeButtonStyle(context),
                            child: Text(S.of(context).import_to_telegram),
                            onPressed: () {},
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
