import 'package:test/test.dart';

import 'package:hotel_cartagenena_mod_reservas/services/hotel.dart';
import 'package:hotel_cartagenena_mod_reservas/models/huesped.dart';
import 'package:hotel_cartagenena_mod_reservas/enums/estado_habitacion.dart';

void main() {
  group('Recepcionistas (RF01, RF02)', () {
    test('T01 - Registrar usuario nuevo', () {
      final hotel = Hotel();
      expect(hotel.registrarRecepcionista('ana', '1234'), true);
    });

    test('T02 - Registrar usuario duplicado', () {
      final hotel = Hotel();
      hotel.registrarRecepcionista('ana', '1234');
      expect(hotel.registrarRecepcionista('ana', '5678'), false);
    });

    test('T03 - Login correcto', () {
      final hotel = Hotel();
      hotel.registrarRecepcionista('ana', '1234');
      expect(hotel.iniciarSesion('ana', '1234'), true);
    });

    test('T04 - Login incorrecto', () {
      final hotel = Hotel();
      hotel.registrarRecepcionista('ana', '1234');
      expect(hotel.iniciarSesion('ana', 'clave_mala'), false);
    });
  });

  group('Reservas (RF04, RF05)', () {
    test('T05 - Reserva correcta', () {
      final hotel = Hotel();
      final huesped = Huesped(nombre: 'Carlos', cedula: '123');

      final resultado = hotel.reservarHabitacion(huesped, 101, 2);
      final habitacion = hotel.buscarHabitacion(101);

      expect(resultado, 'Reserva creada con éxito.');
      expect(habitacion!.estado, EstadoHabitacion.reservada);
    });

    test('T06 - Reserva sobre habitación inexistente', () {
      final hotel = Hotel();
      final huesped = Huesped(nombre: 'Carlos', cedula: '123');

      final resultado = hotel.reservarHabitacion(huesped, 999, 2);
      expect(resultado, 'La habitación no existe.');
    });

    test('T07 - Reserva sobre habitación no disponible', () {
      final hotel = Hotel();
      final huesped = Huesped(nombre: 'Carlos', cedula: '123');
      hotel.reservarHabitacion(huesped, 101, 2);

      final resultado = hotel.reservarHabitacion(huesped, 101, 1);
      expect(resultado, 'La habitación no está disponible.');
    });
  });

  group('Check-in (RF06)', () {
    test('T08 - Check-in correcto', () {
      final hotel = Hotel();
      final huesped = Huesped(nombre: 'Carlos', cedula: '123');
      hotel.reservarHabitacion(huesped, 201, 2);

      final resultado = hotel.hacerCheckIn(201, 2);
      final habitacion = hotel.buscarHabitacion(201);

      expect(resultado, 'Check-in realizado con éxito.');
      expect(habitacion!.estado, EstadoHabitacion.ocupada);
    });

    test('T09 - Check-in que excede la capacidad', () {
      final hotel = Hotel();
      final huesped = Huesped(nombre: 'Carlos', cedula: '123');
      hotel.reservarHabitacion(huesped, 101, 2); // capacidad 1

      final resultado = hotel.hacerCheckIn(101, 5);
      expect(resultado, 'El número de personas supera la capacidad.');
    });
  });

  group('Check-out (RF07)', () {
    test('T10 - Check-out correcto', () {
      final hotel = Hotel();
      final huesped = Huesped(nombre: 'Carlos', cedula: '123');
      hotel.reservarHabitacion(huesped, 301, 2);
      hotel.hacerCheckIn(301, 3);

      final resultado = hotel.hacerCheckOut(301);
      final habitacion = hotel.buscarHabitacion(301);

      expect(resultado, 'Check-out realizado con éxito.');
      expect(habitacion!.estado, EstadoHabitacion.disponible);
    });

    test('T11 - Check-out sobre habitación no ocupada', () {
      final hotel = Hotel();
      final resultado = hotel.hacerCheckOut(101);
      expect(resultado, 'La habitación no está ocupada.');
    });
  });
}
