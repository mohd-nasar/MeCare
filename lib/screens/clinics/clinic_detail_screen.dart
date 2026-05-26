import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/clinic.dart';
import '../../data/dummy_data.dart';
import '../doctors/doctor_detail_screen.dart';

class ClinicDetailScreen extends StatefulWidget {
  final Clinic clinic;

  const ClinicDetailScreen({super.key, required this.clinic});

  @override
  State<ClinicDetailScreen> createState() => _ClinicDetailScreenState();
}

class _ClinicDetailScreenState extends State<ClinicDetailScreen> {
  GoogleMapController? _mapController;
  bool _showMapError = false;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clinicDoctors = dummyDoctors
        .where((doctor) => widget.clinic.doctorIds.contains(doctor.id))
        .toList();

    final LatLng center = LatLng(widget.clinic.latitude, widget.clinic.longitude);

    return Scaffold(
      appBar: AppBar(title: Text(widget.clinic.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.clinic.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.clinic.about,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Location & Address',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(widget.clinic.address)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      color: Colors.grey[100],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        GoogleMap(
                          onMapCreated: (controller) {
                            setState(() {
                              _mapController = controller;
                            });
                          },
                          initialCameraPosition: CameraPosition(
                            target: center,
                            zoom: 16.0,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId(widget.clinic.id),
                              position: center,
                              infoWindow: InfoWindow(title: widget.clinic.name),
                            ),
                          },
                          zoomControlsEnabled: true,
                          myLocationButtonEnabled: false,
                        ),
                        // Overlay if map doesn't show tiles (common without API key)
                        if (_mapController == null)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Note: If the map is blank/grey, please ensure you have added a valid Google Maps API Key to AndroidManifest.xml and enabled the Maps SDK for Android.',
                    style: TextStyle(fontSize: 11, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Doctors at this Clinic',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: clinicDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = clinicDoctors[index];
                      return Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(doctor.photoUrl),
                          ),
                          title: Text(doctor.name),
                          subtitle: Text(doctor.specialization),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorDetailScreen(doctor: doctor),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
