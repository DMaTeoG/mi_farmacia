import 'package:flutter/material.dart';
import 'medicines_page.dart';
import 'sales_page.dart';
import 'notes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;
  final _pages = const [MedicinesPage(), SalesPage(), NotesPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_current],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _current,
        onDestinationSelected: (i) => setState(() => _current = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.medication), label: 'Inventario'),
          NavigationDestination(icon: Icon(Icons.point_of_sale), label: 'Ventas'),
          NavigationDestination(icon: Icon(Icons.sticky_note_2), label: 'Notas'),
        ],
      ),
    );
  }
}
