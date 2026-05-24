import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import '../../data/models/toilet_dto.dart';
import '../../../../l10n/app_localizations.dart';

import '../widgets/create_toilet_bottom_sheet.dart';
import '../bloc/toilet_bloc.dart';
import '../bloc/toilet_event.dart';
import '../bloc/toilet_state.dart';

import '../widgets/toilet_bottom_sheet.dart';
import '../widgets/animated_toilet_marker.dart';
import '../widgets/animated_user_marker.dart';

class ToiletMapScreen extends StatefulWidget {
  const ToiletMapScreen({super.key});

  @override
  State<ToiletMapScreen> createState() =>
      _ToiletMapScreenState();
}

class _ToiletMapScreenState
    extends State<ToiletMapScreen> {

  final MapController _mapController =
      MapController();

  LatLng? _currentLocation;
  StreamSubscription<Position>?
      _positionStreamSubscription;
  bool _approvedOnly = false;

  bool _accessibleOnly = false;

  bool _freeOnly = false;

  @override
  void initState() {
    super.initState();

    _determinePosition();
  }

  void _startLiveTracking() {

    _positionStreamSubscription?.cancel();

    _positionStreamSubscription =

        Geolocator.getPositionStream(

          locationSettings:

              const LocationSettings(

                accuracy:
                    LocationAccuracy.high,

                distanceFilter: 10,
              ),
        ).listen(

          (Position position) {

            final newLocation = LatLng(

              position.latitude,

              position.longitude,
            );

            setState(() {

              _currentLocation =
                  newLocation;
            });

            _reloadToilets();
          },
        );
  }

  Future<void> _determinePosition() async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    permission =
        await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {

      permission =
          await Geolocator.requestPermission();
    }

    if (permission ==
        LocationPermission.deniedForever) {
      return;
    }

    if (permission ==
        LocationPermission.denied) {
      return;
    }

    final position =
        await Geolocator.getCurrentPosition();

    final userLocation = LatLng(
      position.latitude,
      position.longitude,
    );

    setState(() {
      _currentLocation = userLocation;
    });

    _mapController.move(
      userLocation,
      16,
    );

    _reloadToilets();
    _startLiveTracking();
  }

  void _reloadToilets() {

    if (_currentLocation == null) {
      return;
    }

    context.read<ToiletBloc>().add(
      LoadToiletsEvent(

        latitude:
            _currentLocation!.latitude,

        longitude:
            _currentLocation!.longitude,

        approvedOnly:
            _approvedOnly,

        accessibleOnly:
            _accessibleOnly,

        accessType:
            _freeOnly ? 'FREE' : null,
      ),
    );
  }

  @override
      void dispose() {

        _positionStreamSubscription?.cancel();

        super.dispose();
      }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
    backgroundColor:
        const Color(0xFF07111A),

      appBar: AppBar(
        backgroundColor:
              const Color(0xFF07111A),

          elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.toiletMap,
        ),
      ),

      floatingActionButton:
          FloatingActionButton(

        onPressed: _determinePosition,

        child: const Icon(
          Icons.my_location,
        ),
      ),

      body: Stack(
        children: [

          BlocBuilder<
                ToiletBloc,
                ToiletState>(

              builder: (context, state) {

                if (state is ToiletLoading) {

                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (state is ToiletError) {

                  return Center(
                    child: Text(
                      state.message,
                    ),
                  );
                }

                final toilets =
                    state is ToiletLoaded
                        ? state.toilets
                        : <ToiletDto>[];

                return FlutterMap(

                  mapController: _mapController,

                  options: MapOptions(

                    initialCenter:
                        const LatLng(
                          50.1109,
                          8.6821,
                        ),

                    initialZoom: 13,

                    onLongPress:
                        (tapPosition, point) {

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
                                _currentLocation!,
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

                                  showModalBottomSheet(

                                    context: context,

                                    builder: (_) =>
                                        BlocProvider.value(

                                      value:
                                          context.read<ToiletBloc>(),

                                      child: ToiletBottomSheet(
                                        toilet: toilet,
                                        currentLocation:
                                            _currentLocation!,
                                      ),
                                    ),
                                  );
                                },

                                child: AnimatedToiletMarker(

                                  approved:
                                      toilet.status == 'APPROVED',
                                ),
                              ),
                            ),
                          ),

                          if (_currentLocation != null)

                            Marker(

                              point: _currentLocation!,

                              width: 80,
                              height: 80,

                              child: const AnimatedUserMarker(),
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

                                  blurRadius: 18,
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
              },
          ),
          Positioned(

            top: 12,
            left: 12,

            child: SizedBox(

              width:
                  MediaQuery.of(context)
                      .size
                      .width - 24,

              child: ClipRRect(

              borderRadius:
                  BorderRadius.circular(22),

              child: BackdropFilter(

                filter: ImageFilter.blur(

                  sigmaX: 18,
                  sigmaY: 18,
                ),

                child: Container(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(

                    color:
                        Colors.white.withOpacity(0.08),

                    borderRadius:
                        BorderRadius.circular(22),

                    border: Border.all(
                      color:
                          Colors.white.withOpacity(0.08),
                    ),

                    boxShadow: [

                      BoxShadow(

                        color:
                            Colors.black.withOpacity(0.25),

                        blurRadius: 24,

                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: SingleChildScrollView(

                    scrollDirection: Axis.horizontal,



                      child: Row(
                        children: [

                          _GlassFilterChip(

                            title:
                                AppLocalizations.of(context)!
                                    .approved,

                            selected: _approvedOnly,

                            onTap: () {

                              setState(() {
                                _approvedOnly =
                                    !_approvedOnly;
                              });

                              _reloadToilets();
                            },
                          ),

                          const SizedBox(width: 10),

                          _GlassFilterChip(

                            title:
                                AppLocalizations.of(context)!
                                    .accessible,

                            selected: _accessibleOnly,

                            onTap: () {

                              setState(() {
                                _accessibleOnly =
                                    !_accessibleOnly;
                              });

                              _reloadToilets();
                            },
                          ),

                          const SizedBox(width: 10),

                          _GlassFilterChip(

                            title:
                                AppLocalizations.of(context)!
                                    .free,

                            selected: _freeOnly,

                            onTap: () {

                              setState(() {
                                _freeOnly =
                                    !_freeOnly;
                              });

                              _reloadToilets();
                            },

                          ),
                        ],
                      ),

                  ),
                ),
              ),
            ),
          ),
          ),

        ],
      ),
    );
  }
}
class _GlassFilterChip
    extends StatelessWidget {

  final String title;

  final bool selected;

  final VoidCallback onTap;

  const _GlassFilterChip({

    required this.title,

    required this.selected,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: AnimatedContainer(

        duration:
            const Duration(milliseconds: 180),

        padding: const EdgeInsets.symmetric(
          horizontal: 22,
        ),
        height: 46,

        decoration: BoxDecoration(

          color:
              selected
                  ? Colors.cyanAccent
                  : Colors.white.withOpacity(0.06),

          borderRadius:
              BorderRadius.circular(16),

          border: Border.all(

            color:
                selected
                    ? Colors.cyanAccent
                    : Colors.white.withOpacity(0.08),
          ),

          boxShadow: [

            if (selected)

              BoxShadow(

                color:
                    Colors.cyanAccent.withOpacity(0.35),

                blurRadius: 18,
              ),
          ],
        ),

        child: Center(

          child: Text(

            title,

            style: TextStyle(

              color:
                  selected
                      ? Colors.black
                      : Colors.white,

              fontWeight:
                  FontWeight.w600,

              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}