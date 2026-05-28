import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/toilet_dto.dart';
import '../../../../l10n/app_localizations.dart';

import '../widgets/create_toilet_bottom_sheet.dart';
import '../bloc/toilet_bloc.dart';
import '../bloc/toilet_event.dart';
import '../bloc/toilet_state.dart';

import '../widgets/toilet_bottom_sheet.dart';
import '../widgets/animated_toilet_marker.dart';
import '../widgets/animated_user_marker.dart';
import '../widgets/map_view.dart';
import '../widgets/filter_overlay.dart';

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

  LatLng? _lastReloadLocation;

  DateTime? _lastReloadTime;

  bool _shouldReloadToilets(
    LatLng newLocation,
  ) {

    if (_lastReloadLocation == null ||
        _lastReloadTime == null) {

      return true;
    }

    final distance =
        Geolocator.distanceBetween(

      _lastReloadLocation!.latitude,
      _lastReloadLocation!.longitude,

      newLocation.latitude,
      newLocation.longitude,
    );

    final secondsSinceReload =
        DateTime.now()
            .difference(_lastReloadTime!)
            .inSeconds;

    return distance >= 50 &&
        secondsSinceReload >= 5;
  }

  Future<void> _moveToCurrentLocation()
  async {

    final permission =

        await Geolocator
            .checkPermission();

    if (permission ==
        LocationPermission.denied ||

        permission ==
        LocationPermission.deniedForever) {

      return;
    }

    final position =

        await Geolocator
            .getCurrentPosition();

    final userLocation = LatLng(

      position.latitude,

      position.longitude,
    );

    setState(() {

      _currentLocation =
          userLocation;
    });

    _mapController.move(

      userLocation,

      16,
    );

    _reloadToilets();

    _startLiveTracking();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      _moveToCurrentLocation();
    });

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

            if (_shouldReloadToilets(
                  newLocation,
                )) {

              _lastReloadLocation =
                  newLocation;

              _lastReloadTime =
                  DateTime.now();

              _reloadToilets();
            }
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

          Column(

            mainAxisSize:
                MainAxisSize.min,

            children: [

              FloatingActionButton(

                heroTag: 'onboarding',

                mini: true,

                onPressed: () {

                  context.push(
                    '/onboarding',
                  );
                },

                child: const Icon(
                  Icons.help_outline,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              FloatingActionButton(

                heroTag: 'location',

                onPressed:
                    _determinePosition,

                child: const Icon(
                  Icons.my_location,
                ),
              ),
            ],
          ),

      body: Stack(
        children: [

          BlocConsumer<
                ToiletBloc,
                ToiletState>(

                listener: (context, state) {

                  if (

                      state is ToiletLoaded &&

                      state.uiMessageCode != null
                  ) {

                    String message;

                    switch (state.uiMessageCode) {

                      case 'USER_ALREADY_APPROVED':

                        message =
                            AppLocalizations.of(context)!
                                .userAlreadyApproved;

                        break;

                      case 'TOILET_ALREADY_APPROVED':

                        message =
                            AppLocalizations.of(context)!
                                .toiletAlreadyApproved;

                        break;

                      case 'USER_ALREADY_REPORTED':

                        message =
                            AppLocalizations.of(context)!
                                .userAlreadyReported;

                        break;

                      default:

                        message =
                            AppLocalizations.of(context)!
                                .unknownError;
                    }

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      SnackBar(

                        content: Text(
                          message,

                          textAlign: TextAlign.center,
                        ),

                        behavior:
                            SnackBarBehavior.floating,

                        margin: const EdgeInsets.only(

                          left: 40,
                          right: 40,
                          bottom: 320,
                        ),

                        shape: RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(18),
                        ),

                        backgroundColor:
                            Colors.black.withOpacity(0.9),

                        duration:
                            const Duration(seconds: 2),
                      ),
                    );
                  }
                },

              builder: (context, state) {

                if (state is ToiletLoading) {

                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }
                final toilets =
                    state is ToiletLoaded
                        ? state.toilets
                        : <ToiletDto>[];

                return MapView(

                  mapController: _mapController,

                  toilets: toilets,

                  currentLocation: _currentLocation,
                );


              },
          ),
                    FilterOverlay(

                      approvedOnly: _approvedOnly,

                      accessibleOnly: _accessibleOnly,

                      freeOnly: _freeOnly,

                      onApprovedTap: () {

                        setState(() {

                          _approvedOnly =
                              !_approvedOnly;
                        });

                        _reloadToilets();
                      },

                      onAccessibleTap: () {

                        setState(() {

                          _accessibleOnly =
                              !_accessibleOnly;
                        });

                        _reloadToilets();
                      },

                      onFreeTap: () {

                        setState(() {

                          _freeOnly =
                              !_freeOnly;
                        });

                        _reloadToilets();
                      },
                    ),
        ],
      ),
    );
  }
}
