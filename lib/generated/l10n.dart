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

  /// `en`
  String get code {
    return Intl.message(
      'en',
      name: 'code',
      desc: '',
      args: [],
    );
  }

  /// `Sticker Importer`
  String get tginfo_sticker_importer {
    return Intl.message(
      'Sticker Importer',
      name: 'tginfo_sticker_importer',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `We can help you to move your stickers from VK.com and LINE to Telegram`
  String get welcome_screen_description {
    return Intl.message(
      'We can help you to move your stickers from VK.com and LINE to Telegram',
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

  /// `Leave feedback`
  String get feedback {
    return Intl.message(
      'Leave feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `If you have any questions or suggestions, please contact us`
  String get feedback_desc {
    return Intl.message(
      'If you have any questions or suggestions, please contact us',
      name: 'feedback_desc',
      desc: '',
      args: [],
    );
  }

  /// `https://t.me/infowritebot?start=stickerimporter`
  String get feedback_url {
    return Intl.message(
      'https://t.me/infowritebot?start=stickerimporter',
      name: 'feedback_url',
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

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to stop the task?`
  String get stop_export_confirm {
    return Intl.message(
      'Are you sure you want to stop the task?',
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

  /// `Continue importing`
  String get continue_importing {
    return Intl.message(
      'Continue importing',
      name: 'continue_importing',
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

  /// `Without outline`
  String get without_border {
    return Intl.message(
      'Without outline',
      name: 'without_border',
      desc: '',
      args: [],
    );
  }

  /// `Sticker outline`
  String get with_border_title {
    return Intl.message(
      'Sticker outline',
      name: 'with_border_title',
      desc: '',
      args: [],
    );
  }

  /// `Do you wish to import these stickers as is, or with a white outline around their edges?`
  String get with_border_info {
    return Intl.message(
      'Do you wish to import these stickers as is, or with a white outline around their edges?',
      name: 'with_border_info',
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

  /// `The link is not a VK.com stickerpack`
  String get link_not_pack_vk {
    return Intl.message(
      'The link is not a VK.com stickerpack',
      name: 'link_not_pack_vk',
      desc: '',
      args: [],
    );
  }

  /// `The link is not a LINE stickerpack`
  String get link_not_pack_line {
    return Intl.message(
      'The link is not a LINE stickerpack',
      name: 'link_not_pack_line',
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

  /// `Not all animated stickers from VK.com are supported in Telegram, so they will be automatically excluded. Some packs might not be importable at all`
  String get not_all_animated {
    return Intl.message(
      'Not all animated stickers from VK.com are supported in Telegram, so they will be automatically excluded. Some packs might not be importable at all',
      name: 'not_all_animated',
      desc: '',
      args: [],
    );
  }

  /// `Note on animated stickers`
  String get animated_stickers_support_note {
    return Intl.message(
      'Note on animated stickers',
      name: 'animated_stickers_support_note',
      desc: '',
      args: [],
    );
  }

  /// `This sticker pack is animated, so you can import it either as static images, or as animations.`
  String get animated_stickers_support_note_text {
    return Intl.message(
      'This sticker pack is animated, so you can import it either as static images, or as animations.',
      name: 'animated_stickers_support_note_text',
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

  /// `Sticker Styles`
  String get sticker_styles {
    return Intl.message(
      'Sticker Styles',
      name: 'sticker_styles',
      desc: '',
      args: [],
    );
  }

  /// `This set has multiple sticker styles. Which one are you going with?`
  String get sticker_styles_info {
    return Intl.message(
      'This set has multiple sticker styles. Which one are you going with?',
      name: 'sticker_styles_info',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_btn {
    return Intl.message(
      'Continue',
      name: 'continue_btn',
      desc: '',
      args: [],
    );
  }

  /// `GitHub`
  String get github {
    return Intl.message(
      'GitHub',
      name: 'github',
      desc: '',
      args: [],
    );
  }

  /// `Source code`
  String get source_code {
    return Intl.message(
      'Source code',
      name: 'source_code',
      desc: '',
      args: [],
    );
  }

  /// `Pack ID is not found for {uri}. Check if your link is correct.`
  String pack_not_found(Object uri) {
    return Intl.message(
      'Pack ID is not found for $uri. Check if your link is correct.',
      name: 'pack_not_found',
      desc: '',
      args: [uri],
    );
  }

  /// `No error details available`
  String get no_error_details {
    return Intl.message(
      'No error details available',
      name: 'no_error_details',
      desc: '',
      args: [],
    );
  }

  /// `Detailed logging`
  String get detailed_logging {
    return Intl.message(
      'Detailed logging',
      name: 'detailed_logging',
      desc: '',
      args: [],
    );
  }

  /// `Consumes more RAM`
  String get detailed_logging_info {
    return Intl.message(
      'Consumes more RAM',
      name: 'detailed_logging_info',
      desc: '',
      args: [],
    );
  }

  /// `Save logs`
  String get save_logs {
    return Intl.message(
      'Save logs',
      name: 'save_logs',
      desc: '',
      args: [],
    );
  }

  /// `Logs saved to {path}`
  String logs_saved_to(Object path) {
    return Intl.message(
      'Logs saved to $path',
      name: 'logs_saved_to',
      desc: '',
      args: [path],
    );
  }

  /// `Couldn't save logs: {error}`
  String logs_save_error(Object error) {
    return Intl.message(
      'Couldn\'t save logs: $error',
      name: 'logs_save_error',
      desc: '',
      args: [error],
    );
  }

  /// `VK.com returned Error 429: Too Many Requests. Try using a different connection (proxy, VPN, etc.)`
  String get vk_error_429 {
    return Intl.message(
      'VK.com returned Error 429: Too Many Requests. Try using a different connection (proxy, VPN, etc.)',
      name: 'vk_error_429',
      desc: '',
      args: [],
    );
  }

  /// `VK.com Login`
  String get vk_login {
    return Intl.message(
      'VK.com Login',
      name: 'vk_login',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message(
      'Sign in',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Login or phone number`
  String get login {
    return Intl.message(
      'Login or phone number',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Fill all the fields`
  String get fill_all_fields {
    return Intl.message(
      'Fill all the fields',
      name: 'fill_all_fields',
      desc: '',
      args: [],
    );
  }

  /// `Enter code from the picture to continue`
  String get enter_code_from_img {
    return Intl.message(
      'Enter code from the picture to continue',
      name: 'enter_code_from_img',
      desc: '',
      args: [],
    );
  }

  /// `Enter code from the SMS sent to your phone`
  String get enter_code_from_sms {
    return Intl.message(
      'Enter code from the SMS sent to your phone',
      name: 'enter_code_from_sms',
      desc: '',
      args: [],
    );
  }

  /// `Enter code from the message sent to authentication app`
  String get enter_code_from_app {
    return Intl.message(
      'Enter code from the message sent to authentication app',
      name: 'enter_code_from_app',
      desc: '',
      args: [],
    );
  }

  /// `You request codes too often`
  String get twofa_codes_too_often {
    return Intl.message(
      'You request codes too often',
      name: 'twofa_codes_too_often',
      desc: '',
      args: [],
    );
  }

  /// `New code sent`
  String get twofa_code_sent {
    return Intl.message(
      'New code sent',
      name: 'twofa_code_sent',
      desc: '',
      args: [],
    );
  }

  /// `SMS`
  String get sms {
    return Intl.message(
      'SMS',
      name: 'sms',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get call {
    return Intl.message(
      'Call',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get field_required {
    return Intl.message(
      'Required',
      name: 'field_required',
      desc: '',
      args: [],
    );
  }

  /// `Internet error`
  String get internet_error_title {
    return Intl.message(
      'Internet error',
      name: 'internet_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Request failed. Check your Internet connection and try again`
  String get internet_error_info {
    return Intl.message(
      'Request failed. Check your Internet connection and try again',
      name: 'internet_error_info',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get t_continue {
    return Intl.message(
      'Continue',
      name: 't_continue',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get auth_code {
    return Intl.message(
      'Code',
      name: 'auth_code',
      desc: '',
      args: [],
    );
  }

  /// `By Link`
  String get by_link {
    return Intl.message(
      'By Link',
      name: 'by_link',
      desc: '',
      args: [],
    );
  }

  /// `VK.com Account`
  String get vk_account {
    return Intl.message(
      'VK.com Account',
      name: 'vk_account',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get delete_account_confirm {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'delete_account_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Add account`
  String get add_account {
    return Intl.message(
      'Add account',
      name: 'add_account',
      desc: '',
      args: [],
    );
  }

  /// `Logged in`
  String get logged_in {
    return Intl.message(
      'Logged in',
      name: 'logged_in',
      desc: '',
      args: [],
    );
  }

  /// `Get access to your sticker packs and VK's sticker store`
  String get vk_login_access {
    return Intl.message(
      'Get access to your sticker packs and VK\'s sticker store',
      name: 'vk_login_access',
      desc: '',
      args: [],
    );
  }

  /// `VK Sticker Store`
  String get vk_sticker_store {
    return Intl.message(
      'VK Sticker Store',
      name: 'vk_sticker_store',
      desc: '',
      args: [],
    );
  }

  /// `https://m.vk.com/stickers?tab=popular`
  String get vk_sticker_store_url {
    return Intl.message(
      'https://m.vk.com/stickers?tab=popular',
      name: 'vk_sticker_store_url',
      desc: '',
      args: [],
    );
  }

  /// `Heads up!`
  String get vk_id_setting_title {
    return Intl.message(
      'Heads up!',
      name: 'vk_id_setting_title',
      desc: '',
      args: [],
    );
  }

  /// `Disable "Protection from suspicious apps" in your VK ID settings to be able to use the feature`
  String get vk_id_setting_info {
    return Intl.message(
      'Disable "Protection from suspicious apps" in your VK ID settings to be able to use the feature',
      name: 'vk_id_setting_info',
      desc: '',
      args: [],
    );
  }

  /// `https://id.vk.com/account/#/security`
  String get vk_id_security_link {
    return Intl.message(
      'https://id.vk.com/account/#/security',
      name: 'vk_id_security_link',
      desc: '',
      args: [],
    );
  }

  /// `Go to VK ID`
  String get go_to_vk_id {
    return Intl.message(
      'Go to VK ID',
      name: 'go_to_vk_id',
      desc: '',
      args: [],
    );
  }

  /// `Two-factor authentication failed`
  String get twofa_failed {
    return Intl.message(
      'Two-factor authentication failed',
      name: 'twofa_failed',
      desc: '',
      args: [],
    );
  }

  /// `Try sending the request again`
  String get try_sending_request_again {
    return Intl.message(
      'Try sending the request again',
      name: 'try_sending_request_again',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't pass Captcha`
  String get captcha_fail {
    return Intl.message(
      'Couldn\'t pass Captcha',
      name: 'captcha_fail',
      desc: '',
      args: [],
    );
  }

  /// `Recent emoji`
  String get recent_emoji {
    return Intl.message(
      'Recent emoji',
      name: 'recent_emoji',
      desc: '',
      args: [],
    );
  }

  /// `No recent emoji`
  String get no_recent_emoji {
    return Intl.message(
      'No recent emoji',
      name: 'no_recent_emoji',
      desc: '',
      args: [],
    );
  }

  /// `Browse through available emojis by categories or use search.`
  String get no_recent_emoji_help {
    return Intl.message(
      'Browse through available emojis by categories or use search.',
      name: 'no_recent_emoji_help',
      desc: '',
      args: [],
    );
  }

  /// `Pick some emoji, so they will be used for sticker suggestions in Telegram`
  String get pick_emoji_sticker_suggestion {
    return Intl.message(
      'Pick some emoji, so they will be used for sticker suggestions in Telegram',
      name: 'pick_emoji_sticker_suggestion',
      desc: '',
      args: [],
    );
  }

  /// `Pick an emoji to search for stickers`
  String get pick_emoji_sticker_search {
    return Intl.message(
      'Pick an emoji to search for stickers',
      name: 'pick_emoji_sticker_search',
      desc: '',
      args: [],
    );
  }

  /// `Smileys & People`
  String get smileys_and_people {
    return Intl.message(
      'Smileys & People',
      name: 'smileys_and_people',
      desc: '',
      args: [],
    );
  }

  /// `Animals & Nature`
  String get animals_and_nature {
    return Intl.message(
      'Animals & Nature',
      name: 'animals_and_nature',
      desc: '',
      args: [],
    );
  }

  /// `Food & Drink`
  String get food_and_drink {
    return Intl.message(
      'Food & Drink',
      name: 'food_and_drink',
      desc: '',
      args: [],
    );
  }

  /// `Activity`
  String get activity {
    return Intl.message(
      'Activity',
      name: 'activity',
      desc: '',
      args: [],
    );
  }

  /// `Travel & Places`
  String get travel_and_places {
    return Intl.message(
      'Travel & Places',
      name: 'travel_and_places',
      desc: '',
      args: [],
    );
  }

  /// `Objects`
  String get objects {
    return Intl.message(
      'Objects',
      name: 'objects',
      desc: '',
      args: [],
    );
  }

  /// `Symbols`
  String get symbols {
    return Intl.message(
      'Symbols',
      name: 'symbols',
      desc: '',
      args: [],
    );
  }

  /// `Flags`
  String get flags {
    return Intl.message(
      'Flags',
      name: 'flags',
      desc: '',
      args: [],
    );
  }

  /// `No emojis matching your request were found`
  String get no_emoji_matches {
    return Intl.message(
      'No emojis matching your request were found',
      name: 'no_emoji_matches',
      desc: '',
      args: [],
    );
  }

  /// `Type to search`
  String get emoji_type_to_search {
    return Intl.message(
      'Type to search',
      name: 'emoji_type_to_search',
      desc: '',
      args: [],
    );
  }

  /// `Sticker Store`
  String get sticker_store {
    return Intl.message(
      'Sticker Store',
      name: 'sticker_store',
      desc: '',
      args: [],
    );
  }

  /// `Sticker Search`
  String get sticker_search {
    return Intl.message(
      'Sticker Search',
      name: 'sticker_search',
      desc: '',
      args: [],
    );
  }

  /// `Search results`
  String get search_results {
    return Intl.message(
      'Search results',
      name: 'search_results',
      desc: '',
      args: [],
    );
  }

  /// `No stickers found`
  String get no_sticker_search_results {
    return Intl.message(
      'No stickers found',
      name: 'no_sticker_search_results',
      desc: '',
      args: [],
    );
  }

  /// `Sticker pack`
  String get sticker_pack {
    return Intl.message(
      'Sticker pack',
      name: 'sticker_pack',
      desc: '',
      args: [],
    );
  }

  /// `Import to Telegram`
  String get import_to_telegram {
    return Intl.message(
      'Import to Telegram',
      name: 'import_to_telegram',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Import settings`
  String get import_settings {
    return Intl.message(
      'Import settings',
      name: 'import_settings',
      desc: '',
      args: [],
    );
  }

  /// `Stickers without suggestions`
  String get stickers_without_suggestions {
    return Intl.message(
      'Stickers without suggestions',
      name: 'stickers_without_suggestions',
      desc: '',
      args: [],
    );
  }

  /// `Some stickers don't have suggestions, so you can assign them manually by clicking on the icon in the bottom right corner of the sticker`
  String get stickers_without_suggestions_info {
    return Intl.message(
      'Some stickers don\'t have suggestions, so you can assign them manually by clicking on the icon in the bottom right corner of the sticker',
      name: 'stickers_without_suggestions_info',
      desc: '',
      args: [],
    );
  }

  /// `All stickers`
  String get all_stickers {
    return Intl.message(
      'All stickers',
      name: 'all_stickers',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with your VK.com account to:`
  String get login_with_vk_to {
    return Intl.message(
      'Sign in with your VK.com account to:',
      name: 'login_with_vk_to',
      desc: '',
      args: [],
    );
  }

  /// `and also`
  String get and_also {
    return Intl.message(
      'and also',
      name: 'and_also',
      desc: '',
      args: [],
    );
  }

  /// `Get access to your added sticker packs`
  String get login_with_vk_to_library {
    return Intl.message(
      'Get access to your added sticker packs',
      name: 'login_with_vk_to_library',
      desc: '',
      args: [],
    );
  }

  /// `List popular sticker packs`
  String get login_with_vk_to_store {
    return Intl.message(
      'List popular sticker packs',
      name: 'login_with_vk_to_store',
      desc: '',
      args: [],
    );
  }

  /// `Search for stickers by keywords and emoji`
  String get login_with_vk_to_search {
    return Intl.message(
      'Search for stickers by keywords and emoji',
      name: 'login_with_vk_to_search',
      desc: '',
      args: [],
    );
  }

  /// `Import vmoji packs`
  String get login_with_vk_to_vmoji {
    return Intl.message(
      'Import vmoji packs',
      name: 'login_with_vk_to_vmoji',
      desc: '',
      args: [],
    );
  }

  /// `Fill in emoji suggestions automatically`
  String get login_with_vk_to_suggestions {
    return Intl.message(
      'Fill in emoji suggestions automatically',
      name: 'login_with_vk_to_suggestions',
      desc: '',
      args: [],
    );
  }

  /// `Open VK.com store in web`
  String get vk_sticker_store_web {
    return Intl.message(
      'Open VK.com store in web',
      name: 'vk_sticker_store_web',
      desc: '',
      args: [],
    );
  }

  /// `I changed my mind`
  String get i_changed_my_mind {
    return Intl.message(
      'I changed my mind',
      name: 'i_changed_my_mind',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get sign_out {
    return Intl.message(
      'Sign out',
      name: 'sign_out',
      desc: '',
      args: [],
    );
  }

  /// `Tap to change account`
  String get tap_to_change_account {
    return Intl.message(
      'Tap to change account',
      name: 'tap_to_change_account',
      desc: '',
      args: [],
    );
  }

  /// `My Stickers`
  String get my_stickers {
    return Intl.message(
      'My Stickers',
      name: 'my_stickers',
      desc: '',
      args: [],
    );
  }

  /// `VK Vmoji`
  String get vmoji {
    return Intl.message(
      'VK Vmoji',
      name: 'vmoji',
      desc: '',
      args: [],
    );
  }

  /// `With emoji suggestions`
  String get with_emoji_suggestions {
    return Intl.message(
      'With emoji suggestions',
      name: 'with_emoji_suggestions',
      desc: '',
      args: [],
    );
  }

  /// `Don't ask again`
  String get do_not_ask_again {
    return Intl.message(
      'Don\'t ask again',
      name: 'do_not_ask_again',
      desc: '',
      args: [],
    );
  }

  /// `Start typing or pick an emoji to find stickers and sticker packs`
  String get start_typing_to_search_stickers {
    return Intl.message(
      'Start typing or pick an emoji to find stickers and sticker packs',
      name: 'start_typing_to_search_stickers',
      desc: '',
      args: [],
    );
  }

  /// `Choose account`
  String get choose_account {
    return Intl.message(
      'Choose account',
      name: 'choose_account',
      desc: '',
      args: [],
    );
  }

  /// `No added stickers`
  String get no_added_stickers {
    return Intl.message(
      'No added stickers',
      name: 'no_added_stickers',
      desc: '',
      args: [],
    );
  }

  /// `This page will conveniently display stickers you added to your library on VK.com`
  String get no_added_stickers_help {
    return Intl.message(
      'This page will conveniently display stickers you added to your library on VK.com',
      name: 'no_added_stickers_help',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get purchased {
    return Intl.message(
      'All',
      name: 'purchased',
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
