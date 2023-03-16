import 'package:flutter/material.dart';
import 'package:foodful/utils/colors.dart';
import '../screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../helpers/location_helper.dart';
import '../screens/signup_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  late String? _previewImageUrl = null;

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }

    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);

    LocationHelper.generateLocationPreviewImage(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );

    setState(() {
      _previewImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: selectedLocation.latitude,
        longitude: selectedLocation.longitude,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? Text('No Location Chosen')
              : Image.network(_previewImageUrl!,
                  fit: BoxFit.cover, width: double.infinity),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(lightpinkColor),
                ),
                onPressed: _selectOnMap,
                icon: const Icon(Icons.map),
                label: const Text('Select on Map'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
