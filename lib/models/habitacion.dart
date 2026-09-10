import '../enums/estado_habitacion.dart';
import '../enums/tipo_habitacion.dart';

class Habitacion {
  final int numero;
  final TipoHabitacion tipo;
  final int capacidad;
  EstadoHabitacion estado;

  Habitacion({
    required this.numero,
    required this.tipo,
    required this.capacidad,
    this.estado = EstadoHabitacion.disponible,
  });

  bool estaDisponible() {
    return estado == EstadoHabitacion.disponible;
  }
}