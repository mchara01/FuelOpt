class Station {
  final int id;
  final String title;

  Station({required this.id, required this.title});

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      title: json['title'],
    );
  }
}
