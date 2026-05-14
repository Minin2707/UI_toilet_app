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

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(16),

      child: Column(
        mainAxisSize:
            MainAxisSize.min,

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            toilet.title,

            style: const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (toilet.description
              .isNotEmpty)

            Text(
              toilet.description,
            ),

          const SizedBox(height: 12),

          if (toilet.address.isNotEmpty)

            Text(
              toilet.address,
            ),

          const SizedBox(height: 16),

          Wrap(

            spacing: 8,
            runSpacing: 8,

            children: [

              Container(

                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(

                  color: Colors.blue.shade50,

                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Text(

                  switch (toilet.accessType) {

                    'FREE' =>
                        '🟢 Free',

                    'PAID' =>
                        '💰 Paid',

                    'CUSTOMERS_ONLY' =>
                        '🛒 Customers Only',

                    _ =>
                        toilet.accessType,
                  },

                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (toilet.wheelchairAccessible)

                Container(

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(

                    color: Colors.green.shade50,

                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: const Text(

                    '♿ Accessible',

                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          Row(
            children: [

              const Text(
                'Status: ',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Text(
                toilet.status,

                style: TextStyle(

                  color:
                      toilet.status ==
                              'APPROVED'
                          ? Colors.green
                          : Colors.grey,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'Distance: '
            '${toilet.distanceMeters.toStringAsFixed(0)} m',
          ),

          const SizedBox(height: 12),

          Text(
            'Latitude: ${toilet.latitude}',
          ),

          Text(
            'Longitude: ${toilet.longitude}',
          ),

          const SizedBox(height: 24),

          if (toilet.status !=
              'APPROVED')

            SizedBox(

              width: double.infinity,

              child: FilledButton(

                onPressed: () {

                  context
                      .read<ToiletBloc>()
                      .add(

                    ApproveToiletEvent(

                      toiletId:
                          toilet.id,

                      reloadLatitude:
                          currentLocation.latitude,

                      reloadLongitude:
                          currentLocation.longitude,
                    ),
                  );

                  Navigator.pop(
                    context,
                  );
                },

                child: const Text(
                  'Approve Toilet',
                ),
              ),
            ),
        ],
      ),
    );
  }
}