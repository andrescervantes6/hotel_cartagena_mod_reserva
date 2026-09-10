import '../enums/tipo_habitacion.dart';
import '../enums/estado_habitacion.dart';

// Representa una habitación del hotel.
// Toda habitación nueva inicia en estado "disponible" (regla de negocio).
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

  @override
  String toString() {
    return 'Habitación $numero (${tipo.name}, capacidad: $capacidad) - ${estado.name}';
  }
}
