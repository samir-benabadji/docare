import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMapPage extends StatefulWidget {
  @override
  _LocationMapPageState createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Your Location'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _selectedLocation == null
                ? null
                : () {
                    // Returning the selected location back to the previous screen
                    Navigator.of(context).pop(_selectedLocation!.toLatLngString());
                  },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(40.71, -74.00), // Default to New York City
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
                  point: _selectedLocation!,
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
  String toLatLngString() => '${this.latitude}, ${this.longitude}';
}
