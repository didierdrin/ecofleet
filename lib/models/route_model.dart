class BusRoute {
  final String routeId;
  final String routeName;
  final String colorHex;
  final String operatorName;
  final int fare;
  final int activeBuses;

  BusRoute({
    required this.routeId,
    required this.routeName,
    required this.colorHex,
    required this.operatorName,
    required this.fare,
    required this.activeBuses,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      routeId: json['routeId'],
      routeName: json['routeName'],
      colorHex: json['color'],
      operatorName: json['operator'],
      fare: json['fare'],
      activeBuses: json['activeBuses'],
    );
  }
}
