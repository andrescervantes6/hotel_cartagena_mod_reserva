# Hotel_cartagenena_mod_reservas

## Objetivo
Sistema de consola en Dart para que los recepcionistas del Hotel Cartagena
puedan registrar usuarios, iniciar sesión, consultar habitaciones
disponibles, reservar habitaciones, hacer check-in y hacer check-out,
usando un código modular y organizado en archivos independientes.

## Descripción breve del funcionamiento
Al iniciar, el programa muestra un menú donde se puede registrar un
recepcionista o iniciar sesión. Una vez dentro, el recepcionista accede a
un segundo menú desde el cual puede consultar habitaciones disponibles,
crear reservas, y gestionar el check-in y check-out de los huéspedes.
Toda la lógica de negocio (validaciones y cambios de estado) vive en la
clase `Hotel`; la consola (`SistemaHotel`) solo se encarga de mostrar
menús y leer datos.

## Estructura de carpetas
```
Hotel_cartagenena_mod_reservas/
├── bin/
│   └── main.dart              # Punto de entrada, solo inicia la app
├── lib/
│   ├── models/                # Clases de dominio
│   │   ├── habitacion.dart
│   │   ├── huesped.dart
│   │   ├── recepcionista.dart
│   │   ├── reserva.dart
│   │   ├── check_in.dart
│   │   └── check_out.dart
│   ├── enums/
│   │   ├── tipo_habitacion.dart
│   │   └── estado_habitacion.dart
│   ├── services/
│   │   └── hotel.dart         # Lógica de negocio y reglas de reservas
│   └── sistema_hotel.dart     # Menús de consola
├── test/
│   └── hotel_test.dart
├── pubspec.yaml
└── README.md
```

## Cómo instalar y ejecutar el proyecto
1. Tener instalado el SDK de Dart (https://dart.dev/get-dart).
2. Ubicarse en la carpeta del proyecto y traer las dependencias:
   ```
   dart pub get
   ```
3. Ejecutar el programa:
   ```
   dart run bin/main.dart
   ```
4. Ejecutar las pruebas:
   ```
   dart test
   ```

## Reglas de negocio implementadas
- Una habitación nueva siempre inicia en estado `disponible`.
- Una habitación solo puede reservarse si está `disponible`; al reservarse
  pasa a `reservada`.
- El check-in solo se permite si existe una reserva activa y la
  habitación está en estado `reservada`; al confirmarse pasa a `ocupada`.
- El número de personas del check-in debe ser mayor que cero y no puede
  superar la capacidad de la habitación.
- El check-out solo se permite sobre habitaciones `ocupadas`; al
  confirmarse la habitación vuelve a `disponible`.
- **Decisión sobre el cierre de la reserva:** en vez de eliminar la
  reserva al hacer check-out, se marca con `activa = false`. Así queda
  como historial dentro de la lista de reservas del hotel, en lugar de
  perderse la información de quién se hospedó y por cuántos días.
- Las entradas de texto vacías y los números inválidos se vuelven a
  solicitar hasta que el usuario ingrese un dato correcto.

## Casos de prueba realizados
Los casos T01 a T11 de la guía están cubiertos en `test/hotel_test.dart`
(registro de usuarios, login, reservas válidas e inválidas, check-in con
y sin exceso de capacidad, check-out válido e inválido). El caso T12
(entrada vacía) se valida directamente en la interfaz de consola
(`_leerTextoNoVacio`), ya que depende de la entrada por teclado y no de
la lógica de `Hotel`.

## Integrantes y responsabilidad de cada uno
| Integrante | Responsabilidad |
|---|---|
| Integrante 1 | Modelos y enumeraciones (dominio) |
| Integrante 2-3 | Lógica de negocio: clase `Hotel`, reservas, check-in, check-out |
| Integrante 4 | Interfaz de consola: menús y captura de datos |
| Integrante 5 | Pruebas, validaciones y revisión de código |

## Dificultades encontradas y cómo fueron solucionadas
- **Decidir qué pasa con la reserva al hacer check-out:** se optó por no
  borrarla, sino marcarla como inactiva, para no perder el historial de
  reservas del hotel.
- **Validar entradas de consola:** se crearon métodos auxiliares
  (`_leerTextoNoVacio`, `_leerEntero`) que repiten la pregunta hasta
  recibir un dato válido, evitando duplicar esa lógica en cada opción
  del menú.
