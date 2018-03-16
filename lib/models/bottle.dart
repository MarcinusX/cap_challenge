class Bottle {
  final BottleName bottleName;
  final Capacity capacity;
  final int points;

  Bottle(this.bottleName, this.capacity, this.points);
}

enum BottleName { COCA_COLA, SPRITE, FANTA, COCA_COLA_ZERO, COCA_COLA_LIGHT }

enum Capacity {
  CAN_300,
  PLASTIC_250,
  PLASTIC_500,
  PLASTIC_1L,
  PLASTIC_2L,
}
