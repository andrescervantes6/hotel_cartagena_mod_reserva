// Registra la salida (liberación) de una habitación.
class CheckOut {
  final int numeroHabitacion;
  final DateTime fecha;

  CheckOut({
    required this.numeroHabitacion,
    DateTime? fecha,
  }) : fecha = fecha ?? DateTime.now();
}
