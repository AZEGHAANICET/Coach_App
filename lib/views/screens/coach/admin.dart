import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coach_app/views/screens/coach/availability_coach.dart';
import 'package:flutter_coach_app/views/screens/coach/availability_coach_customize.dart';
import 'package:flutter_coach_app/views/screens/coach/cancell_session.dart';
import 'package:flutter_coach_app/views/screens/coach/home_coach.dart';
import 'package:flutter_coach_app/views/screens/coach/session_coach.dart';
import 'package:flutter_coach_app/views/screens/common/profile.dart';
import 'package:flutter_coach_app/views/screens/common/settings.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Welcome Coach Loïc'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            color: const Color.fromARGB(255, 20, 214, 43),
            icon: const Icon(Icons.more_vert),
            offset: const Offset(22, 50),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Paramètres',
                  child: ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Paramètres'),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const Setting(),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                ),
                PopupMenuItem<String>(
                  value: 'Deconnexion',
                  child: ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Deconnexion'),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
                PopupMenuItem<String>(
                  value: 'Infos',
                  child: ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Infos'),
                  ),
                ),
              ];
            },
            onSelected: (value) {
              performAction(value);
            },
          ),
        ],
        backgroundColor: const Color.fromRGBO(255, 152, 0, 1),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home)),
            Tab(
              child: Text(
                'Séance(s)',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(child: Icon(Icons.access_time, color: Colors.green)),
            Tab(
                child: Row(
              children: [Icon(Icons.cancel, color: Colors.red)],
            ))
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HomeCoach(),
          SessionScreenCoach(),
          AvailabilityList(),
          CancelSession()
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String> data = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
    'Kiwi',
    'Lemon',
  ];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? []
        : data
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            // Renvoie la suggestion sélectionnée
            close(context, suggestionList[index]);
          },
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Actions à droite de la barre de recherche (effacer le texte, etc.)
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    // Résultats de la recherche
    return Center(
      child: Text('Résultats pour "$query"'),
    );
  }

  void performAction(String action) {
    print('Performing action: $action');
    // Add logic to perform the selected action
  }
}

void performAction(String action) {
  print('Performing action: $action');
  // Add logic to perform the selected action
}
