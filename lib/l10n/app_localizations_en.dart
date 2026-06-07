// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ToiletFinder';

  @override
  String get login => 'Login with Passkey';

  @override
  String get register => 'Register with Passkey';

  @override
  String get username => 'Username';

  @override
  String get enterUsername => 'Enter username';

  @override
  String get securePasswordless => 'Secure passwordless authentication';

  @override
  String get findNearby => 'Find clean public restrooms nearby';

  @override
  String get language => 'Language';

  @override
  String get toiletMap => 'Toilet Map';

  @override
  String get approved => 'Approved';

  @override
  String get accessible => 'Accessible';

  @override
  String get free => 'Free';

  @override
  String get createToilet => 'Create Toilet';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get address => 'Address';

  @override
  String get accessType => 'Access Type';

  @override
  String get freeAccess => 'Free';

  @override
  String get paidAccess => 'Paid';

  @override
  String get customersOnly => 'Customers Only';

  @override
  String get wheelchairAccessible => 'Wheelchair Accessible';

  @override
  String get create => 'Create';

  @override
  String get approvedStatus => 'Approved';

  @override
  String get pendingApproval => 'Pending approval';

  @override
  String get approveToilet => 'Approve Toilet';

  @override
  String get navigate => 'Navigate';

  @override
  String get communityFeedback => 'Community feedback';

  @override
  String get clean => 'Clean';

  @override
  String get dirty => 'Dirty';

  @override
  String get safe => 'Safe';

  @override
  String get warm => 'Warm';

  @override
  String get hasPaper => 'Has paper';

  @override
  String get addressLabel => 'Address';

  @override
  String get unknown => 'Unknown';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get accessibilityLabel => 'Accessibility';

  @override
  String get wheelchairAccessibleValue => 'Wheelchair accessible';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get accessLabel => 'Access';

  @override
  String get helpKeepMapAccurate => 'Help keep the map accurate';

  @override
  String get stillExists => 'Still exists';

  @override
  String get notThere => 'Not there';

  @override
  String get verifiedRecently => 'Verified by community recently';

  @override
  String lastConfirmed(Object time) {
    return 'Last confirmed $time';
  }

  @override
  String metersAway(Object count) {
    return '$count m away';
  }

  @override
  String kmAway(Object count) {
    return '$count km away';
  }

  @override
  String get userAlreadyApproved => 'You already approved this toilet';

  @override
  String get toiletAlreadyApproved => 'This toilet is already approved';

  @override
  String get unknownError => 'Something went wrong';

  @override
  String get needsRevalidation => 'Needs re-validation';

  @override
  String get onboardingWelcomeTitle => 'Welcome';

  @override
  String get onboardingWelcomeDescription => 'Toilet Map is a community-driven map of public toilets.';

  @override
  String get onboardingAddTitle => 'Add Toilets';

  @override
  String get onboardingAddDescription => 'Long tap on the map to add a new toilet.';

  @override
  String get onboardingStatusesTitle => 'Statuses';

  @override
  String get onboardingStatusesDescription => 'Green, orange and red markers show toilet status.';

  @override
  String get onboardingCommunityTitle => 'Community';

  @override
  String get onboardingCommunityDescription => 'Every contribution helps improve the map for everyone.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Start';

  @override
  String get userAlreadyReported => 'You already reported this toilet';

  @override
  String get photoLimitExceeded => 'Maximum 2 photos allowed';

  @override
  String get photosOnlyForApproved => 'Photos can only be added to approved toilets';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get approveSuccess => 'Thanks! Your confirmation has been recorded.';

  @override
  String get reportSuccess => 'Thanks! Your report has been submitted.';

  @override
  String get createSuccess => 'Toilet successfully added.';

  @override
  String get onboardingColorsTitle => 'What do the colors mean?';

  @override
  String get onboardingColorsDescription => '🟠 Orange — waiting for verification\n\n🟢 Green — verified by the community\n\n🔴 Red — needs re-validation';

  @override
  String get onboardingApproveTitle => 'Verify toilets';

  @override
  String get onboardingApproveDescription => 'Several confirmations from users make a toilet trusted and verified.';

  @override
  String get onboardingPhotosTitle => 'Add photos';

  @override
  String get onboardingPhotosDescription => 'After a toilet is verified by the community, photos can be added to help other users.';

  @override
  String get onboardingFeedbackTitle => 'Leave feedback';

  @override
  String get onboardingFeedbackDescription => 'Tell others whether the toilet is clean, has paper, is warm and feels safe.';

  @override
  String get onboardingReportTitle => 'Report problems';

  @override
  String get onboardingReportDescription => 'If a toilet no longer exists or information is outdated, submit a report for re-validation.';

  @override
  String get onboardingTogetherTitle => 'Thank you';

  @override
  String get onboardingTogetherDescription => 'Every confirmation, every review and every new toilet helps make the map better for everyone.';

  @override
  String get onboardingOpenMap => 'Open Map';

  @override
  String get toiletCreateLimitExceeded => 'You have reached the toilet creation limit.';

  @override
  String get toiletApproveLimitExceeded => 'You have reached the toilet approval limit.';

  @override
  String get toiletReportLimitExceeded => 'You have reached the report limit.';

  @override
  String get toiletFeedbackLimitExceeded => 'You have reached the feedback limit.';

  @override
  String tryAgainInSeconds(int seconds) {
    return 'Try again in $seconds seconds.';
  }

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get messageType => 'Message type';

  @override
  String get suggestion => 'Suggestion';

  @override
  String get complaint => 'Complaint';

  @override
  String get bug => 'Bug';

  @override
  String get other => 'Other';

  @override
  String get message => 'Message';

  @override
  String get messageHint => 'Describe your idea, complaint or bug...';

  @override
  String get send => 'Send';

  @override
  String get messageCannotBeEmpty => 'Message cannot be empty';

  @override
  String get feedbackSent => 'Thank you for your feedback!';

  @override
  String get feedbackFailed => 'Failed to send message';
}
