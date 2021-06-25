// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Telegram Info Sticker Importer`
  String get tginfo_sticker_importer {
    return Intl.message(
      'Telegram Info Sticker Importer',
      name: 'tginfo_sticker_importer',
      desc: '',
      args: [],
    );
  }

  /// `Welcome here`
  String get welcome {
    return Intl.message(
      'Welcome here',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `We can help you to move your stickers from VK to Telegram smoothly`
  String get welcome_screen_description {
    return Intl.message(
      'We can help you to move your stickers from VK to Telegram smoothly',
      name: 'welcome_screen_description',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about_program {
    return Intl.message(
      'About',
      name: 'about_program',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Telegram Info`
  String get telegram_info {
    return Intl.message(
      'Telegram Info',
      name: 'telegram_info',
      desc: '',
      args: [],
    );
  }

  /// `Our channel`
  String get telegram_info_desc {
    return Intl.message(
      'Our channel',
      name: 'telegram_info_desc',
      desc: '',
      args: [],
    );
  }

  /// `https://t.me/tginfoen`
  String get tginfo_link {
    return Intl.message(
      'https://t.me/tginfoen',
      name: 'tginfo_link',
      desc: '',
      args: [],
    );
  }

  /// `Sominemo`
  String get sominemo {
    return Intl.message(
      'Sominemo',
      name: 'sominemo',
      desc: '',
      args: [],
    );
  }

  /// `Developer`
  String get sominemo_desc {
    return Intl.message(
      'Developer',
      name: 'sominemo_desc',
      desc: '',
      args: [],
    );
  }

  /// `AntonioMarreti`
  String get antonio_marreti {
    return Intl.message(
      'AntonioMarreti',
      name: 'antonio_marreti',
      desc: '',
      args: [],
    );
  }

  /// `Lead editor of @tginfo`
  String get antonio_marreti_desc {
    return Intl.message(
      'Lead editor of @tginfo',
      name: 'antonio_marreti_desc',
      desc: '',
      args: [],
    );
  }

  /// `Licenses`
  String get licenses {
    return Intl.message(
      'Licenses',
      name: 'licenses',
      desc: '',
      args: [],
    );
  }

  /// `Open source notices`
  String get licenses_desc {
    return Intl.message(
      'Open source notices',
      name: 'licenses_desc',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Captcha`
  String get captcha {
    return Intl.message(
      'Captcha',
      name: 'captcha',
      desc: '',
      args: [],
    );
  }

  /// `B`
  String get unit_b {
    return Intl.message(
      'B',
      name: 'unit_b',
      desc: '',
      args: [],
    );
  }

  /// `KB`
  String get unit_kb {
    return Intl.message(
      'KB',
      name: 'unit_kb',
      desc: '',
      args: [],
    );
  }

  /// `MB`
  String get unit_mb {
    return Intl.message(
      'MB',
      name: 'unit_mb',
      desc: '',
      args: [],
    );
  }

  /// `GB`
  String get unit_gb {
    return Intl.message(
      'GB',
      name: 'unit_gb',
      desc: '',
      args: [],
    );
  }

  /// `Confirmnation`
  String get confirmnation {
    return Intl.message(
      'Confirmnation',
      name: 'confirmnation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to stop export?`
  String get stop_export_confirm {
    return Intl.message(
      'Are you sure you want to stop export?',
      name: 'stop_export_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get stop {
    return Intl.message(
      'Stop',
      name: 'stop',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get go_back {
    return Intl.message(
      'Return',
      name: 'go_back',
      desc: '',
      args: [],
    );
  }

  /// `Exporting stopped`
  String get export_stopped {
    return Intl.message(
      'Exporting stopped',
      name: 'export_stopped',
      desc: '',
      args: [],
    );
  }

  /// `Exporting paused`
  String get export_paused {
    return Intl.message(
      'Exporting paused',
      name: 'export_paused',
      desc: '',
      args: [],
    );
  }

  /// `Downloading stickers...`
  String get export_working {
    return Intl.message(
      'Downloading stickers...',
      name: 'export_working',
      desc: '',
      args: [],
    );
  }

  /// `Export error`
  String get export_error {
    return Intl.message(
      'Export error',
      name: 'export_error',
      desc: '',
      args: [],
    );
  }

  /// `Export done`
  String get export_done {
    return Intl.message(
      'Export done',
      name: 'export_done',
      desc: '',
      args: [],
    );
  }

  /// `Warming up...`
  String get warming_up {
    return Intl.message(
      'Warming up...',
      name: 'warming_up',
      desc: '',
      args: [],
    );
  }

  /// `Retrying...`
  String get retrying {
    return Intl.message(
      'Retrying...',
      name: 'retrying',
      desc: '',
      args: [],
    );
  }

  /// `Resume`
  String get resume {
    return Intl.message(
      'Resume',
      name: 'resume',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong during the export process.`
  String get export_error_description {
    return Intl.message(
      'Something went wrong during the export process.',
      name: 'export_error_description',
      desc: '',
      args: [],
    );
  }

  /// `{count,plural, =1{sticker}other{stickers}}`
  String of_stickers(num count) {
    return Intl.plural(
      count,
      one: 'sticker',
      other: 'stickers',
      name: 'of_stickers',
      desc: '',
      args: [count],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Link to the stickerpack`
  String get link {
    return Intl.message(
      'Link to the stickerpack',
      name: 'link',
      desc: '',
      args: [],
    );
  }

  /// `With outline`
  String get with_border {
    return Intl.message(
      'With outline',
      name: 'with_border',
      desc: '',
      args: [],
    );
  }

  /// `Your Internet connection is being used while downloading`
  String get export_config_info {
    return Intl.message(
      'Your Internet connection is being used while downloading',
      name: 'export_config_info',
      desc: '',
      args: [],
    );
  }

  /// `Downloaded`
  String get downloaded_n {
    return Intl.message(
      'Downloaded',
      name: 'downloaded_n',
      desc: '',
      args: [],
    );
  }

  /// `of`
  String get out_of {
    return Intl.message(
      'of',
      name: 'out_of',
      desc: '',
      args: [],
    );
  }

  /// `The link is incorrect`
  String get link_incorrect {
    return Intl.message(
      'The link is incorrect',
      name: 'link_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `The link is not a VK stickerpack`
  String get link_not_pack {
    return Intl.message(
      'The link is not a VK stickerpack',
      name: 'link_not_pack',
      desc: '',
      args: [],
    );
  }

  /// `Check the link`
  String get check_the_link {
    return Intl.message(
      'Check the link',
      name: 'check_the_link',
      desc: '',
      args: [],
    );
  }

  /// `Prepare your pack`
  String get prepare_pack {
    return Intl.message(
      'Prepare your pack',
      name: 'prepare_pack',
      desc: '',
      args: [],
    );
  }

  /// `Customize before continuing`
  String get customize_your_pack {
    return Intl.message(
      'Customize before continuing',
      name: 'customize_your_pack',
      desc: '',
      args: [],
    );
  }

  /// `Choose the stickers you want to import and assign emojis to them, so the pack can be easily accessed in Telegram`
  String get customize_your_pack_info {
    return Intl.message(
      'Choose the stickers you want to import and assign emojis to them, so the pack can be easily accessed in Telegram',
      name: 'customize_your_pack_info',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get select_all {
    return Intl.message(
      'Select All',
      name: 'select_all',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Enable Sticker`
  String get enable_sticker {
    return Intl.message(
      'Enable Sticker',
      name: 'enable_sticker',
      desc: '',
      args: [],
    );
  }

  /// `Choose Emoji`
  String get choose_emoji {
    return Intl.message(
      'Choose Emoji',
      name: 'choose_emoji',
      desc: '',
      args: [],
    );
  }

  /// `No Recents`
  String get no_recents {
    return Intl.message(
      'No Recents',
      name: 'no_recents',
      desc: '',
      args: [],
    );
  }

  /// `Done!`
  String get done_exc {
    return Intl.message(
      'Done!',
      name: 'done_exc',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for using Sticker Importer. This program was developed by Telegram Info.`
  String get done_exc_block1 {
    return Intl.message(
      'Thank you for using Sticker Importer. This program was developed by Telegram Info.',
      name: 'done_exc_block1',
      desc: '',
      args: [],
    );
  }

  /// `Telegram Info is a non-commercial project which exists thanks to your support. Our mission is helping spreading the knowledge about Telegram, making it more open and accessible this way.`
  String get done_exc_block2 {
    return Intl.message(
      'Telegram Info is a non-commercial project which exists thanks to your support. Our mission is helping spreading the knowledge about Telegram, making it more open and accessible this way.',
      name: 'done_exc_block2',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe @tginfo`
  String get follow_tginfo {
    return Intl.message(
      'Subscribe @tginfo',
      name: 'follow_tginfo',
      desc: '',
      args: [],
    );
  }

  /// `Donate`
  String get donate {
    return Intl.message(
      'Donate',
      name: 'donate',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Open in browser`
  String get open_in_browser {
    return Intl.message(
      'Open in browser',
      name: 'open_in_browser',
      desc: '',
      args: [],
    );
  }

  /// `Animated Stickers`
  String get animated_pack {
    return Intl.message(
      'Animated Stickers',
      name: 'animated_pack',
      desc: '',
      args: [],
    );
  }

  /// `This sticker pack is animated. Do you want to export it animated, or keep the stickers as still images?`
  String get animated_pack_info {
    return Intl.message(
      'This sticker pack is animated. Do you want to export it animated, or keep the stickers as still images?',
      name: 'animated_pack_info',
      desc: '',
      args: [],
    );
  }

  /// `Animated`
  String get animated {
    return Intl.message(
      'Animated',
      name: 'animated',
      desc: '',
      args: [],
    );
  }

  /// `Still Pictures`
  String get still {
    return Intl.message(
      'Still Pictures',
      name: 'still',
      desc: '',
      args: [],
    );
  }

  /// `Not all animated stickers from VK are supported in Telegram, so they will be automatically excluded. Some packs might not be importable at all`
  String get not_all_animated {
    return Intl.message(
      'Not all animated stickers from VK are supported in Telegram, so they will be automatically excluded. Some packs might not be importable at all',
      name: 'not_all_animated',
      desc: '',
      args: [],
    );
  }

  /// `Telegram is not installed on your device, so we couldn't export the pack`
  String get not_installed {
    return Intl.message(
      'Telegram is not installed on your device, so we couldn\'t export the pack',
      name: 'not_installed',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
