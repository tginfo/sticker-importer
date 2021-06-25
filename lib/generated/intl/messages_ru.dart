// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(count) =>
      "${Intl.plural(count, zero: 'стикеров', one: 'стикер', two: 'стикера', few: 'стикеров', many: 'стикеров', other: 'стикеров')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_program": MessageLookupByLibrary.simpleMessage("О программе"),
        "animated": MessageLookupByLibrary.simpleMessage("Анимированный"),
        "animated_pack":
            MessageLookupByLibrary.simpleMessage("Анимированный набор"),
        "animated_pack_info": MessageLookupByLibrary.simpleMessage(
            "Этот набор – анимированный. Желаете экспортировать стикеры в виде анимаций, или статичных изображений?"),
        "antonio_marreti":
            MessageLookupByLibrary.simpleMessage("AntonioMarreti"),
        "antonio_marreti_desc":
            MessageLookupByLibrary.simpleMessage("Главный редактор @tginfo"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "captcha": MessageLookupByLibrary.simpleMessage("Подтверждение"),
        "check_the_link": MessageLookupByLibrary.simpleMessage(
            "Проверьте правильность ссылки"),
        "choose_emoji": MessageLookupByLibrary.simpleMessage("Выбор эмодзи"),
        "confirmnation": MessageLookupByLibrary.simpleMessage("Подтверждение"),
        "copy": MessageLookupByLibrary.simpleMessage("Копировать"),
        "customize_your_pack":
            MessageLookupByLibrary.simpleMessage("Настройте под себя"),
        "customize_your_pack_info": MessageLookupByLibrary.simpleMessage(
            "Выберите, какие стикеры Вы желаете импортировать и присвойте им соответствующие эмодзи для быстрого доступа"),
        "details": MessageLookupByLibrary.simpleMessage("Подробности"),
        "donate": MessageLookupByLibrary.simpleMessage("Пожертвование"),
        "done": MessageLookupByLibrary.simpleMessage("Готово"),
        "done_exc": MessageLookupByLibrary.simpleMessage("Готово!"),
        "done_exc_block1": MessageLookupByLibrary.simpleMessage(
            "Благодарим за использование Sticker Importer. Данная программа разработана Telegram Info."),
        "done_exc_block2": MessageLookupByLibrary.simpleMessage(
            "Telegram Info это некоммерческий проект, который существует только благодаря вашей поддержке. Наша цель — доносить информацию о Telegram и его сервисах, делая их более открытыми и доступными."),
        "download": MessageLookupByLibrary.simpleMessage("Скачать"),
        "downloaded_n": MessageLookupByLibrary.simpleMessage("Загружено"),
        "enable_sticker":
            MessageLookupByLibrary.simpleMessage("Включить стикер"),
        "error": MessageLookupByLibrary.simpleMessage("Ошибка"),
        "export_config_info": MessageLookupByLibrary.simpleMessage(
            "Во время загрузки используется Ваше Интернет-соединение"),
        "export_done": MessageLookupByLibrary.simpleMessage("Экспорт завершён"),
        "export_error": MessageLookupByLibrary.simpleMessage("Ошибка экспорта"),
        "export_error_description": MessageLookupByLibrary.simpleMessage(
            "Во время экспорта, что-то пошло не так."),
        "export_paused":
            MessageLookupByLibrary.simpleMessage("Экспорт приостановлен"),
        "export_stopped":
            MessageLookupByLibrary.simpleMessage("Экспорт остановлен"),
        "export_working":
            MessageLookupByLibrary.simpleMessage("Загрузка стикеров..."),
        "follow_tginfo":
            MessageLookupByLibrary.simpleMessage("Подписаться на @tginfo"),
        "go_back": MessageLookupByLibrary.simpleMessage("Назад"),
        "licenses": MessageLookupByLibrary.simpleMessage("Лицензии"),
        "licenses_desc":
            MessageLookupByLibrary.simpleMessage("Открытого исходного кода"),
        "link": MessageLookupByLibrary.simpleMessage("Ссылка на стикерпак"),
        "link_incorrect":
            MessageLookupByLibrary.simpleMessage("Ссылка некорректна"),
        "link_not_pack": MessageLookupByLibrary.simpleMessage(
            "Ссылка не является стикерпаком ВКонтакте"),
        "no_recents": MessageLookupByLibrary.simpleMessage("История пуста"),
        "not_all_animated": MessageLookupByLibrary.simpleMessage(
            "Не все анимированные стикеры из ВКонтакте поддерживаются в Telegram, такие стикеры будут автоматически исключены. Некоторые наборы не получится импортировать вовсе"),
        "not_installed": MessageLookupByLibrary.simpleMessage(
            "Telegram не установлен на Вашем устройстве, поэтому экспорт не удался"),
        "of_stickers": m0,
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "open_in_browser":
            MessageLookupByLibrary.simpleMessage("Открыть в браузере"),
        "out_of": MessageLookupByLibrary.simpleMessage("из"),
        "prepare_pack":
            MessageLookupByLibrary.simpleMessage("Подготовьте набор"),
        "resume": MessageLookupByLibrary.simpleMessage("Продолжить"),
        "retrying": MessageLookupByLibrary.simpleMessage("Пробуем ещё раз..."),
        "select_all": MessageLookupByLibrary.simpleMessage("Выбрать всё"),
        "sominemo": MessageLookupByLibrary.simpleMessage("Sominemo"),
        "sominemo_desc": MessageLookupByLibrary.simpleMessage("Разработчик"),
        "start": MessageLookupByLibrary.simpleMessage("Начать"),
        "still": MessageLookupByLibrary.simpleMessage("Статичный"),
        "stop": MessageLookupByLibrary.simpleMessage("Стоп"),
        "stop_export_confirm": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите остановить экспорт?"),
        "telegram_info": MessageLookupByLibrary.simpleMessage("Telegram Info"),
        "telegram_info_desc": MessageLookupByLibrary.simpleMessage("Наш канал"),
        "tginfo_link":
            MessageLookupByLibrary.simpleMessage("https://t.me/tginfo"),
        "tginfo_sticker_importer": MessageLookupByLibrary.simpleMessage(
            "Telegram Info Sticker Importer"),
        "unit_b": MessageLookupByLibrary.simpleMessage("B"),
        "unit_gb": MessageLookupByLibrary.simpleMessage("GB"),
        "unit_kb": MessageLookupByLibrary.simpleMessage("KB"),
        "unit_mb": MessageLookupByLibrary.simpleMessage("MB"),
        "update": MessageLookupByLibrary.simpleMessage("Обновление"),
        "version": MessageLookupByLibrary.simpleMessage("Версия"),
        "warming_up": MessageLookupByLibrary.simpleMessage("Подготовка..."),
        "welcome": MessageLookupByLibrary.simpleMessage("Добро пожаловать"),
        "welcome_screen_description": MessageLookupByLibrary.simpleMessage(
            "Давайте перенесём ваши стикеры из ВКонтакте в Telegram"),
        "with_border": MessageLookupByLibrary.simpleMessage("С обводкой")
      };
}
