import 'dart:io';
import 'services/hotel.dart';

class SistemaHotel {
  final Hotel hotel = Hotel();

  void iniciar() {
    while (true) {
      print("\n--- HOTEL CARTAGENA ---");
      print("1. Ver habitaciones");
      print("2. Reservar");
      print("3. Check-in");
      print("4. Check-out");
      print("5. Salir");

      stdout.write("Seleccione: ");
      String? opcion = stdin.readLineSync();

      switch (opcion) {
        case '1':
          hotel.mostrarDisponibles();
          break;

        case '2':
          stdout.write("Número habitación: ");
          int num = int.parse(stdin.readLineSync()!);

          stdout.write("Nombre: ");
          String nombre = stdin.readLineSync()!;

          stdout.write("Documento: ");
          String doc = stdin.readLineSync()!;

          stdout.write("Días: ");
          int dias = int.parse(stdin.readLineSync()!);

          print(hotel.reservar(num, nombre, doc, dias));
          break;

        case '3':
          stdout.write("Número habitación: ");
          int num = int.parse(stdin.readLineSync()!);

          stdout.write("Personas: ");
          int p = int.parse(stdin.readLineSync()!);

          print(hotel.checkIn(num, p));
          break;

        case '4':
          stdout.write("Número habitación: ");
          int num = int.parse(stdin.readLineSync()!);

          print(hotel.checkOut(num));
          break;

        case '5':
          return;

        default:
          print("Opción inválida");
      }
    }
  }
}