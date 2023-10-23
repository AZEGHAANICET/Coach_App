import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AvailabilityCoach extends StatefulWidget {
  const AvailabilityCoach({super.key});

  @override
  State<AvailabilityCoach> createState() => _AvailabilityCoachState();
}

class _AvailabilityCoachState extends State<AvailabilityCoach> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disponibilité Coach',
      home: Scaffold(
        body: SfCalendar(
          view: CalendarView.week,
          dataSource: MeetingDataSource(getAppointments()),
        ),
      ),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Conference',
      color: Colors.orange));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
