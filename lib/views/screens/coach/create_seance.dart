import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coach_app/model/groupe.dart';
import 'package:flutter_coach_app/service/group.dart';
import 'package:flutter_coach_app/model/seance.dart';
import 'package:flutter_coach_app/service/session.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ajouter une Séance'),
        ),
        body: AddSession(),
      ),
    );
  }
}

class AddSession extends StatefulWidget {
  const AddSession({Key? key}) : super(key: key);

  @override
  _AddSessionState createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDateSession = DateTime.now();
  List<String> itemList = [];
  List<String> typeSession = ['Force', 'Cardio'];
  String selectedTypeSession = 'Force';
  String selectedValue = '';
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Ajouter une Séance'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nom de la séance',
                    hintText: 'Donnez un nom à la séance',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.trim().length < 5) {
                      return "Nom de la séance invalide";
                    }
                    return null;
                  },
                  controller: nameController,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Donnez une description à la séance',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: descriptionController,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                  items: itemList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<String>(
                  value: selectedTypeSession,
                  onChanged: (value) {
                    setState(() {
                      selectedTypeSession = value!;
                    });
                  },
                  items: typeSession.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Row(children: [
                        (item == 'Force')
                            ? Icon(
                                Icons.fitness_center,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.run_circle,
                                color: Colors.blue,
                              ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(item)
                      ]),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Définir une date de votre choix',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (e) {
                    if (e != null && e.isBefore(DateTime.now())) {
                      return 'Veuillez sélectionner une date égale ou postérieure à aujourd\'hui';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Heure de début',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                InkWell(
                  onTap: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      setState(() {
                        selectedStartTime = DateTime(
                          selectedDateSession.year,
                          selectedDateSession.month,
                          selectedDateSession.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      selectedStartTime != null
                          ? DateFormat.Hm().format(selectedStartTime!)
                          : 'Sélectionnez l\'heure',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Heure de fin',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                InkWell(
                  onTap: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      setState(() {
                        selectedEndTime = DateTime(
                          selectedDateSession.year,
                          selectedDateSession.month,
                          selectedDateSession.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      selectedEndTime != null
                          ? DateFormat.Hm().format(selectedEndTime!)
                          : 'Sélectionnez l\'heure',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      label: Text("Valider"),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            selectedStartTime != null &&
                            selectedEndTime != null &&
                            selectedStartTime!.isBefore(selectedEndTime!)) {
                          // Les heures sont valides
                          Session mySession = Session(
                            endTime: DateFormat.Hm().format(selectedEndTime!),
                            startTime:
                                DateFormat.Hm().format(selectedStartTime!),
                            id: 'rrt',
                            day: selectedDateSession,
                            name: nameController.text,
                            description: descriptionController.text,
                            typ: selectedTypeSession,
                            group: selectedValue,
                            status: 'Yes',
                          );
                          Navigator.of(context).pop();
                          createSession(selectedValue, mySession);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Création de la séance en cours'),
                            ),
                          );
                          FocusScope.of(context).requestFocus(FocusNode());
                        } else {
                          // Afficher un message d'erreur si l'heure de début est après l'heure de fin
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'L\'heure de début doit être avant l\'heure de fin'),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.done),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 20)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchGroups() async {
    List<Group> groups = await getAllGroup();
    print(groups);

    setState(() {
      itemList = groups.map((group) => group.name as String).toList();
      selectedValue = itemList[0];
    });
  }
}
