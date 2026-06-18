import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models/toilet_dto.dart';

import '../bloc/toilet_bloc.dart';

import '../widgets/animated_toilet_marker.dart';
import '../widgets/animated_user_marker.dart';
import '../widgets/create_toilet_bottom_sheet.dart';
import '../widgets/toilet_bottom_sheet.dart';

class MapView extends StatelessWidget {

  final MapController mapController;

  final List<ToiletDto> toilets;

  final LatLng? currentLocation;

  const MapView({

    super.key,

    required this.mapController,

    required this.toilets,

    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {

    return FlutterMap(

      mapController: mapController,

      options: MapOptions(

        initialCenter:
            const LatLng(
              50.1109,
              8.6821,
            ),

        initialZoom: 13,

        onLongPress:
            (tapPosition, point) {

          if (currentLocation == null) {
            return;
          }

          showModalBottomSheet(

            context: context,

            isScrollControlled: true,

            builder: (_) =>
                BlocProvider.value(

              value:
                  context.read<ToiletBloc>(),

              child:
                  CreateToiletBottomSheet(

                location: point,

                currentLocation:
                    currentLocation!,
              ),
            ),
          );
        },
      ),

      children: [

        TileLayer(

          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

          userAgentPackageName:
              'com.example.toilet_map_app',
        ),

        MarkerClusterLayerWidget(

          options: MarkerClusterLayerOptions(

            maxClusterRadius: 45,

            size: const Size(50, 50),

            alignment: Alignment.center,

            padding: const EdgeInsets.all(50),

            maxZoom: 17,

            markers: [

              ...toilets.map(

                (toilet) => Marker(

                  point: LatLng(
                    toilet.latitude,
                    toilet.longitude,
                  ),

                  width: 80,
                  height: 80,

                  child: GestureDetector(

                    onTap: () {

                      if (currentLocation == null) {
                        return;
                      }

                      showModalBottomSheet(

                        context: context,

                        builder: (_) =>
                            BlocProvider.value(

                          value:
                              context.read<ToiletBloc>(),

                          child: ToiletBottomSheet(

                            toilet: toilet,

                            currentLocation:
                                currentLocation!,
                          ),
                        ),
                      );
                    },

                    child: AnimatedToiletMarker(

                      status: toilet.status,
                    ),
                  ),
                ),
              ),

              if (currentLocation != null)

                Marker(

                  point: currentLocation!,

                  width: 80,
                  height: 80,

                  child:
                      const AnimatedUserMarker(),
                ),
            ],

            builder: (context, markers) {

              return Container(

                decoration: BoxDecoration(

                  color: Colors.cyanAccent,

                  shape: BoxShape.circle,

                  boxShadow: [

                    BoxShadow(

                      color:
                          Colors.cyanAccent.withOpacity(0.45),

                      blurRadius: 6,
                    ),
                  ],
                ),

                child: Center(

                  child: Text(

                    markers.length.toString(),

                    style: const TextStyle(

                      color: Colors.black,

                      fontWeight: FontWeight.bold,

                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}