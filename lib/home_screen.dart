// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_1/models/user_profile.dart';
import 'package:flutter_application_1/screens/questionnaire/step_name.dart';
import 'package:flutter_application_1/screens/exercises_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfiles de Juego'),
        backgroundColor: colorPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('perfiles')
            .orderBy('fechaCreacion')
            .snapshots(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay perfiles aún',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data();
              final profile = UserProfile(
                nombre: data['nombre'] as String?,
                edad: data['edad'] as String?,
                nivelHabla: data['nivelHabla'] as String?,
                palabrasConocidas:
                    data['palabrasConocidas'] as String?,
                comprendeOrden: data['comprendeOrden'] as bool?,
                comprendeTiempo: data['comprendeTiempo'] as bool?,
                puedeDecirNombre: data['puedeDecirNombre'] as bool?,
                sigueInstrucciones:
                    data['sigueInstrucciones'] as bool?,
                comprendeLoQueEscucha:
                    data['comprendeLoQueEscucha'] as bool?,
                respondeAlNombre:
                    data['respondeAlNombre'] as bool?,
              );

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorPrimary.withAlpha(30),
                    child: Icon(Icons.person, color: colorPrimary),
                  ),
                  title: Text(
                    profile.nombre ?? 'Sin nombre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text('Nivel: ${profile.nivelHabla ?? '—'}'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ExercisesSelectionScreen(profile: profile),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorPrimary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StepNameScreen(profile: UserProfile()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}