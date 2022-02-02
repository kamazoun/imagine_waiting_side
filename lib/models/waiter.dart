class Waiter {
  final String id;
  final String name;
  final DateTime since;
  final bool gender; // false = female

  Waiter(
      {required this.id,
      required this.name,
      required this.since,
      required this.gender});

  Waiter.fromJson(String id, Map<String, dynamic> json)
      : this(
          id: id,
          name: json['name'] as String,
          since: DateTime.fromMillisecondsSinceEpoch(json['since'] as int),
          gender: json['gender'] as bool,
        );

  Map<String, Object> toJson() {
    return {
      'name': name,
      'since': since.millisecondsSinceEpoch,
      'gender': gender,
    };
  }

  Waiter copyWith({id, name, since, gender}) {
    return Waiter(
        id: id ?? this.id,
        name: name ?? this.name,
        since: since ?? this.since,
        gender: gender ?? this.gender);
  }
}
