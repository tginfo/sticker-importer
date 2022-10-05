// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(error) => "Ошибка сохранения логов: ${error}";

  static String m1(path) => "Логи сохранены в ${path}";

  static String m2(count) =>
      "${Intl.plural(count, zero: 'стикеров', one: 'стикер', two: 'стикера', few: 'стикеров', many: 'стикеров', other: 'стикеров')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_program": MessageLookupByLibrary.simpleMessage("О программе"),
        "activity": MessageLookupByLibrary.simpleMessage("Занятия"),
        "add_account": MessageLookupByLibrary.simpleMessage("Добавить аккаунт"),
        "all_stickers": MessageLookupByLibrary.simpleMessage("Все стикеры"),
        "and_also": MessageLookupByLibrary.simpleMessage("а также"),
        "animals_and_nature":
            MessageLookupByLibrary.simpleMessage("Животные и природа"),
        "animated": MessageLookupByLibrary.simpleMessage("Анимированный"),
        "animated_pack":
            MessageLookupByLibrary.simpleMessage("Анимированный набор"),
        "animated_pack_info": MessageLookupByLibrary.simpleMessage(
            "Этот набор – анимированный. Желаете экспортировать стикеры в виде анимаций, или статичных изображений?"),
        "animated_stickers_support_note":
            MessageLookupByLibrary.simpleMessage("Анимированные стикеры"),
        "animated_stickers_support_note_text": MessageLookupByLibrary.simpleMessage(
            "Этот набор – анимированный. Вы можете экспортировать стикеры в виде анимаций, или статичных изображений."),
        "auth_code": MessageLookupByLibrary.simpleMessage("Код"),
        "by_link": MessageLookupByLibrary.simpleMessage("По ссылке"),
        "call": MessageLookupByLibrary.simpleMessage("Звонок"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "captcha": MessageLookupByLibrary.simpleMessage("Подтверждение"),
        "captcha_fail": MessageLookupByLibrary.simpleMessage(
            "Не удалось подтвердить, что вы не робот"),
        "check_the_link": MessageLookupByLibrary.simpleMessage(
            "Проверьте правильность ссылки"),
        "choose_account":
            MessageLookupByLibrary.simpleMessage("Выберите аккаунт"),
        "choose_emoji": MessageLookupByLibrary.simpleMessage("Выбор эмодзи"),
        "code": MessageLookupByLibrary.simpleMessage("ru"),
        "confirmation": MessageLookupByLibrary.simpleMessage("Подтверждение"),
        "continue_btn": MessageLookupByLibrary.simpleMessage("Продолжить"),
        "continue_importing":
            MessageLookupByLibrary.simpleMessage("Продолжить импорт"),
        "copy": MessageLookupByLibrary.simpleMessage("Копировать"),
        "customize_your_pack":
            MessageLookupByLibrary.simpleMessage("Настройте под себя"),
        "customize_your_pack_info": MessageLookupByLibrary.simpleMessage(
            "Выберите, какие стикеры Вы желаете импортировать, и присвойте им соответствующие эмодзи для быстрого доступа"),
        "delete_account_confirm": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите выйти?"),
        "detailed_logging": MessageLookupByLibrary.simpleMessage("Отладка"),
        "detailed_logging_info":
            MessageLookupByLibrary.simpleMessage("Потребляет много ОЗУ"),
        "details": MessageLookupByLibrary.simpleMessage("Подробности"),
        "do_not_ask_again":
            MessageLookupByLibrary.simpleMessage("Больше не спрашивать"),
        "donate": MessageLookupByLibrary.simpleMessage("Пожертвование"),
        "done": MessageLookupByLibrary.simpleMessage("Готово"),
        "done_exc": MessageLookupByLibrary.simpleMessage("Готово!"),
        "done_exc_block1": MessageLookupByLibrary.simpleMessage(
            "Благодарим за использование Sticker Importer. Данная программа разработана Telegram Info."),
        "done_exc_block2": MessageLookupByLibrary.simpleMessage(
            "Telegram Info это некоммерческий проект, который существует только благодаря вашей поддержке. Наша цель — доносить информацию о Telegram и его сервисах, делая их более открытыми и доступными."),
        "download": MessageLookupByLibrary.simpleMessage("Скачать"),
        "downloaded_n": MessageLookupByLibrary.simpleMessage("Загружено"),
        "emoji_type_to_search":
            MessageLookupByLibrary.simpleMessage("Печатайте, чтобы искать"),
        "enable_sticker":
            MessageLookupByLibrary.simpleMessage("Включить стикер"),
        "enter_code_from_app": MessageLookupByLibrary.simpleMessage(
            "Введите код из сообщения, отправленного в приложение ВКонтакте"),
        "enter_code_from_img": MessageLookupByLibrary.simpleMessage(
            "Введите код с картинки, чтобы продолжить"),
        "enter_code_from_sms": MessageLookupByLibrary.simpleMessage(
            "Введите код из SMS, отправленной на ваш телефон"),
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
        "feedback_desc": MessageLookupByLibrary.simpleMessage(
            "Если у вас есть вопросы или предложения, напишите нам"),
        "feedback_url": MessageLookupByLibrary.simpleMessage(
            "https://t.me/infowritebot?start=stickerimporter"),
        "field_required":
            MessageLookupByLibrary.simpleMessage("Обязательное поле"),
        "fill_all_fields":
            MessageLookupByLibrary.simpleMessage("Заполните все поля"),
        "flags": MessageLookupByLibrary.simpleMessage("Флаги"),
        "follow_tginfo":
            MessageLookupByLibrary.simpleMessage("Подписаться на @tginfo"),
        "food_and_drink": MessageLookupByLibrary.simpleMessage("Еда и напитки"),
        "github": MessageLookupByLibrary.simpleMessage("GitHub"),
        "go_back": MessageLookupByLibrary.simpleMessage("Назад"),
        "go_to_vk_id": MessageLookupByLibrary.simpleMessage("Перейти в VK ID"),
        "i_changed_my_mind":
            MessageLookupByLibrary.simpleMessage("Я передумал"),
        "import_settings":
            MessageLookupByLibrary.simpleMessage("Настройка импорта"),
        "import_to_telegram":
            MessageLookupByLibrary.simpleMessage("Импортировать в Telegram"),
        "internet_error_info": MessageLookupByLibrary.simpleMessage(
            "Запрос не удался. Проверьте подключение к интернету и попробуйте еще раз"),
        "internet_error_title":
            MessageLookupByLibrary.simpleMessage("Ошибка соединения"),
        "licenses": MessageLookupByLibrary.simpleMessage("Лицензии"),
        "licenses_desc":
            MessageLookupByLibrary.simpleMessage("Открытого исходного кода"),
        "link": MessageLookupByLibrary.simpleMessage("Ссылка на стикерпак"),
        "link_incorrect":
            MessageLookupByLibrary.simpleMessage("Ссылка некорректна"),
        "link_not_pack_line": MessageLookupByLibrary.simpleMessage(
            "Ссылка не является стикерпаком LINE"),
        "link_not_pack_vk": MessageLookupByLibrary.simpleMessage(
            "Ссылка не является стикерпаком ВКонтакте"),
        "loading": MessageLookupByLibrary.simpleMessage("Загрузка"),
        "logged_in": MessageLookupByLibrary.simpleMessage("Вход выполнен"),
        "login":
            MessageLookupByLibrary.simpleMessage("Логин или номер телефона"),
        "login_with_vk_to":
            MessageLookupByLibrary.simpleMessage("Войдите ВКонтакте чтобы:"),
        "login_with_vk_to_library": MessageLookupByLibrary.simpleMessage(
            "Получить доступ к добавленным наборам стикеров"),
        "login_with_vk_to_search": MessageLookupByLibrary.simpleMessage(
            "Искать стикеры по ключевым словам и эмодзи"),
        "login_with_vk_to_store": MessageLookupByLibrary.simpleMessage(
            "Просматривать популярные наборы"),
        "login_with_vk_to_suggestions": MessageLookupByLibrary.simpleMessage(
            "Заполнять подсказки стикеров автоматически"),
        "login_with_vk_to_vmoji":
            MessageLookupByLibrary.simpleMessage("Импортировать наборы vmoji"),
        "logs_save_error": m0,
        "logs_saved_to": m1,
        "my_stickers": MessageLookupByLibrary.simpleMessage("Мои стикеры"),
        "no_emoji_matches":
            MessageLookupByLibrary.simpleMessage("Нет подходящих эмодзи"),
        "no_error_details": MessageLookupByLibrary.simpleMessage(
            "Нет дополнительных сведений об этой ошибке"),
        "no_recent_emoji":
            MessageLookupByLibrary.simpleMessage("Нет недавних эмодзи"),
        "no_recent_emoji_help": MessageLookupByLibrary.simpleMessage(
            "Вы можете искать эмодзи по категориям, или воспользоваться текстовым поиском"),
        "no_recents": MessageLookupByLibrary.simpleMessage("История пуста"),
        "no_sticker_search_results":
            MessageLookupByLibrary.simpleMessage("Таких стикеров не найдено"),
        "not_all_animated": MessageLookupByLibrary.simpleMessage(
            "Не все анимированные стикеры из ВКонтакте поддерживаются в Telegram, такие стикеры будут автоматически исключены. Некоторые наборы не получится импортировать вовсе"),
        "not_installed": MessageLookupByLibrary.simpleMessage(
            "Telegram не установлен на Вашем устройстве, поэтому экспорт не удался"),
        "objects": MessageLookupByLibrary.simpleMessage("Предметы"),
        "of_stickers": m2,
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "open_in_browser":
            MessageLookupByLibrary.simpleMessage("Открыть в браузере"),
        "out_of": MessageLookupByLibrary.simpleMessage("из"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "pick_emoji": MessageLookupByLibrary.simpleMessage(
            "Выберите несколько эмодзи, которые будут использоваться для подсказок стикеров в Telegram"),
        "prepare_pack":
            MessageLookupByLibrary.simpleMessage("Подготовьте набор"),
        "recent_emoji": MessageLookupByLibrary.simpleMessage("Недавние эмодзи"),
        "remove": MessageLookupByLibrary.simpleMessage("Удалить"),
        "resume": MessageLookupByLibrary.simpleMessage("Продолжить"),
        "retrying": MessageLookupByLibrary.simpleMessage("Пробуем ещё раз..."),
        "save_logs": MessageLookupByLibrary.simpleMessage("Сохранить логи"),
        "search_results":
            MessageLookupByLibrary.simpleMessage("Результаты поиска"),
        "select_all": MessageLookupByLibrary.simpleMessage("Выбрать всё"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Войти"),
        "sign_out": MessageLookupByLibrary.simpleMessage("Выйти"),
        "smileys_and_people":
            MessageLookupByLibrary.simpleMessage("Смайлы и люди"),
        "sms": MessageLookupByLibrary.simpleMessage("SMS"),
        "sominemo": MessageLookupByLibrary.simpleMessage("Sominemo"),
        "sominemo_desc": MessageLookupByLibrary.simpleMessage("Разработчик"),
        "source_code": MessageLookupByLibrary.simpleMessage("Исходный код"),
        "start": MessageLookupByLibrary.simpleMessage("Начать"),
        "start_typing_to_search_stickers": MessageLookupByLibrary.simpleMessage(
            "Начните печатать или выберите эмодзи, чтобы искать наборы и стикеры"),
        "sticker_pack": MessageLookupByLibrary.simpleMessage("Набор стикеров"),
        "sticker_search":
            MessageLookupByLibrary.simpleMessage("Поиск стикеров"),
        "sticker_store":
            MessageLookupByLibrary.simpleMessage("Магазин стикеров"),
        "sticker_styles":
            MessageLookupByLibrary.simpleMessage("Стиль стикеров"),
        "sticker_styles_info": MessageLookupByLibrary.simpleMessage(
            "Этот набор имеет несколько стилей. Какой Вы желаете использовать?"),
        "stickers_without_suggestions":
            MessageLookupByLibrary.simpleMessage("Стикеры без подсказок"),
        "stickers_without_suggestions_info": MessageLookupByLibrary.simpleMessage(
            "У некоторых стикеров нет подсказок, но вы можете добавить их вручную, нажав на иконку в правом нижнем углу стикера"),
        "still": MessageLookupByLibrary.simpleMessage("Статичный"),
        "stop": MessageLookupByLibrary.simpleMessage("Стоп"),
        "stop_export_confirm": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите остановить задачу?"),
        "symbols": MessageLookupByLibrary.simpleMessage("Символы"),
        "t_continue": MessageLookupByLibrary.simpleMessage("Продолжить"),
        "tap_to_change_account": MessageLookupByLibrary.simpleMessage(
            "Нажмите, чтобы сменить аккаунт"),
        "telegram_info": MessageLookupByLibrary.simpleMessage("Telegram Info"),
        "telegram_info_desc": MessageLookupByLibrary.simpleMessage("Наш канал"),
        "tginfo_link":
            MessageLookupByLibrary.simpleMessage("https://t.me/tginfo"),
        "tginfo_sticker_importer":
            MessageLookupByLibrary.simpleMessage("Sticker Importer"),
        "travel_and_places":
            MessageLookupByLibrary.simpleMessage("Места и путешествия"),
        "try_sending_request_again": MessageLookupByLibrary.simpleMessage(
            "Попробуйте отправить запрос еще раз"),
        "twofa_code_sent":
            MessageLookupByLibrary.simpleMessage("Новый код отправлен"),
        "twofa_codes_too_often": MessageLookupByLibrary.simpleMessage(
            "Вы запрашиваете коды слишком часто"),
        "twofa_failed": MessageLookupByLibrary.simpleMessage(
            "Ошибка двухфакторной аутентификации"),
        "unit_b": MessageLookupByLibrary.simpleMessage("B"),
        "unit_gb": MessageLookupByLibrary.simpleMessage("GB"),
        "unit_kb": MessageLookupByLibrary.simpleMessage("KB"),
        "unit_mb": MessageLookupByLibrary.simpleMessage("MB"),
        "update": MessageLookupByLibrary.simpleMessage("Обновление"),
        "version": MessageLookupByLibrary.simpleMessage("Версия"),
        "vk_account": MessageLookupByLibrary.simpleMessage("Аккаунт VK"),
        "vk_error_429": MessageLookupByLibrary.simpleMessage(
            "VK вернул ошибку 429: Превышен лимит запросов. Попробуйте использовать другое подключение (например, VPN, прокси и т.п.)"),
        "vk_id_security_link": MessageLookupByLibrary.simpleMessage(
            "https://id.vk.com/account/#/security"),
        "vk_id_setting_info": MessageLookupByLibrary.simpleMessage(
            "Отключите \"Защиту от подозрительных приложений\" в настройках VK ID, чтобы использовать эту функцию"),
        "vk_id_setting_title":
            MessageLookupByLibrary.simpleMessage("Обратите внимание"),
        "vk_login":
            MessageLookupByLibrary.simpleMessage("Авторизация ВКонтакте"),
        "vk_login_access": MessageLookupByLibrary.simpleMessage(
            "Получите доступ к своим наборам и магазину стикеров"),
        "vk_sticker_store":
            MessageLookupByLibrary.simpleMessage("Магазин стикеров ВКонтакте"),
        "vk_sticker_store_url": MessageLookupByLibrary.simpleMessage(
            "https://m.vk.com/stickers?tab=popular"),
        "vk_sticker_store_web":
            MessageLookupByLibrary.simpleMessage("Открыть магазин в браузере"),
        "vmoji": MessageLookupByLibrary.simpleMessage("VK Vmoji"),
        "warming_up": MessageLookupByLibrary.simpleMessage("Подготовка..."),
        "welcome": MessageLookupByLibrary.simpleMessage("Добро пожаловать"),
        "welcome_screen_description": MessageLookupByLibrary.simpleMessage(
            "Давайте перенесём ваши стикеры из ВКонтакте и LINE в Telegram"),
        "with_border": MessageLookupByLibrary.simpleMessage("С обводкой"),
        "with_border_info": MessageLookupByLibrary.simpleMessage(
            "Желаете импортировать стикеры такими, какие они есть, или с белой обводкой вокруг краёв?"),
        "with_border_title":
            MessageLookupByLibrary.simpleMessage("Обводка стикеров"),
        "with_emoji_suggestions":
            MessageLookupByLibrary.simpleMessage("С подсказками стикеров"),
        "without_border": MessageLookupByLibrary.simpleMessage("Без обводки")
      };
}
