class BusStop {
  final String stopId;
  final String stopName;
  final double latitude;
  final double longitude;
  final List<String> routeIds;

  BusStop({
    required this.stopId,
    required this.stopName,
    required this.latitude,
    required this.longitude,
    required this.routeIds,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      stopId: json['stopId'],
      stopName: json['stopName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      routeIds: List<String>.from(json['routes']),
    );
  }
}
