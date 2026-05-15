import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models/toilet_dto.dart';

import '../bloc/toilet_bloc.dart';
import '../bloc/toilet_event.dart';

class ToiletBottomSheet
    extends StatelessWidget {

  final ToiletDto toilet;

  final LatLng currentLocation;

  const ToiletBottomSheet({
    super.key,
    required this.toilet,
    required this.currentLocation,
  });

  String _distanceText() {

    if (toilet.distanceMeters < 1000) {

      return '${toilet.distanceMeters.toInt()} m away';
    }

    final km =
        toilet.distanceMeters / 1000;

    return '${km.toStringAsFixed(1)} km away';
  }

  @override
  Widget build(BuildContext context) {

    final isApproved =
        toilet.status == 'APPROVED';

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
                    color:
                        Colors.white24,

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

                          toilet.title,

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

                          toiletId: toilet.id,

                          reloadLatitude:
                              currentLocation.latitude,

                          reloadLongitude:
                              currentLocation.longitude,
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

              const SizedBox(height: 24),

              // SCROLLABLE CONTENT

              Expanded(

                child: SingleChildScrollView(

                  child: Container(

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
                              toilet.address.isEmpty
                                  ? 'Unknown'
                                  : toilet.address,
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
                              toilet.wheelchairAccessible
                                  ? 'Wheelchair accessible'
                                  : 'Not specified',
                        ),

                        const SizedBox(height: 18),

                        _InfoRow(
                          icon: Icons.payments_outlined,
                          label: 'Access',
                          value:
                              toilet.accessType
                                  .replaceAll('_', ' '),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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