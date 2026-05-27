import '../models/clinic.dart';
import '../models/doctor.dart';

final List<Clinic> dummyClinics = [
  Clinic(
    id: 'c1',
    name: 'MindCare Center Sukkur',
    imageUrl: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=600',
    address: 'Military Road, Sukkur, Sindh, Pakistan',
    latitude: 27.7244,
    longitude: 68.8228,
    doctorIds: ['d1'],
    about: 'MindCare Center Sukkur is a specialized mental health facility providing psychiatric clinic services, inpatient facilities, and psychotherapy. We are dedicated to providing compassionate care for various mental health disorders in a safe and supportive environment.',
  ),
];

final List<Doctor> dummyDoctors = [
  Doctor(
    id: 'd1',
    name: 'Dr Najamuddin',
    specialization: 'Consultant Psychiatrist',
    experience: '20+ Years',
    education: 'MBBS, MCPS, MRCPsych (London)',
    photoUrl: 'https://i.pravatar.cc/300?u=dr_najamuddin',
    clinicIds: ['c1'],
  ),
];
