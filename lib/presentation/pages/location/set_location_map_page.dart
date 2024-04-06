import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetLocationMapPage extends StatefulWidget {
  final double? defaultLatitude;
  final double? defaultLongitude;

  SetLocationMapPage({
    Key? key,
    this.defaultLatitude,
    this.defaultLongitude,
  }) : super(key: key);

  @override
  _SetLocationMapPageState createState() => _SetLocationMapPageState();
}

class _SetLocationMapPageState extends State<SetLocationMapPage> {
  final MapController _mapController = MapController();
  late LatLng _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(widget.defaultLatitude ?? 40.71, widget.defaultLongitude ?? -74.00);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pickYourLocation),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _selectedLocation == null
                ? null
                : () {
                    // Returning the selected location back to the previous screen
                    Navigator.of(context).pop(_selectedLocation.toLatLngString());
                  },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _selectedLocation,
          zoom: 13.0,
          onTap: (_, latLng) {
            setState(() {
              _selectedLocation = latLng;
            });
          },
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          if (_selectedLocation != null)
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: _selectedLocation,
                  builder: (ctx) => Icon(
                    Icons.location_pin,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

extension on LatLng {
  Map<String, String> toLatLngString() => {
        'latitude': this.latitude.toString(),
        'longitude': this.longitude.toString(),
      };
}
