import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'ToiletFinder'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login with Passkey'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register with Passkey'**
  String get register;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// No description provided for @securePasswordless.
  ///
  /// In en, this message translates to:
  /// **'Secure passwordless authentication'**
  String get securePasswordless;

  /// No description provided for @findNearby.
  ///
  /// In en, this message translates to:
  /// **'Find clean public restrooms nearby'**
  String get findNearby;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @toiletMap.
  ///
  /// In en, this message translates to:
  /// **'Toilet Map'**
  String get toiletMap;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @accessible.
  ///
  /// In en, this message translates to:
  /// **'Accessible'**
  String get accessible;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @createToilet.
  ///
  /// In en, this message translates to:
  /// **'Create Toilet'**
  String get createToilet;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @accessType.
  ///
  /// In en, this message translates to:
  /// **'Access Type'**
  String get accessType;

  /// No description provided for @freeAccess.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freeAccess;

  /// No description provided for @paidAccess.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidAccess;

  /// No description provided for @customersOnly.
  ///
  /// In en, this message translates to:
  /// **'Customers Only'**
  String get customersOnly;

  /// No description provided for @wheelchairAccessible.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair Accessible'**
  String get wheelchairAccessible;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @approvedStatus.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approvedStatus;

  /// No description provided for @pendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending approval'**
  String get pendingApproval;

  /// No description provided for @approveToilet.
  ///
  /// In en, this message translates to:
  /// **'Approve Toilet'**
  String get approveToilet;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @communityFeedback.
  ///
  /// In en, this message translates to:
  /// **'Community feedback'**
  String get communityFeedback;

  /// No description provided for @clean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get clean;

  /// No description provided for @dirty.
  ///
  /// In en, this message translates to:
  /// **'Dirty'**
  String get dirty;

  /// No description provided for @safe.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get safe;

  /// No description provided for @warm.
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get warm;

  /// No description provided for @hasPaper.
  ///
  /// In en, this message translates to:
  /// **'Has paper'**
  String get hasPaper;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @accessibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibilityLabel;

  /// No description provided for @wheelchairAccessibleValue.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair accessible'**
  String get wheelchairAccessibleValue;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @accessLabel.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get accessLabel;

  /// No description provided for @helpKeepMapAccurate.
  ///
  /// In en, this message translates to:
  /// **'Help keep the map accurate'**
  String get helpKeepMapAccurate;

  /// No description provided for @stillExists.
  ///
  /// In en, this message translates to:
  /// **'Still exists'**
  String get stillExists;

  /// No description provided for @notThere.
  ///
  /// In en, this message translates to:
  /// **'Not there'**
  String get notThere;

  /// No description provided for @verifiedRecently.
  ///
  /// In en, this message translates to:
  /// **'Verified by community recently'**
  String get verifiedRecently;

  /// No description provided for @lastConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Last confirmed {time}'**
  String lastConfirmed(Object time);

  /// No description provided for @metersAway.
  ///
  /// In en, this message translates to:
  /// **'{count} m away'**
  String metersAway(Object count);

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'{count} km away'**
  String kmAway(Object count);

  /// No description provided for @userAlreadyApproved.
  ///
  /// In en, this message translates to:
  /// **'You already approved this toilet'**
  String get userAlreadyApproved;

  /// No description provided for @toiletAlreadyApproved.
  ///
  /// In en, this message translates to:
  /// **'This toilet is already approved'**
  String get toiletAlreadyApproved;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get unknownError;

  /// No description provided for @needsRevalidation.
  ///
  /// In en, this message translates to:
  /// **'Needs re-validation'**
  String get needsRevalidation;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Toilet Map is a community-driven map of public toilets.'**
  String get onboardingWelcomeDescription;

  /// No description provided for @onboardingAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Toilets'**
  String get onboardingAddTitle;

  /// No description provided for @onboardingAddDescription.
  ///
  /// In en, this message translates to:
  /// **'Long tap on the map to add a new toilet.'**
  String get onboardingAddDescription;

  /// No description provided for @onboardingStatusesTitle.
  ///
  /// In en, this message translates to:
  /// **'Statuses'**
  String get onboardingStatusesTitle;

  /// No description provided for @onboardingStatusesDescription.
  ///
  /// In en, this message translates to:
  /// **'Green, orange and red markers show toilet status.'**
  String get onboardingStatusesDescription;

  /// No description provided for @onboardingCommunityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get onboardingCommunityTitle;

  /// No description provided for @onboardingCommunityDescription.
  ///
  /// In en, this message translates to:
  /// **'Every contribution helps improve the map for everyone.'**
  String get onboardingCommunityDescription;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingStart;

  /// No description provided for @userAlreadyReported.
  ///
  /// In en, this message translates to:
  /// **'You already reported this toilet'**
  String get userAlreadyReported;

  /// No description provided for @photoLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'Maximum 2 photos allowed'**
  String get photoLimitExceeded;

  /// No description provided for @photosOnlyForApproved.
  ///
  /// In en, this message translates to:
  /// **'Photos can only be added to approved toilets'**
  String get photosOnlyForApproved;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
