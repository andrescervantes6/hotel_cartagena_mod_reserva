// Registra el ingreso de huéspedes a una habitación.
class CheckIn {
  final int numeroHabitacion;
  final int personas;
  final DateTime fecha;

  CheckIn({
    required this.numeroHabitacion,
    required this.personas,
    DateTime? fecha,
  }) : fecha = fecha ?? DateTime.now();
}
