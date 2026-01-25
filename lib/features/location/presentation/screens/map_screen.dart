import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grocery_app/features/location/presentation/widgets/location_container.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/features/location/presentation/provider/location_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng currentLocation;
  final MapController _mapController = MapController();
  Timer? _debounceTimer;
  bool locationFetched = false;

  @override
  void initState() {
    super.initState();
    final locationData = Provider.of<LocationProvider>(context, listen: false);
    locationData.fetchCurrentLocation().then((_) {
      if (locationData.latitude != null && locationData.longitude != null) {
        currentLocation = LatLng(
          locationData.latitude!,
          locationData.longitude!,
        );
        locationData.getMoveCamera();
      } else {
        currentLocation = const LatLng(0, 0);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    currentLocation = LatLng(
      locationData.latitude ?? 0,
      locationData.longitude ?? 0,
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentLocation,
                initialZoom: 16.5,
                minZoom: 1.5,
                maxZoom: 20.8,
                onPositionChanged: (position, hasGesture) {
                  locationData.onCameraMove(position);

                  _debounceTimer?.cancel();
                  _debounceTimer = Timer(const Duration(milliseconds: 300), () {
                    setState(() {
                      locationFetched = true;
                    });
                    locationData.getMoveCamera();
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.grocery_app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        locationData.latitude ?? 0,
                        locationData.longitude ?? 0,
                      ),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            LocationContainer(locationData: locationData),
          ],
        ),
      ),
    );
  }
}
