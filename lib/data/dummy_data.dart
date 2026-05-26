import '../models/clinic.dart';
import '../models/doctor.dart';

final List<Clinic> dummyClinics = [
  Clinic(
    id: 'c1',
    name: 'City Central Clinic',
    imageUrl: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=400',
    address: 'Taj Ganj, Agra, Uttar Pradesh 282001, India',
    latitude: 27.1751,
    longitude: 78.0421,
    doctorIds: ['d1', 'd3'],
    about: 'City Central Clinic is a state-of-the-art medical facility located near the iconic Taj Mahal. We provide comprehensive healthcare services with a focus on patient comfort and advanced medical technology.',
  ),
  Clinic(
    id: 'c2',
    name: 'Green Valley Medical',
    imageUrl: 'https://images.unsplash.com/photo-1504813184591-01592fd03cfd?auto=format&fit=crop&q=80&w=400',
    address: 'Dharmapuri, Forest Colony, Tajganj, Agra, UP 282001',
    latitude: 27.1682,
    longitude: 78.0473,
    doctorIds: ['d2', 'd4'],
    about: 'Green Valley Medical is dedicated to providing high-quality primary and specialized care to the Agra community. Our team of experienced doctors ensures personalized attention for every patient.',
  ),
];

final List<Doctor> dummyDoctors = [
  Doctor(
    id: 'd1',
    name: 'Dr. Sarah Smith',
    specialization: 'Cardiology',
    experience: '12 Years',
    education: 'MD - Harvard Medical School',
    photoUrl: 'https://i.pravatar.cc/150?u=d1',
    clinicIds: ['c1'],
  ),
  Doctor(
    id: 'd2',
    name: 'Dr. John Doe',
    specialization: 'Neurology',
    experience: '8 Years',
    education: 'MD - Stanford University',
    photoUrl: 'https://i.pravatar.cc/150?u=d2',
    clinicIds: ['c2'],
  ),
  Doctor(
    id: 'd3',
    name: 'Dr. Emily White',
    specialization: 'Cardiology',
    experience: '15 Years',
    education: 'MD - Johns Hopkins University',
    photoUrl: 'https://i.pravatar.cc/150?u=d3',
    clinicIds: ['c1'],
  ),
  Doctor(
    id: 'd4',
    name: 'Dr. Michael Brown',
    specialization: 'Pediatrics',
    experience: '5 Years',
    education: 'MD - Yale School of Medicine',
    photoUrl: 'https://i.pravatar.cc/150?u=d4',
    clinicIds: ['c2'],
  ),
];
