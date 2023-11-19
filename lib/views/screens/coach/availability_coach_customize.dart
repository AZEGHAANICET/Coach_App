import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class AvailabilityList extends StatefulWidget {
  const AvailabilityList({Key? key}) : super(key: key);

  @override
  _AvailabilityListState createState() => _AvailabilityListState();
}

class _AvailabilityListState extends State<AvailabilityList> {
  Map<String, Map<String, DateTime>> availabilityPeriods = {
    'Lun': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Mar': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Mer': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Jeu': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Ven': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Sam': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Dim': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
  };

  late DateTime _selectedDate;
  TextEditingController _periodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TableCalendar(
            focusedDay: _selectedDate,
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(Duration(days: 365)),
            calendarFormat: CalendarFormat.week,
            // onDaySelected: (day, events, formats) {
            //   setState(() {
            //     _selectedDate = day;
            //   });
            // },
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: availabilityPeriods.length,
              itemBuilder: (context, index) {
                String day = availabilityPeriods.keys.elementAt(index);
                DateTime start = availabilityPeriods[day]!['start']!;
                DateTime end = availabilityPeriods[day]!['end']!;

                return AvailabilityListItem(
                  day: day,
                  start: start,
                  end: end,
                  onEdit: () {
                    _editAvailability(day, start, end);
                  },
                  onDelete: () {
                    _deleteAvailability(day);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajouter une nouvelle disponibilité
          // ...
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editAvailability(String day, DateTime start, DateTime end) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Modifier la disponibilité pour $day',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Heure de début :'),
                    TimePickerSpinner(
                      is24HourMode: true,
                      normalTextStyle:
                          TextStyle(fontSize: 16, color: Colors.grey),
                      highlightedTextStyle:
                          TextStyle(fontSize: 20, color: Colors.black),
                      spacing: 40,
                      itemHeight: 60,
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        setState(() {
                          availabilityPeriods[day]!['start'] = time;
                        });
                      },
                      time: start,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Heure de fin :'),
                    TimePickerSpinner(
                      is24HourMode: true,
                      normalTextStyle:
                          TextStyle(fontSize: 16, color: Colors.grey),
                      highlightedTextStyle:
                          TextStyle(fontSize: 20, color: Colors.black),
                      spacing: 40,
                      itemHeight: 60,
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        setState(() {
                          availabilityPeriods[day]!['end'] = time;
                        });
                      },
                      time: end,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Mettez à jour les données de disponibilité ici
                    Navigator.pop(context);
                    // Mise à jour de la liste après modification
                    setState(() {});
                  },
                  child: Text('Enregistrer'),
                ),
                SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    _deleteAvailability(day);
                    Navigator.pop(context);
                    // Mise à jour de la liste après suppression
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text('Supprimer cette disponibilité'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteAvailability(String day) {
    setState(() {
      availabilityPeriods.remove(day);
    });
  }
}

class AvailabilityListItem extends StatelessWidget {
  final String day;
  final DateTime start;
  final DateTime end;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  AvailabilityListItem({
    required this.day,
    required this.start,
    required this.end,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text('Jour: $day'),
        subtitle: Text(
            'Heure de début: ${start.hour}:${start.minute}, Heure de fin: ${end.hour}:${end.minute}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit,
                  color: Colors.blue), // Couleur bleue pour l'icône "Edit"
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete,
                  color: Colors.red), // Couleur rouge pour l'icône "Delete"
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
