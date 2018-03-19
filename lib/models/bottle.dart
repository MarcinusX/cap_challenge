class Bottle {
  final BottleName bottleName;
  final Capacity capacity;
  final int points;

  Bottle(this.bottleName, this.capacity, this.points);

  @override
  bool operator ==(other) {
    return other != null &&
        other is Bottle &&
        other.bottleName == this.bottleName &&
        other.capacity == this.capacity;
  }

  @override
  String toString() {
    return bottleNameToString(bottleName) + ' - ' + bottleCapacityToString(
        capacity);
  }
}

enum BottleName {
  COCA_COLA,
  SPRITE,
  FANTA,
  COCA_COLA_ZERO,
  COCA_COLA_LIGHT,
}

enum Capacity {
  CAN_300,
  PLASTIC_250,
  PLASTIC_500,
  PLASTIC_1L,
  PLASTIC_2L,
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

String bottleCapacityToString(Capacity capacity) {
  switch (capacity) {
    case Capacity.CAN_300:
      return "puszka 300 ml";
    case Capacity.PLASTIC_1L:
      return "butelka 1 l";
    case Capacity.PLASTIC_2L:
      return "butelka 2 l";
    case Capacity.PLASTIC_250:
      return "butelka 250 ml";
    case Capacity.PLASTIC_500:
      return "butelka 500 ml";
    default:
      return "Nieznane";
  }
}