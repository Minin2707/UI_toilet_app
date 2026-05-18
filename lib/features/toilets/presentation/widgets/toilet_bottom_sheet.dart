import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/models/toilet_dto.dart';

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

      return '${widget.toilet.distanceMeters.toInt()} m away';
    }

    final km =
        widget.toilet.distanceMeters / 1000;

    return '${km.toStringAsFixed(1)} km away';
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
                                    ? 'Approved'
                                    : 'Pending approval',

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

                      label: const Text(
                        'Approve Toilet',
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

                    label: const Text(
                      'Navigate',
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

                  'Community feedback',

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

                      title: 'Clean',

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

                      title: 'Has paper',

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

                      title: 'Warm',

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

                      title: 'Safe',

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

                      title: 'Dirty',

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
                        label: 'Address',
                        value:
                            widget.toilet.address.isEmpty
                                ? 'Unknown'
                                : widget.toilet.address,
                      ),

                      const SizedBox(height: 18),

                      _InfoRow(
                        icon: Icons.social_distance,
                        label: 'Distance',
                        value: _distanceText(),
                      ),

                      const SizedBox(height: 18),

                      _InfoRow(
                        icon: Icons.accessible_forward,
                        label: 'Accessibility',
                        value:
                            widget.toilet.wheelchairAccessible
                                ? 'Wheelchair accessible'
                                : 'Not specified',
                      ),

                      const SizedBox(height: 18),

                      _InfoRow(
                        icon: Icons.payments_outlined,
                        label: 'Access',
                        value:
                            widget.toilet.accessType
                                .replaceAll('_', ' '),
                      ),

                      const SizedBox(height: 26),

                      Divider(
                        color:
                            Colors.white.withOpacity(0.08),
                      ),

                      const SizedBox(height: 18),

                      if (widget.toilet.lastConfirmedAt == null) ...[

                        Text(

                          'Help keep the map accurate',

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

                                  child: const Row(

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

                                        'Still exists',

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

                                  child: const Row(

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

                                        'Not there',

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

                                      'Verified by community recently',

                                      style: TextStyle(

                                        color:
                                            Colors.greenAccent.shade100,

                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(

                                      'Last confirmed $lastConfirmedText',

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