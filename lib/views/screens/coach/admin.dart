import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coach_app/views/screens/coach/availability_coach.dart';
import 'package:flutter_coach_app/views/screens/coach/availability_coach_customize.dart';
import 'package:flutter_coach_app/views/screens/coach/disponibilite_coach.dart';
import 'package:flutter_coach_app/views/screens/coach/home_coach.dart';
import 'package:flutter_coach_app/views/screens/common/profile.dart';
import 'package:flutter_coach_app/views/screens/coach/session_coach.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

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
        title: const Text('Welcome Coach Loïc'),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
        backgroundColor: const Color.fromRGBO(255, 152, 0, 1),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home)),
            Tab(
              child: Text('Séance'),
            ),
            Tab(
              child: Text('Disponibilité'),
            ),
            Tab(
              child: Text('Mon profile'),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Tab 1 content
          HomeCoach(),
          SessionScreenCoach(),
          AvailabilityList(),
          //Disponibilite(),
          Profile()
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
      icon: Icon(Icons.arrow_back),
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
        icon: Icon(Icons.clear),
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
}
