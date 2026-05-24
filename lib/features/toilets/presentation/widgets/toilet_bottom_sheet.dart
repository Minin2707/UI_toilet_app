import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/models/toilet_dto.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/toilet_bloc.dart';
import '../bloc/toilet_event.dart';

class ToiletBottomSheet
    extends StatefulWidget {

  final ToiletDto toilet;

  final LatLng currentLocation;

  const ToiletBottomSheet({
    super.key,
    required this.toilet,
    required this.currentLocation,
  });

  @override
  State<ToiletBottomSheet> createState() =>
      _ToiletBottomSheetState();
  }

  class _ToiletBottomSheetState
      extends State<ToiletBottomSheet> {

      late int cleanCount;

      late int dirtyCount;

      late int safeCount;

      late int warmCount;

      late int hasPaperCount;

      bool cleanSelected = false;

      bool dirtySelected = false;

      bool safeSelected = false;

      bool warmSelected = false;

      bool hasPaperSelected = false;

      @override
      void initState() {

        super.initState();

        timeago.setLocaleMessages(
          'ru',
          timeago.RuMessages(),
        );

        cleanCount =
            widget.toilet.cleanCount;

        dirtyCount =
            widget.toilet.dirtyCount;

        safeCount =
            widget.toilet.safeCount;

        warmCount =
            widget.toilet.warmCount;

        hasPaperCount =
            widget.toilet.hasPaperCount;
      }

      void _toggleFeedback({

        required bool selected,

        required VoidCallback onSelect,

        required VoidCallback onUnselect,
      }) {

        setState(() {

          if (selected) {

            onUnselect();

          } else {

            onSelect();
          }
        });
      }

  String _distanceText() {

    if (widget.toilet.distanceMeters < 1000) {

      return AppLocalizations.of(context)!
          .metersAway(
              widget.toilet.distanceMeters.toInt(),
          );
    }

    final km =
        widget.toilet.distanceMeters / 1000;

    return AppLocalizations.of(context)!
        .kmAway(
            km.toStringAsFixed(1),
        );
  }

  Future<void> _openDirections() async {

    final lat = widget.toilet.latitude;
    final lon = widget.toilet.longitude;

    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon',
    );

    if (await canLaunchUrl(uri)) {

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  String _localizedAccessType(
      BuildContext context,
      String accessType,
  ) {

    switch (accessType) {

      case 'FREE':
        return AppLocalizations.of(context)!
            .freeAccess;

      case 'PAID':
        return AppLocalizations.of(context)!
            .paidAccess;

      case 'CUSTOMERS_ONLY':
        return AppLocalizations.of(context)!
            .customersOnly;

      default:
        return accessType;
    }
  }

  @override
  Widget build(BuildContext context) {

    final isApproved =
        widget.toilet.status == 'APPROVED';

    final lastConfirmedText =

        widget.toilet.lastConfirmedAt != null

            ? timeago.format(

                DateTime.parse(
                  widget.toilet.lastConfirmedAt!,
                ),

                locale:
                    Localizations.localeOf(context)
                        .languageCode,
              )

            : null;

    return SafeArea(

      child: ConstrainedBox(

        constraints: BoxConstraints(

          maxHeight:
              MediaQuery.of(context)
                  .size
                  .height * 0.78,
        ),

        child: Container(

          padding: const EdgeInsets.all(24),

          decoration: const BoxDecoration(

            color: Color(0xFF07111A),

            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),

          child: SingleChildScrollView(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // HANDLE

                Center(
                  child: Container(

                    width: 52,
                    height: 5,

                    decoration: BoxDecoration(
                      color: Colors.white24,

                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // HEADER

                Row(
                  children: [

                    Container(

                      width: 64,
                      height: 64,

                      decoration: BoxDecoration(

                        color:
                            isApproved
                                ? Colors.green.withOpacity(0.18)
                                : Colors.grey.withOpacity(0.18),

                        borderRadius:
                            BorderRadius.circular(18),
                      ),

                      child: Icon(

                        Icons.wc,

                        size: 36,

                        color:
                            isApproved
                                ? Colors.greenAccent
                                : Colors.grey.shade400,
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(

                            widget.toilet.title,

                            style: const TextStyle(

                              color: Colors.white,

                              fontSize: 24,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Row(
                            children: [

                              Icon(

                                Icons.circle,

                                size: 10,

                                color:
                                    isApproved
                                        ? Colors.greenAccent
                                        : Colors.orangeAccent,
                              ),

                              const SizedBox(width: 8),

                              Text(

                                isApproved

                                    ? AppLocalizations.of(context)!
                                        .approvedStatus

                                    : AppLocalizations.of(context)!
                                        .pendingApproval,

                                style: TextStyle(

                                  color:
                                      isApproved
                                          ? Colors.greenAccent
                                          : Colors.orangeAccent,

                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // APPROVE BUTTON

                if (!isApproved)

                  SizedBox(

                    width: double.infinity,
                    height: 58,

                    child: FilledButton.icon(

                      onPressed: () {

                        context.read<ToiletBloc>().add(

                          ApproveToiletEvent(

                            toiletId: widget.toilet.id,

                            reloadLatitude:
                                widget.currentLocation.latitude,

                            reloadLongitude:
                                widget.currentLocation.longitude,
                          ),
                        );

                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.verified,
                      ),

                      label: Text(
                        AppLocalizations.of(context)!
                            .approveToilet,
                      ),

                      style: FilledButton.styleFrom(

                        backgroundColor:
                            Colors.orangeAccent,

                        foregroundColor:
                            Colors.black,

                        textStyle: const TextStyle(

                          fontWeight:
                              FontWeight.bold,

                          fontSize: 16,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 18),

                // NAVIGATE BUTTON

                SizedBox(

                  width: double.infinity,
                  height: 56,

                  child: FilledButton.icon(

                    onPressed: _openDirections,

                    icon: const Icon(
                      Icons.navigation,
                    ),

                    label: Text(
                      AppLocalizations.of(context)!
                          .navigate,
                    ),

                    style: FilledButton.styleFrom(

                      backgroundColor:
                          Colors.cyanAccent,

                      foregroundColor:
                          Colors.black,

                      textStyle: const TextStyle(

                        fontWeight:
                            FontWeight.bold,

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

                // FEEDBACK TITLE

                Text(

                  AppLocalizations.of(context)!
                      .communityFeedback,

                  style: TextStyle(

                    color:
                        Colors.white.withOpacity(0.7),

                    fontSize: 15,

                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 14),

                // FEEDBACK CHIPS

                Wrap(

                  spacing: 10,
                  runSpacing: 10,

                  children: [

                    _FeedbackChip(

                      emoji: '🧼',

                      title:
                          AppLocalizations.of(context)!
                              .clean,

                      count: cleanCount,

                      selected: cleanSelected,

                      onTap: () {

                        _toggleFeedback(

                          selected: cleanSelected,

                          onSelect: () {

                            cleanSelected = true;

                            cleanCount++;
                          },

                          onUnselect: () {

                            cleanSelected = false;

                            cleanCount--;
                          },
                        );

                        context.read<ToiletBloc>().add(

                          LeaveFeedbackEvent(

                            toiletId: widget.toilet.id,

                            type: 'CLEAN',

                            reloadLatitude:
                                widget.currentLocation.latitude,

                            reloadLongitude:
                                widget.currentLocation.longitude,
                          ),
                        );
                      },
                    ),

                    _FeedbackChip(

                      emoji: '🧻',

                      title:
                          AppLocalizations.of(context)!
                              .hasPaper,

                      count: hasPaperCount,

                      selected: hasPaperSelected,

                      onTap: () {

                        _toggleFeedback(

                          selected: hasPaperSelected,

                          onSelect: () {

                            hasPaperSelected = true;

                            hasPaperCount++;
                          },

                          onUnselect: () {

                            hasPaperSelected = false;

                            hasPaperCount--;
                          },
                        );

                        context.read<ToiletBloc>().add(

                          LeaveFeedbackEvent(

                            toiletId: widget.toilet.id,

                            type: 'HAS_PAPER',

                            reloadLatitude:
                                widget.currentLocation.latitude,

                            reloadLongitude:
                                widget.currentLocation.longitude,
                          ),
                        );
                      },
                    ),

                    _FeedbackChip(

                      emoji: '🔥',

                      title:
                          AppLocalizations.of(context)!
                              .warm,

                      count: warmCount,

                      selected: warmSelected,

                      onTap: () {

                        _toggleFeedback(

                          selected: warmSelected,

                          onSelect: () {

                            warmSelected = true;

                            warmCount++;
                          },

                          onUnselect: () {

                            warmSelected = false;

                            warmCount--;
                          },
                        );

                        context.read<ToiletBloc>().add(

                          LeaveFeedbackEvent(

                            toiletId: widget.toilet.id,

                            type: 'WARM',

                            reloadLatitude:
                                widget.currentLocation.latitude,

                            reloadLongitude:
                                widget.currentLocation.longitude,
                          ),
                        );
                      },
                    ),

                    _FeedbackChip(

                      emoji: '🔒',

                      title:
                          AppLocalizations.of(context)!
                              .safe,

                      count: safeCount,

                      selected: safeSelected,

                      onTap: () {

                        _toggleFeedback(

                          selected: safeSelected,

                          onSelect: () {

                            safeSelected = true;

                            safeCount++;
                          },

                          onUnselect: () {

                            safeSelected = false;

                            safeCount--;
                          },
                        );

                        context.read<ToiletBloc>().add(

                          LeaveFeedbackEvent(

                            toiletId: widget.toilet.id,

                            type: 'SAFE',

                            reloadLatitude:
                                widget.currentLocation.latitude,

                            reloadLongitude:
                                widget.currentLocation.longitude,
                          ),
                        );
                      },
                    ),

                    _FeedbackChip(

                      emoji: '🚫',

                      title:
                          AppLocalizations.of(context)!
                              .dirty,

                      count: dirtyCount,

                      selected: dirtySelected,

                      onTap: () {

                        _toggleFeedback(

                          selected: dirtySelected,

                          onSelect: () {

                            dirtySelected = true;

                            dirtyCount++;
                          },

                          onUnselect: () {

                            dirtySelected = false;

                            dirtyCount--;
                          },
                        );

                        context.read<ToiletBloc>().add(

                          LeaveFeedbackEvent(

                            toiletId: widget.toilet.id,

                            type: 'DIRTY',

                            reloadLatitude:
                                widget.currentLocation.latitude,

                            reloadLongitude:
                                widget.currentLocation.longitude,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // INFO CARD

                Container(

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(

                    color:
                        Colors.white.withOpacity(0.05),

                    borderRadius:
                        BorderRadius.circular(20),

                    border: Border.all(
                      color:
                          Colors.white.withOpacity(0.08),
                    ),
                  ),

                  child: Column(
                    children: [

                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label:
                            AppLocalizations.of(context)!
                                .addressLabel,
                        value:
                            widget.toilet.address.isEmpty
                                ? AppLocalizations.of(context)!
                                    .unknown
                                : widget.toilet.address,
                      ),

                      const SizedBox(height: 18),

                      _InfoRow(
                        icon: Icons.social_distance,
                        label:
                            AppLocalizations.of(context)!
                                .distanceLabel,
                        value: _distanceText(),
                      ),

                      const SizedBox(height: 18),

                      _InfoRow(
                        icon: Icons.accessible_forward,
                        label:
                            AppLocalizations.of(context)!
                                .accessibilityLabel,
                        value:
                            widget.toilet.wheelchairAccessible
                                ? AppLocalizations.of(context)!
                                    .wheelchairAccessibleValue
                                : AppLocalizations.of(context)!
                                    .notSpecified,
                      ),

                      const SizedBox(height: 18),

                      _InfoRow(
                        icon: Icons.payments_outlined,
                        label:
                            AppLocalizations.of(context)!
                                .accessLabel,
                        value:
                            _localizedAccessType(
                              context,
                              widget.toilet.accessType,
                            ),
                      ),

                      const SizedBox(height: 26),

                      Divider(
                        color:
                            Colors.white.withOpacity(0.08),
                      ),

                      const SizedBox(height: 18),

                      if (widget.toilet.lastConfirmedAt == null) ...[

                        Text(

                          AppLocalizations.of(context)!
                              .helpKeepMapAccurate,

                          style: TextStyle(

                            color:
                                Colors.white.withOpacity(0.5),

                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [

                            Expanded(

                              child: GestureDetector(

                                onTap: () {


                                  context.read<ToiletBloc>().add(

                                    ConfirmToiletEvent(

                                      toiletId: widget.toilet.id,

                                      reloadLatitude:
                                          widget.currentLocation.latitude,

                                      reloadLongitude:
                                          widget.currentLocation.longitude,
                                    ),
                                  );

                                  Navigator.pop(context);
                                },

                                child: Container(

                                  height: 52,

                                  decoration: BoxDecoration(

                                    color:
                                        Colors.greenAccent.withOpacity(0.14),

                                    borderRadius:
                                        BorderRadius.circular(16),

                                    border: Border.all(

                                      color:
                                          Colors.greenAccent.withOpacity(0.22),
                                    ),
                                  ),

                                  child:  Row(

                                    mainAxisAlignment:
                                        MainAxisAlignment.center,

                                    children: [

                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.greenAccent,
                                        size: 20,
                                      ),

                                      SizedBox(width: 8),

                                      Text(

                                        AppLocalizations.of(context)!
                                            .stillExists,

                                        style: TextStyle(

                                          color: Colors.greenAccent,

                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(

                              child: GestureDetector(

                                onTap: () {



                                  context.read<ToiletBloc>().add(

                                    ReportToiletEvent(

                                      toiletId: widget.toilet.id,

                                      reloadLatitude:
                                          widget.currentLocation.latitude,

                                      reloadLongitude:
                                          widget.currentLocation.longitude,
                                    ),
                                  );

                                  Navigator.pop(context);
                                },

                                child: Container(

                                  height: 52,

                                  decoration: BoxDecoration(

                                    color:
                                        Colors.redAccent.withOpacity(0.10),

                                    borderRadius:
                                        BorderRadius.circular(16),

                                    border: Border.all(

                                      color:
                                          Colors.redAccent.withOpacity(0.20),
                                    ),
                                  ),

                                  child:  Row(

                                    mainAxisAlignment:
                                        MainAxisAlignment.center,

                                    children: [

                                      Icon(
                                        Icons.close,
                                        color: Colors.redAccent,
                                        size: 20,
                                      ),

                                      SizedBox(width: 8),

                                      Text(

                                        AppLocalizations.of(context)!
                                            .notThere,

                                        style: TextStyle(

                                          color: Colors.redAccent,

                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ] else ...[

                        Container(

                          width: double.infinity,

                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(

                            color:
                                Colors.greenAccent.withOpacity(0.08),

                            borderRadius:
                                BorderRadius.circular(16),

                            border: Border.all(

                              color:
                                  Colors.greenAccent.withOpacity(0.14),
                            ),
                          ),

                          child: Row(
                            children: [

                              const Icon(
                                Icons.verified,
                                color: Colors.greenAccent,
                              ),

                              const SizedBox(width: 12),

                              Expanded(

                                child: Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    Text(

                                      AppLocalizations.of(context)!
                                          .verifiedRecently,

                                      style: TextStyle(

                                        color:
                                            Colors.greenAccent.shade100,

                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(

                                      AppLocalizations.of(context)!
                                          .lastConfirmed(
                                              lastConfirmedText!,
                                          ),

                                      style: TextStyle(

                                        color:
                                            Colors.white.withOpacity(0.55),

                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow
    extends StatelessWidget {

  final IconData icon;

  final String label;

  final String value;

  const _InfoRow({

    required this.icon,

    required this.label,

    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Row(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Container(

          width: 40,
          height: 40,

          decoration: BoxDecoration(

            color:
                Colors.white.withOpacity(0.06),

            borderRadius:
                BorderRadius.circular(12),
          ),

          child: Icon(
            icon,
            color: Colors.cyanAccent,
            size: 20,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(

                label,

                style: TextStyle(

                  color:
                      Colors.white.withOpacity(0.55),

                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 3),

              Text(

                value,

                style: const TextStyle(

                  color: Colors.white,

                  fontSize: 15,

                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeedbackChip
    extends StatelessWidget {

  final String emoji;

  final String title;

  final int count;

  final VoidCallback onTap;

  final bool selected;

  const _FeedbackChip({

    required this.emoji,

    required this.title,

    required this.count,

    required this.onTap,

    required this.selected,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.symmetric(

          horizontal: 14,

          vertical: 10,
        ),

        decoration: BoxDecoration(

          color:
              selected
                  ? Colors.cyanAccent.withOpacity(0.18)
                  : Colors.white.withOpacity(0.06),

          borderRadius:
              BorderRadius.circular(14),

          border: Border.all(

            color:
                Colors.white.withOpacity(0.08),
          ),
        ),

        child: Row(

          mainAxisSize: MainAxisSize.min,

          children: [

            Text(
              emoji,
              style:
                  const TextStyle(
                    fontSize: 16,
                  ),
            ),

            const SizedBox(width: 8),

            Text(

              '$title $count',

              style: const TextStyle(

                color: Colors.white,

                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}