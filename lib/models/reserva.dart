import 'huesped.dart';

class Reserva {
  final int numeroHabitacion;
  final Huesped huesped;
  final int dias;

  Reserva({
    required this.numeroHabitacion,
    required this.huesped,
    required this.dias,
  });
}