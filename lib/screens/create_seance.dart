import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddSession extends StatefulWidget {
  const AddSession({super.key});

  @override
  State<AddSession> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddSession> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDateSession = DateTime.now();
  List<String> itemList = ['groupe 1', 'Groupe 2', 'Groupe 3'];

  String selectedValue = '';
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Nom de la seance',
                hintText: 'Donne un nom à la séance',
                border: OutlineInputBorder(),
                fillColor: Colors.green,
              ),
              validator: (value) {
                if (value!.trim().length < 5) {
                  return "Nom de la séance invalid";
                }
                return null;
              },
              controller: nameController,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Donne une description à la séance',
                border: OutlineInputBorder(),
                fillColor: Colors.green,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: descriptionController,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: DropdownButtonFormField(
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value!;
                });
              },
              items: itemList.map<DropdownMenuItem<dynamic>>((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: DateTimeFormField(
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black45),
                errorStyle: TextStyle(color: Colors.redAccent),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.event_note),
                labelText: 'Definir une date de votre choix',
              ),
              mode: DateTimeFieldPickerMode.time,
              autovalidateMode: AutovalidateMode.always,
              validator: (e) =>
                  (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
              onDateSelected: (DateTime value) {
                setState(() {
                  selectedDateSession = value;
                });
              },
            ),
          ),
          SizedBox(
            child: ElevatedButton.icon(
              label: Text("Valider"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Creation de la séance en cours'),
                    ),
                  );
                  FocusScope.of(context).requestFocus(FocusNode());
                  CollectionReference sessionRef =
                      FirebaseFirestore.instance.collection("Session");
                  sessionRef.add({});
                }
              },
              icon: Icon(Icons.confirmation_num),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          )
        ]),
      ),
    );
  }
}
