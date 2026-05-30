import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/onboarding_storage.dart';
import '../../data/models/onboarding_page_data.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingScreen
    extends StatefulWidget {

  const OnboardingScreen({
    super.key,
  });

  @override
  State<OnboardingScreen>
      createState() =>
          _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {

  final PageController
      _pageController =
          PageController();

  final OnboardingStorage
      _onboardingStorage =
          OnboardingStorage();

  int _currentPage = 0;

  List<OnboardingPageData>
  buildPages(
      AppLocalizations l10n,
  ) {

    return [

      OnboardingPageData(
        icon: Icons.public,
        title: l10n.onboardingWelcomeTitle,
        description: l10n.onboardingWelcomeDescription,
        iconColor: Colors.cyan,
      ),

      OnboardingPageData(
        icon: Icons.add_location_alt,
        title: l10n.onboardingAddTitle,
        description: l10n.onboardingAddDescription,
        iconColor: Colors.orange,
      ),

      OnboardingPageData(
        icon: Icons.place,
        title: l10n.onboardingColorsTitle,
        description: l10n.onboardingColorsDescription,
        iconColor: Colors.deepOrange,
      ),

      OnboardingPageData(
        icon: Icons.verified,
        title: l10n.onboardingApproveTitle,
        description: l10n.onboardingApproveDescription,
        iconColor: Colors.green,
      ),

      OnboardingPageData(
        icon: Icons.photo_camera,
        title: l10n.onboardingPhotosTitle,
        description: l10n.onboardingPhotosDescription,
        iconColor: Colors.blue,
      ),

      OnboardingPageData(
        icon: Icons.rate_review,
        title: l10n.onboardingFeedbackTitle,
        description: l10n.onboardingFeedbackDescription,
        iconColor: Colors.amber,
      ),

      OnboardingPageData(
        icon: Icons.report_problem,
        title: l10n.onboardingReportTitle,
        description: l10n.onboardingReportDescription,
        iconColor: Colors.red,
      ),

      OnboardingPageData(
        icon: Icons.favorite,
        title: l10n.onboardingTogetherTitle,
        description: l10n.onboardingTogetherDescription,
        iconColor: Colors.pink,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    final l10n =
        AppLocalizations.of(context)!;

    final pages =
        buildPages(l10n);

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [

              Color(0xFF021B2B),

              Color(0xFF0B3550),
            ],

            begin:
                Alignment.topCenter,

            end:
                Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(

          child: Padding(

            padding:
                const EdgeInsets.all(24),

            child: Column(

              children: [

                const SizedBox(
                  height: 24,
                ),

                Expanded(

                  child: PageView.builder(

                    controller:
                        _pageController,

                    itemCount:
                        pages.length,

                    onPageChanged:
                        (index) {

                      setState(() {

                        _currentPage =
                            index;
                      });
                    },

                    itemBuilder:
                        (
                          context,
                          index,
                        ) {

                      final page =
                          pages[index];

                      return Center(

                        child: Container(

                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets.all(32),

                          decoration:
                              BoxDecoration(

                            color:
                                Colors.white
                                    .withOpacity(0.08),

                            borderRadius:
                                BorderRadius.circular(32),

                            border:
                                Border.all(

                              color:
                                  Colors.white
                                      .withOpacity(0.1),
                            ),
                          ),
                        child: SingleChildScrollView(
                          child: Column(

                            mainAxisSize:
                                MainAxisSize.min,

                            children: [

                              Container(

                                width: 120,

                                height: 120,

                                decoration: BoxDecoration(

                                  shape: BoxShape.circle,

                                  color:
                                      page.iconColor.withOpacity(
                                        0.15,
                                      ),
                                ),

                                child: Icon(

                                  page.icon,

                                  size: 64,

                                  color: page.iconColor,
                                ),
                              ),

                              const SizedBox(
                                height: 24,
                              ),

                              Text(

                                page.title,

                                textAlign:
                                    TextAlign.center,

                                style:
                                    const TextStyle(

                                  color:
                                      Colors.white,

                                  fontSize: 28,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                height: 24,
                              ),

                              Text(

                                page.description,

                                textAlign:
                                    TextAlign.center,

                                style:
                                    TextStyle(

                                  color:
                                      Colors.white
                                          .withOpacity(0.8),

                                  fontSize: 17,

                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 32,
                ),

                Row(

                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: List.generate(

                    pages.length,

                    (index) {

                      return AnimatedContainer(

                        duration:
                            const Duration(
                                milliseconds: 300),

                        margin:
                            const EdgeInsets.symmetric(
                                horizontal: 4),

                        width:
                            _currentPage == index
                                ? 28
                                : 10,

                        height: 10,

                        decoration:
                            BoxDecoration(

                          color:
                              _currentPage == index
                                  ? Colors.white
                                  : Colors.white24,

                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 32,
                ),

                SizedBox(

                  width:
                      double.infinity,

                  height: 60,

                  child: ElevatedButton(

                    onPressed: () async {

                      if (_currentPage ==
                          pages.length - 1) {

                        await _onboardingStorage
                            .completeOnboarding();

                        await Geolocator
                            .requestPermission();

                        if (!mounted) {
                          return;
                        }

                        context.go('/map');

                        return;
                      }

                      _pageController.nextPage(

                        duration:
                            const Duration(
                                milliseconds: 300),

                        curve:
                            Curves.easeInOut,
                      );
                    },

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          Colors.white,

                      foregroundColor:
                          const Color(0xFF021B2B),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                    ),

                    child: Text(

                      _currentPage == pages.length - 1
                          ? l10n.onboardingOpenMap
                          : l10n.onboardingNext,

                      style:
                          const TextStyle(

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}