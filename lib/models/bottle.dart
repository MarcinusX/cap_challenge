class Bottle {
  final BottleName bottleName;
  final Capacity capacity;
  final int points;

  Bottle(this.bottleName, this.capacity, this.points);
}

enum BottleName {
  COCA_COLA,
  SPRITE,
  FANTA,
  COCA_COLA_ZERO,
  COCA_COLA_LIGHT,
}

String bottleNameToString(BottleName name) {
  switch (name) {
    case BottleName.COCA_COLA:
      return "Coca-Cola";
    case BottleName.SPRITE:
      return "Sprite";
    case BottleName.FANTA:
      return "Fanta";
    case BottleName.COCA_COLA_ZERO:
      return "Coca-Cola Zero";
    case BottleName.COCA_COLA_LIGHT:
      return "Coca-Cola Light";
    default:
      return "Nieznane";
  }
}



enum Capacity {
  CAN_300,
  PLASTIC_250,
  PLASTIC_500,
  PLASTIC_1L,
  PLASTIC_2L,
}
