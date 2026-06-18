import 'package:shared_preferences/shared_preferences.dart';

class OnboardingStorage {
  static const _key = 'onboarding_completed';

  Future<void> completeOnboarding() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _key,
      true,
    );
  }

  Future<bool> isCompleted() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_key)
        ?? false;
  }

  Future<void> reset() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
