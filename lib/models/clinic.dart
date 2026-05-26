class Clinic {
  final String id;
  final String name;
  final String imageUrl;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> doctorIds;

  final String about;

  Clinic({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.doctorIds,
    required this.about,
  });
}
