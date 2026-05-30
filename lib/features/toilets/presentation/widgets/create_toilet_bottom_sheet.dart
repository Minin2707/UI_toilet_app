import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models/create_toilet_request.dart';
import '../../../../l10n/app_localizations.dart';

import '../bloc/toilet_bloc.dart';
import '../bloc/toilet_event.dart';

class CreateToiletBottomSheet
    extends StatefulWidget {

  final LatLng location;

  final LatLng currentLocation;

  const CreateToiletBottomSheet({
    super.key,
    required this.location,
    required this.currentLocation,
  });

  @override
  State<CreateToiletBottomSheet>
      createState() =>
          _CreateToiletBottomSheetState();
}

class _CreateToiletBottomSheetState
    extends State<CreateToiletBottomSheet> {

  final _titleController =
      TextEditingController();

  final _descriptionController =
      TextEditingController();

  final _addressController =
      TextEditingController();

  bool _isLoading = false;

  String? _titleError;

  String _accessType = 'FREE';

  bool _wheelchairAccessible =
      false;

  Future<void> _createToilet() async {

    final title =
        _titleController.text.trim();

    if (title.isEmpty) {

      setState(() {

        _titleError =
            AppLocalizations.of(context)!
                .titleRequired;
      });

      return;
    }

    setState(() {
      _isLoading = true;
    });

    final request =
        CreateToiletRequest(

      title: title,

      description:
          _descriptionController.text.trim(),

      address:
          _addressController.text.trim(),

      latitude:
          widget.location.latitude,

      longitude:
          widget.location.longitude,

      accessType:
          _accessType,

      wheelchairAccessible:
          _wheelchairAccessible,
    );

    context.read<ToiletBloc>().add(

      CreateToiletEvent(

        request: request,

        reloadLatitude:
            widget.currentLocation.latitude,

        reloadLongitude:
            widget.currentLocation.longitude,
      ),
    );

    if (!mounted) {
      return;
    }

    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(
    String label,
  ) {

    return InputDecoration(

      labelText: label,

      labelStyle: const TextStyle(
        color: Colors.white70,
      ),

      filled: true,

      fillColor:
          Colors.white.withOpacity(0.05),

      border: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide(

          color:
              Colors.white.withOpacity(0.08),
        ),
      ),

      enabledBorder: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide(

          color:
              Colors.white.withOpacity(0.08),
        ),
      ),

      focusedBorder: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(18),

        borderSide: const BorderSide(

          color: Colors.cyanAccent,
          width: 1.4,
        ),
      ),
    );
  }

  @override
  void dispose() {

    _titleController.dispose();

    _descriptionController.dispose();

    _addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ClipRRect(

      borderRadius:
          const BorderRadius.vertical(

        top: Radius.circular(28),
      ),

      child: BackdropFilter(

        filter: ImageFilter.blur(

          sigmaX: 18,
          sigmaY: 18,
        ),

        child: Container(

          decoration: BoxDecoration(

            color:
                const Color(0xFF07111A),

            borderRadius:
                const BorderRadius.vertical(

              top: Radius.circular(28),
            ),

            border: Border.all(

              color:
                  Colors.white.withOpacity(0.06),
            ),
          ),

          child: Padding(

            padding: EdgeInsets.only(

              left: 20,
              right: 20,
              top: 14,

              bottom:
                  MediaQuery.of(context)
                          .viewInsets
                          .bottom +
                      20,
            ),

            child: SingleChildScrollView(

              child: Column(

                mainAxisSize:
                    MainAxisSize.min,

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Center(

                    child: Container(

                      width: 44,
                      height: 5,

                      decoration: BoxDecoration(

                        color:
                            Colors.white24,

                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(

                    AppLocalizations.of(context)!
                        .createToilet,

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 26,

                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(

                    AppLocalizations.of(context)!
                        .helpKeepMapAccurate,

                    style: TextStyle(

                      color:
                          Colors.white.withOpacity(0.65),

                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 26),

                  TextField(

                    controller: _titleController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    onChanged: (_) {

                      if (_titleError != null) {

                        setState(() {

                          _titleError = null;
                        });
                      }
                    },

                    decoration:
                        _inputDecoration(

                          AppLocalizations.of(context)!
                              .title,

                        ).copyWith(

                          errorText: _titleError,
                        ),
                  ),

                  const SizedBox(height: 16),

                  TextField(

                    controller:
                        _descriptionController,

                    maxLines: 4,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        _inputDecoration(

                      AppLocalizations.of(context)!
                          .description,
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(

                    controller:
                        _addressController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        _inputDecoration(

                      AppLocalizations.of(context)!
                          .address,
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(

                    value: _accessType,

                    dropdownColor:
                        const Color(0xFF101C26),

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        _inputDecoration(

                      AppLocalizations.of(context)!
                          .accessType,
                    ),

                    items: [

                      DropdownMenuItem(

                        value: 'FREE',

                        child: Text(

                          AppLocalizations.of(context)!
                              .freeAccess,
                        ),
                      ),

                      DropdownMenuItem(

                        value: 'PAID',

                        child: Text(

                          AppLocalizations.of(context)!
                              .paidAccess,
                        ),
                      ),

                      DropdownMenuItem(

                        value: 'CUSTOMERS_ONLY',

                        child: Text(

                          AppLocalizations.of(context)!
                              .customersOnly,
                        ),
                      ),
                    ],

                    onChanged: (value) {

                      if (value == null) {
                        return;
                      }

                      setState(() {

                        _accessType = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  Container(

                    decoration: BoxDecoration(

                      color:
                          Colors.white.withOpacity(0.04),

                      borderRadius:
                          BorderRadius.circular(18),

                      border: Border.all(

                        color:
                            Colors.white.withOpacity(0.06),
                      ),
                    ),

                    child: CheckboxListTile(

                      value:
                          _wheelchairAccessible,

                      activeColor:
                          Colors.cyanAccent,

                      checkColor:
                          Colors.black,

                      title: Text(

                        AppLocalizations.of(context)!
                            .wheelchairAccessible,

                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),

                      onChanged: (value) {

                        setState(() {

                          _wheelchairAccessible =
                              value ?? false;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 26),

                  SizedBox(

                    width: double.infinity,

                    height: 58,

                    child: DecoratedBox(

                      decoration: BoxDecoration(

                        borderRadius:
                            BorderRadius.circular(18),

                        boxShadow: [

                          BoxShadow(

                            color:
                                Colors.cyanAccent.withOpacity(0.35),

                            blurRadius: 24,
                          ),
                        ],
                      ),

                      child: FilledButton(

                        onPressed:
                            _isLoading
                                ? null
                                : _createToilet,

                        style:
                            FilledButton.styleFrom(

                          backgroundColor:
                              Colors.cyanAccent,

                          foregroundColor:
                              Colors.black,

                          shape:
                              RoundedRectangleBorder(

                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                        ),

                        child:
                            _isLoading

                                ? const SizedBox(

                                    width: 24,
                                    height: 24,

                                    child:
                                        CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )

                                : Text(

                                    AppLocalizations.of(context)!
                                        .create,

                                    style: const TextStyle(

                                      fontSize: 16,

                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}