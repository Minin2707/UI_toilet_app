// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'ToiletFinder';

  @override
  String get login => 'Войти через Passkey';

  @override
  String get register => 'Зарегистрироваться через Passkey';

  @override
  String get username => 'Имя пользователя';

  @override
  String get enterUsername => 'Введите имя пользователя';

  @override
  String get securePasswordless => 'Безопасная аутентификация без пароля';

  @override
  String get findNearby => 'Находите чистые общественные туалеты рядом';

  @override
  String get language => 'Язык';

  @override
  String get toiletMap => 'Карта туалетов';

  @override
  String get approved => 'Проверенные';

  @override
  String get accessible => 'Доступные';

  @override
  String get free => 'Бесплатные';

  @override
  String get createToilet => 'Добавить туалет';

  @override
  String get title => 'Название';

  @override
  String get description => 'Описание';

  @override
  String get address => 'Адрес';

  @override
  String get accessType => 'Тип доступа';

  @override
  String get freeAccess => 'Бесплатный';

  @override
  String get paidAccess => 'Платный';

  @override
  String get customersOnly => 'Только для клиентов';

  @override
  String get wheelchairAccessible => 'Доступен для инвалидной коляски';

  @override
  String get create => 'Создать';

  @override
  String get approvedStatus => 'Проверен';

  @override
  String get pendingApproval => 'Ожидает проверки';

  @override
  String get approveToilet => 'Подтвердить туалет';

  @override
  String get navigate => 'Маршрут';

  @override
  String get communityFeedback => 'Отзывы сообщества';

  @override
  String get clean => 'Чисто';

  @override
  String get dirty => 'Грязно';

  @override
  String get safe => 'Безопасно';

  @override
  String get warm => 'Тепло';

  @override
  String get hasPaper => 'Есть бумага';

  @override
  String get addressLabel => 'Адрес';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get distanceLabel => 'Расстояние';

  @override
  String get accessibilityLabel => 'Доступность';

  @override
  String get wheelchairAccessibleValue => 'Доступно для инвалидной коляски';

  @override
  String get notSpecified => 'Не указано';

  @override
  String get accessLabel => 'Доступ';

  @override
  String get helpKeepMapAccurate => 'Помогите поддерживать карту актуальной';

  @override
  String get stillExists => 'Существует';

  @override
  String get notThere => 'Туалета нет';

  @override
  String get verifiedRecently => 'Недавно подтверждено сообществом';

  @override
  String lastConfirmed(Object time) {
    return 'Последнее подтверждение $time';
  }

  @override
  String metersAway(Object count) {
    return '$count м';
  }

  @override
  String kmAway(Object count) {
    return '$count км';
  }

  @override
  String get userAlreadyApproved => 'Вы уже подтверждали этот туалет';

  @override
  String get toiletAlreadyApproved => 'Этот туалет уже подтвержден';

  @override
  String get unknownError => 'Что-то пошло не так';

  @override
  String get needsRevalidation => 'Требуется повторная проверка';

  @override
  String get onboardingWelcomeTitle => 'Добро пожаловать';

  @override
  String get onboardingWelcomeDescription => 'Toilet Map — это карта общественных туалетов, созданная сообществом.';

  @override
  String get onboardingAddTitle => 'Добавление туалетов';

  @override
  String get onboardingAddDescription => 'Долгий тап по карте создаёт новый туалет.';

  @override
  String get onboardingStatusesTitle => 'Статусы';

  @override
  String get onboardingStatusesDescription => 'Зелёные, оранжевые и красные маркеры показывают статус туалета.';

  @override
  String get onboardingCommunityTitle => 'Сообщество';

  @override
  String get onboardingCommunityDescription => 'Каждый вклад помогает сделать карту лучше для всех.';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingStart => 'Начать';

  @override
  String get userAlreadyReported => 'Вы уже жаловались на этот туалет';

  @override
  String get photoLimitExceeded => 'Можно загрузить максимум 2 фотографии';

  @override
  String get photosOnlyForApproved => 'Фотографии можно добавлять только к подтверждённым туалетам';
}
