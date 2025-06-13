// lib/models/user_profile.dart

class UserProfile {
  String? nombre;
  String? edad;
  String? nivelHabla;
  String? palabrasConocidas;
  bool? comprendeOrden;
  bool? comprendeTiempo;
  bool? puedeDecirNombre;
  bool? sigueInstrucciones;
  bool? comprendeLoQueEscucha;
  bool? respondeAlNombre;

  UserProfile({
    this.nombre,
    this.edad,
    this.nivelHabla,
    this.palabrasConocidas,
    this.comprendeOrden,
    this.comprendeTiempo,
    this.puedeDecirNombre,
    this.sigueInstrucciones,
    this.comprendeLoQueEscucha,
    this.respondeAlNombre,
  });
}