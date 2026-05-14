import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models/create_toilet_request.dart';

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

  String _accessType = 'FREE';

  bool _wheelchairAccessible =
      false;

  Future<void> _createToilet() async {

    final title =
        _titleController.text.trim();

    if (title.isEmpty) {
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

  @override
  void dispose() {

    _titleController.dispose();

    _descriptionController.dispose();

    _addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: EdgeInsets.only(

        left: 16,
        right: 16,
        top: 16,

        bottom:
            MediaQuery.of(context)
                    .viewInsets
                    .bottom +
                16,
      ),

      child: SingleChildScrollView(

        child: Column(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            const Text(

              'Create Toilet',

              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            TextField(

              controller:
                  _titleController,

              decoration:
                  const InputDecoration(

                labelText: 'Title',

                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(

              controller:
                  _descriptionController,

              maxLines: 3,

              decoration:
                  const InputDecoration(

                labelText:
                    'Description',

                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(

              controller:
                  _addressController,

              decoration:
                  const InputDecoration(

                labelText:
                    'Address',

                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(

              value: _accessType,

              decoration:
                  const InputDecoration(

                labelText:
                    'Access Type',

                border:
                    OutlineInputBorder(),
              ),

              items: const [

                DropdownMenuItem(
                  value: 'FREE',
                  child: Text('Free'),
                ),

                DropdownMenuItem(
                  value: 'PAID',
                  child: Text('Paid'),
                ),

                DropdownMenuItem(
                  value: 'CUSTOMERS_ONLY',
                  child: Text(
                    'Customers Only',
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

            const SizedBox(height: 12),

            CheckboxListTile(

              value:
                  _wheelchairAccessible,

              title: const Text(
                'Wheelchair Accessible',
              ),

              contentPadding:
                  EdgeInsets.zero,

              onChanged: (value) {

                setState(() {

                  _wheelchairAccessible =
                      value ?? false;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(

              width: double.infinity,

              child: FilledButton(

                onPressed:
                    _isLoading
                        ? null
                        : _createToilet,

                child:
                    _isLoading

                        ? const SizedBox(

                            width: 22,
                            height: 22,

                            child:
                                CircularProgressIndicator(),
                          )

                        : const Text(
                            'Create',
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}