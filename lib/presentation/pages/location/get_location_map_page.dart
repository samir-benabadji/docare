import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GetLocationMapPage extends StatelessWidget {
  final double width;
  final double height;
  final double? latitude;
  final double? longitude;

  const GetLocationMapPage({
    Key? key,
    required this.width,
    required this.height,
    this.latitude,
    this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LatLng doctorLocation = LatLng(latitude ?? 40.7128, longitude ?? -74.0060);

    return Container(
      width: width,
      height: height,
      child: FlutterMap(
        options: MapOptions(
          center: doctorLocation,
          zoom: 13.0,
          onTap: (_, __) {}, // Disabling onTap
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: doctorLocation,
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
