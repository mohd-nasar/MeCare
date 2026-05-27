import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../services/appointment_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedSlot;
  bool _isBooking = false;

  final List<String> _allSlots = [
    "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM",
    "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM", "06:00 PM"
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _handleBooking() async {
    if (_selectedDay == null || _selectedSlot == null) return;

    setState(() => _isBooking = true);
    try {
      await _appointmentService.bookAppointment(
        date: _selectedDay!,
        slot: _selectedSlot!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Appointment Confirmed!"),
            backgroundColor: Color(0xFF0F766E),
          ),
        );
        setState(() {
          _selectedSlot = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: \$e"), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF0F766E);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B141A) : Colors.white,
      appBar: AppBar(
        backgroundColor:
        const Color(
          0xFF38104D,
        ),

        title: const Text("Book Appointment", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Calendar Section ---
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F2C34) : Colors.grey[50],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 30)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedSlot = null; 
                  });
                },
                enabledDayPredicate: (day) {
                  return day.weekday != DateTime.sunday;
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(color: primaryTeal, shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(color: primaryTeal.withOpacity(0.3), shape: BoxShape.circle),
                  markerDecoration: const BoxDecoration(color: primaryTeal, shape: BoxShape.circle),
                  disabledTextStyle: const TextStyle(color: Colors.grey),
                  weekendTextStyle: const TextStyle(color: Colors.redAccent),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text("Available Slots", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // --- Slots Section ---
            StreamBuilder<List<String>>(
              stream: _appointmentService.getBookedSlots(_selectedDay ?? _focusedDay),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: primaryTeal),
                  ));
                }

                final bookedSlots = snapshot.data ?? [];

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _allSlots.map((slot) {
                      bool isBooked = bookedSlots.contains(slot);
                      bool isSelected = _selectedSlot == slot;

                      return InkWell(
                        onTap: isBooked ? null : () => setState(() => _selectedSlot = slot),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? primaryTeal
                                : (isBooked ? Colors.grey[200] : (isDark ? Colors.white10 : Colors.white)),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected ? primaryTeal : (isBooked ? Colors.transparent : Colors.grey[300]!),
                            ),
                          ),
                          child: Text(
                            slot,
                            style: TextStyle(
                              color: isSelected 
                                  ? Colors.white 
                                  : (isBooked ? Colors.grey[400] : (isDark ? Colors.white70 : Colors.black87)),
                              fontWeight: FontWeight.w600,
                              decoration: isBooked ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2C34) : Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: (_selectedDay == null || _selectedSlot == null || _isBooking) ? null : _handleBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryTeal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
            child: _isBooking 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Confirm Appointment", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
