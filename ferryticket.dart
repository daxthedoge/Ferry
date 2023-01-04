import 'dart:convert';

//CREATE TABLE ferryticket(book_id INTEGER PRIMARY KEY, depart_date DATE, journey TEXT, depart_route TEXT, dest_route TEXT, id INTEGER, FOREIGN KEY (id) REFERENCES login(id))
class FerryTicket {
  final int? book_id;
  final DateTime depart_date;
  final String journey;
  final String depart_route;
  final String dest_route;

  FerryTicket({
    this.book_id,
    required this.depart_date,
    required this.journey,
    required this.depart_route,
    required this.dest_route,
  });

  Map<String, dynamic> toMap() {
    return {
      'book_id': book_id,
      'depart_date': depart_date.toIso8601String(),
      'journey': journey,
      'depart_route': depart_route,
      'dest_route': dest_route,
    };
  }

  factory FerryTicket.fromMap(Map<String, dynamic> map) {
    return FerryTicket(
      book_id: map['book_id']?.toInt() ?? 0,
      depart_date: DateTime.parse(map['depart_date']),
      journey: map['journey'] ?? '',
      depart_route: map['depart_route'] ?? '',
      dest_route: map['dest_route'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());
  factory FerryTicket.fromJson(String source) =>
      FerryTicket.fromMap(json.decode(source));

  @override
  String toString() =>
      'FerryTicket(book_id: $book_id, depart_date: $depart_date, journey: $journey, depart_route: $depart_route, dest_route: $dest_route)';
}
