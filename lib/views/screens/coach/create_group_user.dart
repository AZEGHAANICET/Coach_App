import 'package:flutter/material.dart';

List<Map<String, dynamic>> usersData = [
  {'username': 'environnement connexe', 'desc': 'Yo akalo pro'},
  {'username': 'Famille Kalms', 'desc': 'Yo akalo pro'},
  {'username': 'Flutter Project', 'desc': 'Yo akalo pro'},
  {'username': 'Test', 'desc': 'Yo akalo pro'},
];

class AddGroup extends StatefulWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  List<String> selectedUsers = [];

  List<bool> isSelectedList = List.generate(usersData.length, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Sélectionné des Utilisateurs'),
      ),
      body: ListView.builder(
        itemCount: usersData.length,
        itemBuilder: (context, index) {
          String username = usersData[index]['username'];
          String subtitle = usersData[index]['desc'];
          bool isSelected = isSelectedList[index];

          return ListTile(
            leading: Container(
              child: !isSelected
                  ? Icon(Icons.person, color: Colors.green)
                  : Icon(Icons.check,
                      color: const Color.fromRGBO(244, 67, 54, 1)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            title: Text(username),
            subtitle: Text(subtitle),
            onTap: () {
              setState(() {
                if (selectedUsers.contains(username)) {
                  isSelectedList[index] = false;
                  print("User remove");
                  selectedUsers.remove(username);
                } else {
                  isSelectedList[index] = true;
                  selectedUsers.add(username);
                  print("User add");
                }
              });
            },
          );
        },
      ),
      floatingActionButton: (selectedUsers.length > 0)
          ? FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () {
                // Valider le choix et notifier les utilisateurs sélectionnés
                if (selectedUsers.isNotEmpty) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CreateGroup(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      transitionDuration: Duration(milliseconds: 500),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Aucun utilisateur sélectionné.'),
                    ),
                  );
                }
              },
              child: Icon(Icons.check),
            )
          : null,
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content:
              Text('Voulez-vous ajouter ces utilisateurs à votre groupe ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _addUsersToGroup();
                Navigator.of(context).pop();
              },
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  void _addUsersToGroup() {
    print('Thanks for add this users');
  }
}

class CreateGroup extends StatelessWidget {
  const CreateGroup({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    TextEditingController descriptionController = new TextEditingController();
    TextEditingController nameController = new TextEditingController();
    final _formKey = GlobalKey<FormState>();
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
                  labelText: 'Nom du groupe',
                  hintText: 'Attribuez un nom à ce groupe',
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
                  hintText: 'Donnez une description du groupe',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: descriptionController,
              ),
              SizedBox(height: 16),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    label: Text("Valider"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
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
