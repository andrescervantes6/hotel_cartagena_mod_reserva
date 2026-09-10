import '../models/habitacion.dart';
import '../models/reserva.dart';
import '../models/huesped.dart';
import '../enums/estado_habitacion.dart';
import '../enums/tipo_habitacion.dart';

class Hotel {
  List<Habitacion> habitaciones = [];
  List<Reserva> reservas = [];

  Hotel() {
    crearHabitacionesIniciales();
  }

  void crearHabitacionesIniciales() {
    habitaciones.add(Habitacion(numero: 1, tipo: TipoHabitacion.sencilla, capacidad: 1));
    habitaciones.add(Habitacion(numero: 2, tipo: TipoHabitacion.doble, capacidad: 2));
    habitaciones.add(Habitacion(numero: 3, tipo: TipoHabitacion.suite, capacidad: 4));
  }

  // 🔍 Buscar habitación
  Habitacion? buscarHabitacion(int numero) {
    try {
      return habitaciones.firstWhere((h) => h.numero == numero);
    } catch (e) {
      return null;
    }
  }

  // 📌 Reservar habitación
  String reservar(int numero, String nombre, String documento, int dias) {
    final habitacion = buscarHabitacion(numero);

    if (habitacion == null) {
      return "Habitación no existe";
    }

    if (!habitacion.estaDisponible()) {
      return "Habitación no disponible";
    }

    if (dias <= 0) {
      return "Días inválidos";
    }

    final huesped = Huesped(nombre: nombre, documento: documento);
    final reserva = Reserva(
      numeroHabitacion: numero,
      huesped: huesped,
      dias: dias,
    );

    reservas.add(reserva);
    habitacion.estado = EstadoHabitacion.reservada;

    return "Reserva exitosa";
  }

  // 🏨 Check-in
  String checkIn(int numero, int personas) {
    final habitacion = buscarHabitacion(numero);

    if (habitacion == null) {
      return "Habitación no existe";
    }

    if (habitacion.estado != EstadoHabitacion.reservada) {
      return "No hay reserva válida";
    }

    if (personas <= 0 || personas > habitacion.capacidad) {
      return "Cantidad de personas inválida";
    }

    habitacion.estado = EstadoHabitacion.ocupada;
    return "Check-in realizado";
  }

  // 🚪 Check-out
  String checkOut(int numero) {
    final habitacion = buscarHabitacion(numero);

    if (habitacion == null) {
      return "Habitación no existe";
    }

    if (habitacion.estado != EstadoHabitacion.ocupada) {
      return "La habitación no está ocupada";
    }

    habitacion.estado = EstadoHabitacion.disponible;
    return "Check-out realizado";
  }

  // 📊 Ver disponibles
  void mostrarDisponibles() {
    for (var h in habitaciones) {
      if (h.estado == EstadoHabitacion.disponible) {
        print("Habitación ${h.numero} - ${h.tipo}");
      }
    }
  }
}