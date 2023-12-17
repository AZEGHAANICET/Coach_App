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
    'Lundi': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Mardi': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Mercredi': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Jeudi': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Vendredi': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Samedi': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
    'Dimanche': {
      'start': DateTime.now(),
      'end': DateTime.now().add(Duration(hours: 1)),
    },
  };

  late DateTime _selectedDate;
  TextEditingController _durationController = TextEditingController();
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _startTime = DateTime.now();
    _endTime = DateTime.now().add(Duration(hours: 1));
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
          _showAddAvailabilityForm();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _editAvailability(String day, DateTime start, DateTime end) {
    // Votre logique d'édition ici
  }

  void _deleteAvailability(String day) {
    setState(() {
      availabilityPeriods.remove(day);
    });
  }

  void _showAddAvailabilityForm() {
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
                  'Ajouter une disponibilité',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                DropdownButton<String>(
                  value:
                      'Lundi', // La valeur sélectionnée, vous pouvez la changer dynamiquement
                  items: availabilityPeriods.keys.map((String day) {
                    return DropdownMenuItem<String>(
                      value: day,
                      child: Text(day),
                    );
                  }).toList(),
                  onChanged: (String? selectedDay) {
                    setState(() {
                      // Mettez à jour la valeur sélectionnée
                    });
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Heure de début :'),
                    TimePickerSpinner(
                      is24HourMode: true,
                      normalTextStyle:
                          TextStyle(fontSize: 16, color: Colors.grey),
                      highlightedTextStyle:
                          TextStyle(fontSize: 24, color: Colors.black),
                      spacing: 50,
                      itemHeight: 80,
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        setState(() {
                          _startTime = time;
                        });
                      },
                      time: _startTime,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Heure de fin :'),
                    TimePickerSpinner(
                      is24HourMode: true,
                      normalTextStyle:
                          TextStyle(fontSize: 16, color: Colors.grey),
                      highlightedTextStyle:
                          TextStyle(fontSize: 24, color: Colors.black),
                      spacing: 50,
                      itemHeight: 80,
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        setState(() {
                          _endTime = time;
                        });
                      },
                      time: _endTime,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _saveAvailability();
                  },
                  child: Text('Enregistrer'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveAvailability() {
    // Vérifier si la durée est valide
    double duration = double.tryParse(_durationController.text) ?? 0.0;
    if (duration <= 0) {
      // Afficher un message d'erreur si la durée n'est pas valide
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer une durée valide.'),
        ),
      );
      return;
    }

    // Ajouter la nouvelle disponibilité à la liste
    String selectedDay =
        'Lundi'; // Remplacez cela par la valeur réelle sélectionnée dans le dropdown
    DateTime start = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    DateTime end = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    setState(() {
      availabilityPeriods[selectedDay] = {'start': start, 'end': end};
    });

    // Fermer le formulaire
    Navigator.pop(context);
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
          'Heure de début: ${start.hour}:${start.minute}, Heure de fin: ${end.hour}:${end.minute}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
