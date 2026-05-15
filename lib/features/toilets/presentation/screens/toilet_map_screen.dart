import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models/toilet_dto.dart';

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
  bool _approvedOnly = false;

  bool _accessibleOnly = false;

  bool _freeOnly = false;

  @override
  void initState() {
    super.initState();

    _determinePosition();
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
  Widget build(BuildContext context) {

    return Scaffold(
    backgroundColor:
        const Color(0xFF07111A),

      appBar: AppBar(
        backgroundColor:
              const Color(0xFF07111A),

          elevation: 0,
        title: const Text(
          'Toilet Map',
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
                          'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',

                      subdomains: const [
                        'a',
                        'b',
                        'c',
                        'd',
                      ],

                      userAgentPackageName:
                          'com.example.toilet_map_app',
                    ),

                    MarkerLayer(

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
                    ),
                  ],
                );
              },
          ),
          Positioned(

            top: 12,
            left: 12,


            child: SingleChildScrollView(

              scrollDirection: Axis.horizontal,

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

                    child: Row(
                  children: [

                    SizedBox(

                      width: 120,

                      child: FilterChip(
                      showCheckmark: false,

                        label:  Center(
                          child: Text(
                            'Approved',
                            style: TextStyle(
                              color:
                                  _approvedOnly
                                      ? Colors.black
                                      : Colors.white,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        selected:
                            _approvedOnly,

                        selectedColor:
                            Colors.cyanAccent,

                        backgroundColor:
                            Colors.transparent,

                        disabledColor:
                            Colors.transparent,

                        selectedShadowColor:
                            Colors.transparent,

                        shadowColor:
                            Colors.transparent,

                        surfaceTintColor:
                            Colors.transparent,

                        checkmarkColor:
                            Colors.black,

                        side: BorderSide(
                          color:
                              Colors.black.withOpacity(0.22),
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),

                        onSelected: (value) {

                          setState(() {
                            _approvedOnly = value;
                          });

                          _reloadToilets();
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    SizedBox(

                      width: 120,

                      child: FilterChip(
                      showCheckmark: false,

                        label:  Center(
                          child: Text(
                            'Accessible',
                            style: TextStyle(
                              color:
                                  _accessibleOnly
                                      ? Colors.black
                                      : Colors.white,


                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        selected:
                            _accessibleOnly,

                        selectedColor:
                            Colors.cyanAccent,

                       backgroundColor:
                           Colors.transparent,

                       disabledColor:
                           Colors.transparent,

                       selectedShadowColor:
                           Colors.transparent,

                       shadowColor:
                           Colors.transparent,

                       surfaceTintColor:
                           Colors.transparent,

                        checkmarkColor:
                            Colors.black,

                        side: BorderSide(
                          color:
                              Colors.black.withOpacity(0.22),
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),

                        onSelected: (value) {

                          setState(() {
                            _accessibleOnly = value;
                          });

                          _reloadToilets();
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    SizedBox(

                      width: 120,

                      child: FilterChip(
                      showCheckmark: false,

                        label:  Center(
                          child: Text(
                            'Free',
                            style: TextStyle(
                              color:
                                  _freeOnly
                                      ? Colors.black
                                      : Colors.white,


                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        selected:
                            _freeOnly,

                        selectedColor:
                            Colors.cyanAccent,

                        backgroundColor:
                            Colors.transparent,

                        disabledColor:
                            Colors.transparent,

                        selectedShadowColor:
                            Colors.transparent,

                        shadowColor:
                            Colors.transparent,

                        surfaceTintColor:
                            Colors.transparent,

                        checkmarkColor:
                            Colors.black,

                        side: BorderSide(
                          color:
                              Colors.black.withOpacity(0.22),
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),

                        onSelected: (value) {

                          setState(() {
                            _freeOnly = value;
                          });

                          _reloadToilets();
                        },
                      ),
                    ),
                  ],
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
