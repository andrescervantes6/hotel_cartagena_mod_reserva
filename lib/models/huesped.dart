// Representa a la persona que se hospeda en el hotel.
class Huesped {
  final String nombre;
  final String cedula;

  Huesped({
    required this.nombre,
    required this.cedula,
  });

  @override
  String toString() => '$nombre (CC: $cedula)';
}
