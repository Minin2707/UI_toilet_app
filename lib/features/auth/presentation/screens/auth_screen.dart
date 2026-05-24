import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/localization/locale_state.dart';
import '../../../../l10n/app_localizations.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() =>
      _AuthScreenState();
}

class _AuthScreenState
    extends State<AuthScreen>
    with SingleTickerProviderStateMixin {

  final TextEditingController
      _usernameController =
          TextEditingController();

  late final AnimationController
      _animationController;

  late final Animation<double>
      _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  Future<void> _openAuthWebView({
    required bool isRegister,
  }) async {

    final username =
        _usernameController.text.trim();

    if (username.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(
            AppLocalizations.of(context)!.enterUsername,
          ),
        ),
      );

      return;
    }

    final mode =
        isRegister
            ? 'register'
            : 'login';

    final url = Uri.parse(
      '${AppConfig.instance.baseUrl}/auth.html?username=$username&mode=$mode',
    );

    await launchUrl(
      url,
      mode: LaunchMode.platformDefault,
    );
  }

  @override
  Widget build(BuildContext context) {

        return Scaffold(

      body: Stack(
        children: [

          // BACKGROUND

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF07111A),
                  Color(0xFF0B1F2E),
                  Color(0xFF12344A),
                ],
              ),
            ),
          ),

          // GLOW CIRCLES

          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan.withOpacity(0.15),
              ),
            ),
          ),

          Positioned(
            bottom: -140,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent.withOpacity(0.12),
              ),
            ),
          ),

          // CONTENT

          SafeArea(
            child: SingleChildScrollView(

              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context)
                        .viewInsets
                        .bottom,
              ),

              child: SizedBox(

                height:
                    MediaQuery.of(context)
                        .size
                        .height,

                child: Center(

                  child: Padding(
                    padding: const EdgeInsets.all(24),

                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(32),

                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 18,
                          sigmaY: 18,
                        ),

                        child: Container(

                          width: double.infinity,

                          padding: const EdgeInsets.all(28),

                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(32),

                            color: Colors.white.withOpacity(0.10),

                            border: Border.all(
                              color:
                                  Colors.white.withOpacity(0.15),
                            ),
                          ),

                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [

                              // FLOATING ICON

                              AnimatedBuilder(
                                animation: _floatingAnimation,

                                builder: (context, child) {

                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      _floatingAnimation.value,
                                    ),

                                    child: child,
                                  );
                                },

                                child: Container(
                                  width: 110,
                                  height: 110,

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.12),
                                  ),

                                  child: const Icon(
                                    Icons.wc,
                                    size: 58,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),

                              const Text(
                                'ToiletFinder',

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                AppLocalizations.of(context)!.findNearby,

                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 34),

                              // USERNAME FIELD

                              TextField(
                                controller:
                                    _usernameController,

                                style: TextStyle(
                                  color: Colors.white,
                                ),

                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.username,

                                  hintStyle: TextStyle(
                                    color:
                                        Colors.white.withOpacity(0.55),
                                  ),

                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                  ),

                                  filled: true,

                                  fillColor:
                                      Colors.white.withOpacity(0.08),

                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(18),

                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 26),

                              // REGISTER BUTTON

                              SizedBox(
                                width: double.infinity,
                                height: 58,

                                child: FilledButton.icon(

                                  onPressed: () {
                                    _openAuthWebView(
                                      isRegister: true,
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.fingerprint,
                                  ),

                                  label: Text(
                                    //'Register with Passkey',
                                    AppLocalizations.of(context)!.register,
                                  ),

                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        Colors.cyanAccent.shade400,

                                    foregroundColor:
                                        Colors.black,

                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),

                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // LOGIN BUTTON

                              SizedBox(
                                width: double.infinity,
                                height: 58,

                                child: OutlinedButton.icon(

                                  onPressed: () {
                                    _openAuthWebView(
                                      isRegister: false,
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.login,
                                  ),

                                  label: Text(
                                    //'Login with Passkey',
                                    AppLocalizations.of(context)!.login,
                                  ),

                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,

                                    side: BorderSide(
                                      color:
                                          Colors.white.withOpacity(0.35),
                                    ),

                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),

                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              Text(
                                AppLocalizations.of(context)!.securePasswordless,

                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.55),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
                              top: 20,
                              right: 20,

                              child: Material(
                                color: Colors.transparent,

                              child: SafeArea(

                                child: BlocBuilder<
                                    LocaleCubit,
                                    LocaleState>(

                                  builder: (
                                    context,
                                    state,
                                  ) {

                                    final isRussian =
                                        state.languageCode == 'ru';

                                    return InkWell(
                                      borderRadius:
                                            BorderRadius.circular(14),

                                      onTap: () {

                                        final cubit =
                                            BlocProvider.of<LocaleCubit>(
                                              context,
                                            );

                                        cubit.toggleLocale();
                                        debugPrint('LANGUAGE TOGGLED');
                                      },

                                      child: Container(

                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),

                                        decoration: BoxDecoration(

                                          color:
                                              Colors.white.withOpacity(0.12),

                                          borderRadius:
                                              BorderRadius.circular(14),

                                          border: Border.all(
                                            color: Colors.white24,
                                          ),
                                        ),

                                        child: Text(

                                          isRussian
                                              ? 'EN'
                                              : 'RU',

                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                             ),
                            ),
                ],
              ),
            );
          }
        }