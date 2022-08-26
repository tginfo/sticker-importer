// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(error) => "Couldn\'t save logs: ${error}";

  static String m1(path) => "Logs saved to ${path}";

  static String m2(count) =>
      "${Intl.plural(count, one: 'sticker', other: 'stickers')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_program": MessageLookupByLibrary.simpleMessage("About"),
        "active_stickers":
            MessageLookupByLibrary.simpleMessage("Active stickers"),
        "activity": MessageLookupByLibrary.simpleMessage("Activity"),
        "add_account": MessageLookupByLibrary.simpleMessage("Add account"),
        "animals_and_nature":
            MessageLookupByLibrary.simpleMessage("Animals & Nature"),
        "animated": MessageLookupByLibrary.simpleMessage("Animated"),
        "animated_pack":
            MessageLookupByLibrary.simpleMessage("Animated Stickers"),
        "animated_pack_info": MessageLookupByLibrary.simpleMessage(
            "This sticker pack is animated. Do you want to export it animated, or keep the stickers as still images?"),
        "auth_code": MessageLookupByLibrary.simpleMessage("Code"),
        "by_link": MessageLookupByLibrary.simpleMessage("By Link"),
        "call": MessageLookupByLibrary.simpleMessage("Call"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "captcha": MessageLookupByLibrary.simpleMessage("Captcha"),
        "captcha_fail":
            MessageLookupByLibrary.simpleMessage("Couldn\'t pass Captcha"),
        "check_the_link":
            MessageLookupByLibrary.simpleMessage("Check the link"),
        "choose_emoji": MessageLookupByLibrary.simpleMessage("Choose Emoji"),
        "code": MessageLookupByLibrary.simpleMessage("en"),
        "confirmation": MessageLookupByLibrary.simpleMessage("Confirmation"),
        "continue_btn": MessageLookupByLibrary.simpleMessage("Continue"),
        "continue_importing":
            MessageLookupByLibrary.simpleMessage("Continue importing"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "customize_your_pack":
            MessageLookupByLibrary.simpleMessage("Customize before continuing"),
        "customize_your_pack_info": MessageLookupByLibrary.simpleMessage(
            "Choose the stickers you want to import and assign emojis to them, so the pack can be easily accessed in Telegram"),
        "delete_account_confirm": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to log out?"),
        "detailed_logging":
            MessageLookupByLibrary.simpleMessage("Detailed logging"),
        "detailed_logging_info":
            MessageLookupByLibrary.simpleMessage("Consumes more RAM"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "donate": MessageLookupByLibrary.simpleMessage("Donate"),
        "done": MessageLookupByLibrary.simpleMessage("Done"),
        "done_exc": MessageLookupByLibrary.simpleMessage("Done!"),
        "done_exc_block1": MessageLookupByLibrary.simpleMessage(
            "Thank you for using Sticker Importer. This program was developed by Telegram Info."),
        "done_exc_block2": MessageLookupByLibrary.simpleMessage(
            "Telegram Info is a non-commercial project which exists thanks to your support. Our mission is helping spreading the knowledge about Telegram, making it more open and accessible this way."),
        "download": MessageLookupByLibrary.simpleMessage("Download"),
        "downloaded_n": MessageLookupByLibrary.simpleMessage("Downloaded"),
        "emoji_type_to_search":
            MessageLookupByLibrary.simpleMessage("Type to search"),
        "enable_sticker":
            MessageLookupByLibrary.simpleMessage("Enable Sticker"),
        "enter_code_from_app": MessageLookupByLibrary.simpleMessage(
            "Enter code from the message sent to authentication app"),
        "enter_code_from_img": MessageLookupByLibrary.simpleMessage(
            "Enter code from the picture to continue"),
        "enter_code_from_sms": MessageLookupByLibrary.simpleMessage(
            "Enter code from the SMS sent to your phone"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "export_config_info": MessageLookupByLibrary.simpleMessage(
            "Your Internet connection is being used while downloading"),
        "export_done": MessageLookupByLibrary.simpleMessage("Export done"),
        "export_error": MessageLookupByLibrary.simpleMessage("Export error"),
        "export_error_description": MessageLookupByLibrary.simpleMessage(
            "Something went wrong during the export process."),
        "export_paused":
            MessageLookupByLibrary.simpleMessage("Exporting paused"),
        "export_stopped":
            MessageLookupByLibrary.simpleMessage("Exporting stopped"),
        "export_working":
            MessageLookupByLibrary.simpleMessage("Downloading stickers..."),
        "feedback": MessageLookupByLibrary.simpleMessage("Leave feedback"),
        "feedback_desc": MessageLookupByLibrary.simpleMessage(
            "If you have any questions or suggestions, please contact us"),
        "feedback_url": MessageLookupByLibrary.simpleMessage(
            "https://t.me/infowritebot?start=stickerimporter"),
        "field_required": MessageLookupByLibrary.simpleMessage("Required"),
        "fill_all_fields":
            MessageLookupByLibrary.simpleMessage("Fill all the fields"),
        "flags": MessageLookupByLibrary.simpleMessage("Flags"),
        "follow_tginfo":
            MessageLookupByLibrary.simpleMessage("Subscribe @tginfo"),
        "food_and_drink": MessageLookupByLibrary.simpleMessage("Food & Drink"),
        "github": MessageLookupByLibrary.simpleMessage("GitHub"),
        "go_back": MessageLookupByLibrary.simpleMessage("Return"),
        "go_to_vk_id": MessageLookupByLibrary.simpleMessage("Go to VK ID"),
        "internet_error_info": MessageLookupByLibrary.simpleMessage(
            "Request failed. Check your Internet connection and try again"),
        "internet_error_title":
            MessageLookupByLibrary.simpleMessage("Internet error"),
        "licenses": MessageLookupByLibrary.simpleMessage("Licenses"),
        "licenses_desc":
            MessageLookupByLibrary.simpleMessage("Open source notices"),
        "link": MessageLookupByLibrary.simpleMessage("Link to the stickerpack"),
        "link_incorrect":
            MessageLookupByLibrary.simpleMessage("The link is incorrect"),
        "link_not_pack_line": MessageLookupByLibrary.simpleMessage(
            "The link is not a LINE stickerpack"),
        "link_not_pack_vk": MessageLookupByLibrary.simpleMessage(
            "The link is not a VK.com stickerpack"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading"),
        "logged_in": MessageLookupByLibrary.simpleMessage("Logged in"),
        "login": MessageLookupByLibrary.simpleMessage("Login or phone number"),
        "logs_save_error": m0,
        "logs_saved_to": m1,
        "my_avatar": MessageLookupByLibrary.simpleMessage("My avatar"),
        "no_emoji_matches": MessageLookupByLibrary.simpleMessage(
            "No emojis matching your request were found"),
        "no_error_details":
            MessageLookupByLibrary.simpleMessage("No error details available"),
        "no_recent_emoji":
            MessageLookupByLibrary.simpleMessage("No recent emoji"),
        "no_recent_emoji_help": MessageLookupByLibrary.simpleMessage(
            "Browse through available emojis by categories or use search."),
        "no_recents": MessageLookupByLibrary.simpleMessage("No Recents"),
        "not_all_animated": MessageLookupByLibrary.simpleMessage(
            "Not all animated stickers from VK.com are supported in Telegram, so they will be automatically excluded. Some packs might not be importable at all"),
        "not_installed": MessageLookupByLibrary.simpleMessage(
            "Telegram is not installed on your device, so we couldn\'t export the pack"),
        "objects": MessageLookupByLibrary.simpleMessage("Objects"),
        "of_stickers": m2,
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "open_in_browser":
            MessageLookupByLibrary.simpleMessage("Open in browser"),
        "out_of": MessageLookupByLibrary.simpleMessage("of"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "prepare_pack":
            MessageLookupByLibrary.simpleMessage("Prepare your pack"),
        "recent_emoji": MessageLookupByLibrary.simpleMessage("Recent emoji"),
        "resume": MessageLookupByLibrary.simpleMessage("Resume"),
        "retrying": MessageLookupByLibrary.simpleMessage("Retrying..."),
        "save_logs": MessageLookupByLibrary.simpleMessage("Save logs"),
        "search_stickers":
            MessageLookupByLibrary.simpleMessage("Search stickers"),
        "select_all": MessageLookupByLibrary.simpleMessage("Select All"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Sign in"),
        "smileys_and_people":
            MessageLookupByLibrary.simpleMessage("Smileys & People"),
        "sms": MessageLookupByLibrary.simpleMessage("SMS"),
        "sominemo": MessageLookupByLibrary.simpleMessage("Sominemo"),
        "sominemo_desc": MessageLookupByLibrary.simpleMessage("Developer"),
        "source_code": MessageLookupByLibrary.simpleMessage("Source code"),
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "sticker_store": MessageLookupByLibrary.simpleMessage("Sticker Store"),
        "sticker_styles":
            MessageLookupByLibrary.simpleMessage("Sticker Styles"),
        "sticker_styles_info": MessageLookupByLibrary.simpleMessage(
            "This set has multiple sticker styles. Which one are you going with?"),
        "still": MessageLookupByLibrary.simpleMessage("Still Pictures"),
        "stop": MessageLookupByLibrary.simpleMessage("Stop"),
        "stop_export_confirm": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to stop the task?"),
        "symbols": MessageLookupByLibrary.simpleMessage("Symbols"),
        "t_continue": MessageLookupByLibrary.simpleMessage("Continue"),
        "telegram_info": MessageLookupByLibrary.simpleMessage("Telegram Info"),
        "telegram_info_desc":
            MessageLookupByLibrary.simpleMessage("Our channel"),
        "tginfo_link":
            MessageLookupByLibrary.simpleMessage("https://t.me/tginfoen"),
        "tginfo_sticker_importer":
            MessageLookupByLibrary.simpleMessage("Sticker Importer"),
        "travel_and_places":
            MessageLookupByLibrary.simpleMessage("Travel & Places"),
        "try_sending_request_again": MessageLookupByLibrary.simpleMessage(
            "Try sending the request again"),
        "twofa_code_sent":
            MessageLookupByLibrary.simpleMessage("New code sent"),
        "twofa_codes_too_often":
            MessageLookupByLibrary.simpleMessage("You request codes too often"),
        "twofa_failed": MessageLookupByLibrary.simpleMessage(
            "Two-factor authentication failed"),
        "unit_b": MessageLookupByLibrary.simpleMessage("B"),
        "unit_gb": MessageLookupByLibrary.simpleMessage("GB"),
        "unit_kb": MessageLookupByLibrary.simpleMessage("KB"),
        "unit_mb": MessageLookupByLibrary.simpleMessage("MB"),
        "update": MessageLookupByLibrary.simpleMessage("Update"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "vk_account": MessageLookupByLibrary.simpleMessage("VK.com Account"),
        "vk_error_429": MessageLookupByLibrary.simpleMessage(
            "VK.com returned Error 429: Too Many Requests. Try using a different connection (proxy, VPN, etc.)"),
        "vk_id_security_link": MessageLookupByLibrary.simpleMessage(
            "https://id.vk.com/account/#/security"),
        "vk_id_setting_info": MessageLookupByLibrary.simpleMessage(
            "Disable \"Protection from suspicious apps\" in your VK ID settings to be able to use the feature"),
        "vk_id_setting_title":
            MessageLookupByLibrary.simpleMessage("Heads up!"),
        "vk_login": MessageLookupByLibrary.simpleMessage("VK.com Login"),
        "vk_login_access": MessageLookupByLibrary.simpleMessage(
            "Get access to your sticker packs and VK\'s sticker store"),
        "vk_sticker_store":
            MessageLookupByLibrary.simpleMessage("VK Sticker Store"),
        "vk_sticker_store_url": MessageLookupByLibrary.simpleMessage(
            "https://m.vk.com/stickers?tab=popular"),
        "warming_up": MessageLookupByLibrary.simpleMessage("Warming up..."),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
        "welcome_screen_description": MessageLookupByLibrary.simpleMessage(
            "We can help you to move your stickers from VK.com and LINE to Telegram"),
        "with_border": MessageLookupByLibrary.simpleMessage("With outline")
      };
}
