class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String experience;
  final String education;
  final String photoUrl;
  final List<String> clinicIds;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.education,
    required this.photoUrl,
    required this.clinicIds,
  });
}
