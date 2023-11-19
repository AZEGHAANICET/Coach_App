import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coach_app/repository/seance_repository.dart';

class AddSession extends StatefulWidget {
  const AddSession({Key? key}) : super(key: key);

  @override
  _AddSessionState createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDateSession = DateTime.now();
  List<String> itemList = ['Groupe 1', 'Groupe 2', 'Groupe 3'];
  List<String> typeSession = ['Force', 'Cardio'];
  String selectedTypeSession = 'Force';
  String selectedValue = 'Groupe 1';

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
      body: Padding(
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
                    child: Text(item),
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
                validator: (e) => (e?.day ?? 0) == 1
                    ? 'Veuillez ne pas choisir le premier jour'
                    : null,
                onDateSelected: (DateTime value) {
                  setState(() {
                    selectedDateSession = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    label: Text("Valider"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        SessionRepository.createsession(
                            user!.uid,
                            nameController.text,
                            nameController.text,
                            descriptionController.text,
                            typeSession.first,
                            selectedDateSession);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Création de la séance en cours'),
                          ),
                        );
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                    icon: Icon(Icons.done),
                    style: ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 20)),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.orange)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
