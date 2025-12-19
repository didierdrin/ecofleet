class Bus {
  final String busId;
  final String routeId;
  final double latitude;
  final double longitude;
  final double speed;
  final int capacity;
  final int occupancy;
  final String nextStopId;
  final int etaMinutes;

  Bus({
    required this.busId,
    required this.routeId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.capacity,
    required this.occupancy,
    required this.nextStopId,
    required this.etaMinutes,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busId: json['busId'],
      routeId: json['routeId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      speed: json['speed'].toDouble(),
      capacity: json['capacity'],
      occupancy: json['occupancy'],
      nextStopId: json['nextStop'],
      etaMinutes: json['eta'],
    );
  }
  
  Bus copyWith({
    String? busId,
    String? routeId,
    double? latitude,
    double? longitude,
    double? speed,
    int? capacity,
    int? occupancy,
    String? nextStopId,
    int? etaMinutes,
  }) {
    return Bus(
      busId: busId ?? this.busId,
      routeId: routeId ?? this.routeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      capacity: capacity ?? this.capacity,
      occupancy: occupancy ?? this.occupancy,
      nextStopId: nextStopId ?? this.nextStopId,
      etaMinutes: etaMinutes ?? this.etaMinutes,
    );
  }
}
