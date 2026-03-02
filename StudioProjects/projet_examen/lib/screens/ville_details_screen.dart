import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projet_examen/models/config.dart';
import 'package:projet_examen/models/ville.dart';

class VilleDetailsScreen extends StatefulWidget {
  final Ville ville;
  final Map<String, dynamic> meteoData;

  const VilleDetailsScreen({
    Key? key,
    required this.ville,
    required this.meteoData,
  }) : super(key: key);

  @override
  State<VilleDetailsScreen> createState() => _VilleDetailsScreenState();
}

class _VilleDetailsScreenState extends State<VilleDetailsScreen> {
  late GoogleMapController mapController;
  late LatLng _center;
  Set<Marker> _markers = {};
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    // Coordonnées par défaut ou récupérées de l'API
    _center = LatLng(
      widget.meteoData['coord']['lat'],
      widget.meteoData['coord']['lon'],
    );

    _markers.add(
      Marker(
        markerId: MarkerId(widget.ville.nom),
        position: _center,
        infoWindow: InfoWindow(title: widget.ville.nom),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _mapReady = true;
    });
  }

  // Détermine l'icône météo en fonction de la condition
  IconData _getWeatherIcon() {
    String condition = widget.ville.couverture.toLowerCase();
    if (condition.contains('rain') || condition.contains('pluie')) {
      return Icons.umbrella;
    } else if (condition.contains('cloud') || condition.contains('nuage')) {
      return Icons.cloud;
    } else if (condition.contains('snow') || condition.contains('neige')) {
      return Icons.ac_unit;
    } else {
      return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    if (widget.ville.couverture.toLowerCase().contains('cloud') ||
        widget.ville.couverture.toLowerCase().contains('nuage')) {
      iconColor = Colors.grey;
    } else if (widget.ville.couverture.toLowerCase().contains('rain') ||
        widget.ville.couverture.toLowerCase().contains('pluie')) {
      iconColor = Colors.blue;
    } else {
      iconColor = Colors.amber;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ville.nom),
        backgroundColor: const Color(backScafoldColor),
      ),
      body: Column(
        children: [
          // Informations météo de la ville
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color(backScafoldColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getWeatherIcon(),
                      color: iconColor,
                      size: 40,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${widget.ville.temperature}°C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: family,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.ville.couverture,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: family,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.water_drop,
                      color: Colors.lightBlueAccent,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Humidité: ${widget.ville.humidite}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: family,
                      ),
                    ),
                  ],
                ),
                // Ajoutez d'autres informations météo selon besoin
                if (widget.meteoData.containsKey('wind')) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.air,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Vent: ${widget.meteoData['wind']['speed']} m/s',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: family,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Carte Google Maps
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                  markers: _markers,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                ),

                // Indicateur de chargement
                if (!_mapReady)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}