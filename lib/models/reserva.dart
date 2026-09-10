import 'huesped.dart';

// Representa una reserva hecha sobre una habitación.
// "activa" indica si la reserva sigue vigente o ya se cerró (ver check_out).
class Reserva {
  final Huesped huesped;
  final int numeroHabitacion;
  final int dias;
  bool activa;

  Reserva({
    required this.huesped,
    required this.numeroHabitacion,
    required this.dias,
    this.activa = true,
  });
}
