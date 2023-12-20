import 'package:flutter/material.dart';
import 'package:flutter_coach_app/model/groupe.dart';
import 'package:flutter_coach_app/model/seance.dart';
import 'package:flutter_coach_app/service/group.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  List<dynamic> selectedUsers = [];
  List<bool> isSelectedList = [];
  List<dynamic> sessions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Sélectionné des Utilisateurs'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Aucun utilisateur trouvé.'),
            );
          }

          List<Map<String, dynamic>> users = snapshot.data!;
          isSelectedList = List.generate(users.length, (index) => false);

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> userData = users[index];
              String id = userData["id"];
              String username = userData['username'];
              String subtitle = userData['email'];
              bool isSelected = isSelectedList[index];

              return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData['image']),
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text(username),
                  subtitle: Text(subtitle),
                  onTap: () {
                    setState(() {
                      if (selectedUsers.contains(username)) {
                        isSelectedList[index] = false;
                        print("User remove");
                        selectedUsers.remove(id);
                      } else {
                        isSelectedList[index] = true;
                        selectedUsers.add(id);
                      }
                    });
                  },
                  tileColor: isSelected ? Colors.blue.withOpacity(0.3) : null);
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
                      pageBuilder: (_, __, ___) => CreateGroup(
                          group: Group(
                              id: 1,
                              pName: '',
                              users: selectedUsers,
                              sessions: sessions)),
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

  void _showConfirmationDialog(String name, List<String> users) {
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
                Navigator.of(context).pop();
              },
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }
}

class CreateGroup extends StatelessWidget {
  final Group group;

  const CreateGroup({Key? key, required this.group}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    TextEditingController descriptionController = new TextEditingController();
    TextEditingController nameController = new TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Créer un groupe'),
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
                    return "Nom du groupe invalide";
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
                        group.name = nameController.text;
                        createGroup(group);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Création du groupe en cours'),
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
