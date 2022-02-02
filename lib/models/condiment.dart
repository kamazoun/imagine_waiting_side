class Condiment {
  final String id;
  final String name;
  final double cost;
  final int stock;
  final String unit;

  Condiment(
      {required this.id,
      required this.name,
      required this.cost,
      required this.stock,
      required this.unit});

  Condiment.fromJson(String id, Map<String, Object> json)
      : this(
            id: id,
            name: json['name'] as String,
            cost: json['cost'] as double,
            stock: json['stock'] as int,
            unit: json['unit'] as String);

  Map<String, Object> toJson() {
    return {
      //'id': id,
      'name': name,
      'cost': cost,
      'stock': stock,
      'unit': unit,
    };
  }

  Condiment copyWith({id, name, category, cost, time, stock}) {
    return Condiment(
        id: id ?? this.id,
        name: name ?? this.name,
        cost: cost ?? this.cost,
        stock: stock ?? this.stock,
        unit: unit // ?? this.unit,
        );
  }
}
