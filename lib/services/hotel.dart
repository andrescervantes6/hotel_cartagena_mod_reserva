import '../models/habitacion.dart';
import '../models/huesped.dart';
import '../models/recepcionista.dart';
import '../models/reserva.dart';
import '../models/check_in.dart';
import '../models/check_out.dart';
import '../enums/tipo_habitacion.dart';
import '../enums/estado_habitacion.dart';

// Clase principal del sistema: guarda toda la información del hotel
// y contiene las reglas de negocio (reservas, check-in, check-out, etc).
// La interfaz de consola (SistemaHotel) solo llama a estos métodos,
// no valida nada por su cuenta.
class Hotel {
  List<Habitacion> habitaciones = [];
  List<Recepcionista> recepcionistas = [];
  List<Reserva> reservas = [];
  List<CheckIn> checkIns = [];
  List<CheckOut> checkOuts = [];

  Hotel() {
    crearHabitacionesIniciales();
  }

  // Carga inicial de habitaciones del hotel. En una versión real esto
  // vendría de una base de datos o de un archivo de configuración.
  void crearHabitacionesIniciales() {
    habitaciones.add(Habitacion(numero: 101, tipo: TipoHabitacion.sencilla, capacidad: 1));
    habitaciones.add(Habitacion(numero: 102, tipo: TipoHabitacion.sencilla, capacidad: 1));
    habitaciones.add(Habitacion(numero: 201, tipo: TipoHabitacion.doble, capacidad: 2));
    habitaciones.add(Habitacion(numero: 202, tipo: TipoHabitacion.doble, capacidad: 2));
    habitaciones.add(Habitacion(numero: 301, tipo: TipoHabitacion.suite, capacidad: 4));
  }

  // ---------- RF01 y RF02: Recepcionistas ----------

  // Devuelve true si el registro fue exitoso, false si el usuario ya existe.
  bool registrarRecepcionista(String usuario, String contrasena) {
    for (var r in recepcionistas) {
      if (r.usuario == usuario) {
        return false;
      }
    }
    recepcionistas.add(Recepcionista(usuario: usuario, contrasena: contrasena));
    return true;
  }

  bool iniciarSesion(String usuario, String contrasena) {
    for (var r in recepcionistas) {
      if (r.usuario == usuario && r.contrasena == contrasena) {
        return true;
      }
    }
    return false;
  }

  // ---------- Buscar y consultar habitaciones (RF03) ----------

  // Busca una habitación por número. Devuelve null si no existe.
  Habitacion? buscarHabitacion(int numero) {
    for (var h in habitaciones) {
      if (h.numero == numero) {
        return h;
      }
    }
    return null;
  }

  List<Habitacion> consultarDisponibles() {
    List<Habitacion> disponibles = [];
    for (var h in habitaciones) {
      if (h.estado == EstadoHabitacion.disponible) {
        disponibles.add(h);
      }
    }
    return disponibles;
  }

  // ---------- RF04 y RF05: Reservar habitación ----------

  // Devuelve un mensaje indicando el resultado de la operación.
  // Se usa String en vez de bool para poder explicar el motivo del rechazo.
  String reservarHabitacion(Huesped huesped, int numeroHabitacion, int dias) {
    Habitacion? habitacion = buscarHabitacion(numeroHabitacion);

    if (habitacion == null) {
      return 'La habitación no existe.';
    }
    if (habitacion.estado != EstadoHabitacion.disponible) {
      return 'La habitación no está disponible.';
    }
    if (dias <= 0) {
      return 'Los días deben ser mayores que cero.';
    }

    habitacion.estado = EstadoHabitacion.reservada;
    Reserva nuevaReserva = Reserva(
      huesped: huesped,
      numeroHabitacion: numeroHabitacion,
      dias: dias,
    );
    reservas.add(nuevaReserva);

    return 'Reserva creada con éxito.';
  }

  // ---------- RF06: Check-in ----------

  String hacerCheckIn(int numeroHabitacion, int personas) {
    Habitacion? habitacion = buscarHabitacion(numeroHabitacion);

    if (habitacion == null) {
      return 'La habitación no existe.';
    }

    // Buscamos si existe una reserva activa para esta habitación.
    bool tieneReservaActiva = false;
    for (var r in reservas) {
      if (r.numeroHabitacion == numeroHabitacion && r.activa) {
        tieneReservaActiva = true;
      }
    }

    if (!tieneReservaActiva) {
      return 'No existe una reserva activa para esta habitación.';
    }
    if (habitacion.estado != EstadoHabitacion.reservada) {
      return 'La habitación no está reservada.';
    }
    if (personas <= 0) {
      return 'El número de personas debe ser mayor que cero.';
    }
    if (personas > habitacion.capacidad) {
      return 'El número de personas supera la capacidad.';
    }

    habitacion.estado = EstadoHabitacion.ocupada;
    checkIns.add(CheckIn(numeroHabitacion: numeroHabitacion, personas: personas));

    return 'Check-in realizado con éxito.';
  }

  // ---------- RF07: Check-out ----------

  String hacerCheckOut(int numeroHabitacion) {
    Habitacion? habitacion = buscarHabitacion(numeroHabitacion);

    if (habitacion == null) {
      return 'La habitación no existe.';
    }
    if (habitacion.estado != EstadoHabitacion.ocupada) {
      return 'La habitación no está ocupada.';
    }

    habitacion.estado = EstadoHabitacion.disponible;
    checkOuts.add(CheckOut(numeroHabitacion: numeroHabitacion));

    // Decisión de diseño: la reserva no se elimina, se marca como inactiva
    // para conservarla como historial (ver README, sección de decisiones).
    for (var r in reservas) {
      if (r.numeroHabitacion == numeroHabitacion && r.activa) {
        r.activa = false;
        break;
      }
    }

    return 'Check-out realizado con éxito.';
  }
}
