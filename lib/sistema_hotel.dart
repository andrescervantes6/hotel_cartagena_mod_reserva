import 'dart:io';

import 'services/hotel.dart';
import 'models/habitacion.dart';
import 'models/huesped.dart';
import 'enums/tipo_habitacion.dart';

// Se encarga únicamente de mostrar menús, leer datos del usuario
// y llamar a los métodos de Hotel. No contiene reglas de negocio.
class SistemaHotel {
  final Hotel hotel = Hotel();

  void iniciar() {
    print('=== Sistema de Reservas - Hotel Cartagena ===');

    bool salir = false;
    while (!salir) {
      print('');
      print('1. Registrar recepcionista');
      print('2. Iniciar sesión');
      print('3. Salir');
      stdout.write('Seleccione una opción: ');

      String opcion = leerOpcion();

      switch (opcion) {
        case '1':
          registrarRecepcionista();
          break;
        case '2':
          iniciarSesionYMenu();
          break;
        case '3':
          salir = true;
          print('Gracias por usar el sistema.');
          break;
        default:
          print('Opción inválida.');
      }
    }
  }

  // ---------- Menú del recepcionista ----------

  void menuRecepcionista() {
    bool volver = false;
    while (!volver) {
      print('');
      print('--- Menú Recepcionista ---');
      print('1. Consultar habitaciones disponibles');
      print('2. Reservar habitación');
      print('3. Check-in');
      print('4. Check-out');
      print('5. Cerrar sesión');
      stdout.write('Seleccione una opción: ');

      String opcion = leerOpcion();

      switch (opcion) {
        case '1':
          consultarDisponibles();
          break;
        case '2':
          reservarHabitacion();
          break;
        case '3':
          checkIn();
          break;
        case '4':
          checkOut();
          break;
        case '5':
          volver = true;
          print('Sesión cerrada.');
          break;
        default:
          print('Opción inválida.');
      }
    }
  }

  // ---------- Acciones ----------

  void registrarRecepcionista() {
    String usuario = leerTextoNoVacio('Usuario: ');
    String contrasena = leerTextoNoVacio('Contraseña: ');

    bool exito = hotel.registrarRecepcionista(usuario, contrasena);

    if (exito) {
      print('Recepcionista registrado con éxito.');
    } else {
      print('Ese usuario ya existe.');
    }
  }

  void iniciarSesionYMenu() {
    String usuario = leerTextoNoVacio('Usuario: ');
    String contrasena = leerTextoNoVacio('Contraseña: ');

    bool acceso = hotel.iniciarSesion(usuario, contrasena);

    if (!acceso) {
      print('Usuario o contraseña incorrectos.');
      return;
    }

    print('Bienvenido, $usuario.');
    menuRecepcionista();
  }

  void consultarDisponibles() {
    List<Habitacion> disponibles = hotel.consultarDisponibles();

    if (disponibles.isEmpty) {
      print('No hay habitaciones disponibles en este momento.');
      return;
    }

    // Se agrupan por tipo para cumplir el RF03: recorremos cada tipo
    // y luego revisamos qué habitaciones disponibles son de ese tipo.
    print('Habitaciones disponibles:');
    for (var tipo in TipoHabitacion.values) {
      String numeros = '';
      for (var h in disponibles) {
        if (h.tipo == tipo) {
          numeros = '$numeros${h.numero} ';
        }
      }
      if (numeros.isNotEmpty) {
        print('  ${tipo.name}: $numeros');
      }
    }
  }

  void reservarHabitacion() {
    String nombre = leerTextoNoVacio('Nombre del huésped: ');
    String cedula = leerTextoNoVacio('Cédula del huésped: ');
    int numero = leerEntero('Número de habitación: ');
    int dias = leerEntero('Cantidad de días: ');

    Huesped huesped = Huesped(nombre: nombre, cedula: cedula);
    String resultado = hotel.reservarHabitacion(huesped, numero, dias);
    print(resultado);
  }

  void checkIn() {
    int numero = leerEntero('Número de habitación: ');
    int personas = leerEntero('Cantidad de personas: ');

    String resultado = hotel.hacerCheckIn(numero, personas);
    print(resultado);
  }

  void checkOut() {
    int numero = leerEntero('Número de habitación: ');

    String resultado = hotel.hacerCheckOut(numero);
    print(resultado);
  }

  // ---------- Utilidades de lectura (validan entradas del usuario) ----------

  String leerOpcion() {
    String? texto = stdin.readLineSync();
    if (texto == null) {
      return '';
    }
    return texto.trim();
  }

  // Pide un texto y no deja continuar hasta que no esté vacío (caso T12).
  String leerTextoNoVacio(String mensaje) {
    while (true) {
      stdout.write(mensaje);
      String? texto = stdin.readLineSync();
      String valor = (texto ?? '').trim();

      if (valor.isNotEmpty) {
        return valor;
      }
      print('El dato no puede quedar vacío, intente de nuevo.');
    }
  }

  // Pide un número entero y repite hasta que la entrada sea válida.
  int leerEntero(String mensaje) {
    while (true) {
      stdout.write(mensaje);
      String? texto = stdin.readLineSync();
      int? valor = int.tryParse((texto ?? '').trim());

      if (valor != null) {
        return valor;
      }
      print('Ingrese un número válido.');
    }
  }
}