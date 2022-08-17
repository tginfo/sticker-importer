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
        "add_account": MessageLookupByLibrary.simpleMessage("Добавить аккаунт"),
        "animated": MessageLookupByLibrary.simpleMessage("Анимированный"),
        "animated_pack":
            MessageLookupByLibrary.simpleMessage("Анимированный набор"),
        "animated_pack_info": MessageLookupByLibrary.simpleMessage(
            "Этот набор – анимированный. Желаете экспортировать стикеры в виде анимаций, или статичных изображений?"),
        "by_link": MessageLookupByLibrary.simpleMessage("По ссылке"),
        "call": MessageLookupByLibrary.simpleMessage("Звонок"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "captcha": MessageLookupByLibrary.simpleMessage("Подтверждение"),
        "captcha_fail": MessageLookupByLibrary.simpleMessage(
            "Не удалось подтвердить, что вы не робот"),
        "check_the_link": MessageLookupByLibrary.simpleMessage(
            "Проверьте правильность ссылки"),
        "choose_emoji": MessageLookupByLibrary.simpleMessage("Выбор эмодзи"),
        "code": MessageLookupByLibrary.simpleMessage("Код"),
        "confirmation": MessageLookupByLibrary.simpleMessage("Подтверждение"),
        "continue_btn": MessageLookupByLibrary.simpleMessage("Продолжить"),
        "copy": MessageLookupByLibrary.simpleMessage("Копировать"),
        "customize_your_pack":
            MessageLookupByLibrary.simpleMessage("Настройте под себя"),
        "customize_your_pack_info": MessageLookupByLibrary.simpleMessage(
            "Выберите, какие стикеры Вы желаете импортировать и присвойте им соответствующие эмодзи для быстрого доступа"),
        "delete_account_confirm": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите выйти?"),
        "detailed_logging": MessageLookupByLibrary.simpleMessage("Отладка"),
        "detailed_logging_info":
            MessageLookupByLibrary.simpleMessage("Потребляет много ОЗУ"),
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
        "follow_tginfo":
            MessageLookupByLibrary.simpleMessage("Подписаться на @tginfo"),
        "github": MessageLookupByLibrary.simpleMessage("GitHub"),
        "go_back": MessageLookupByLibrary.simpleMessage("Назад"),
        "go_to_vk_id": MessageLookupByLibrary.simpleMessage("Перейти в VK ID"),
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
        "logs_save_error": m0,
        "logs_saved_to": m1,
        "no_error_details": MessageLookupByLibrary.simpleMessage(
            "Нет дополнительных сведений об этой ошибке"),
        "no_recents": MessageLookupByLibrary.simpleMessage("История пуста"),
        "not_all_animated": MessageLookupByLibrary.simpleMessage(
            "Не все анимированные стикеры из ВКонтакте поддерживаются в Telegram, такие стикеры будут автоматически исключены. Некоторые наборы не получится импортировать вовсе"),
        "not_installed": MessageLookupByLibrary.simpleMessage(
            "Telegram не установлен на Вашем устройстве, поэтому экспорт не удался"),
        "of_stickers": m2,
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "open_in_browser":
            MessageLookupByLibrary.simpleMessage("Открыть в браузере"),
        "out_of": MessageLookupByLibrary.simpleMessage("из"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "prepare_pack":
            MessageLookupByLibrary.simpleMessage("Подготовьте набор"),
        "resume": MessageLookupByLibrary.simpleMessage("Продолжить"),
        "retrying": MessageLookupByLibrary.simpleMessage("Пробуем ещё раз..."),
        "save_logs": MessageLookupByLibrary.simpleMessage("Сохранить логи"),
        "select_all": MessageLookupByLibrary.simpleMessage("Выбрать всё"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Войти"),
        "sms": MessageLookupByLibrary.simpleMessage("SMS"),
        "sominemo": MessageLookupByLibrary.simpleMessage("Sominemo"),
        "sominemo_desc": MessageLookupByLibrary.simpleMessage("Разработчик"),
        "source_code": MessageLookupByLibrary.simpleMessage("Исходный код"),
        "start": MessageLookupByLibrary.simpleMessage("Начать"),
        "sticker_styles":
            MessageLookupByLibrary.simpleMessage("Стиль стикеров"),
        "sticker_styles_info": MessageLookupByLibrary.simpleMessage(
            "Этот набор имеет несколько стилей. Какой Вы желаете использовать?"),
        "still": MessageLookupByLibrary.simpleMessage("Статичный"),
        "stop": MessageLookupByLibrary.simpleMessage("Стоп"),
        "stop_export_confirm": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите остановить экспорт?"),
        "t_continue": MessageLookupByLibrary.simpleMessage("Продолжить"),
        "telegram_info": MessageLookupByLibrary.simpleMessage("Telegram Info"),
        "telegram_info_desc": MessageLookupByLibrary.simpleMessage("Наш канал"),
        "tginfo_link":
            MessageLookupByLibrary.simpleMessage("https://t.me/tginfo"),
        "tginfo_sticker_importer":
            MessageLookupByLibrary.simpleMessage("Sticker Importer"),
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
        "warming_up": MessageLookupByLibrary.simpleMessage("Подготовка..."),
        "welcome": MessageLookupByLibrary.simpleMessage("Добро пожаловать"),
        "welcome_screen_description": MessageLookupByLibrary.simpleMessage(
            "Давайте перенесём ваши стикеры из ВКонтакте и LINE в Telegram"),
        "with_border": MessageLookupByLibrary.simpleMessage("С обводкой")
      };
}
