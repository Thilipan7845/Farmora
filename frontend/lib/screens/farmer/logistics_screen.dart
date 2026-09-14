import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../services/logistics_service.dart';

class LogisticsScreen extends StatefulWidget {
  final String orderId;

  const LogisticsScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<LogisticsScreen> createState() => _LogisticsScreenState();
}

class _LogisticsScreenState extends State<LogisticsScreen> {
  bool loading = true;

  String? errorMessage;

  Map<String, dynamic>? tracking;

  List<LatLng> routePoints = [];

  bool loadingRoute = false;

  @override
  void initState() {
    super.initState();
    loadTracking();
  }

  Future<void> loadTracking() async {
    try {
      final response = await LogisticsService.getTracking(
        widget.orderId,
      );

      if (!mounted) return;

      setState(() {
        tracking = response;
        loading = false;
        errorMessage = null;
      });

      await _loadRoute();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage = "Unable to load delivery tracking";
      });
    }
  }

  double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '');
  }

  LatLng? _coordinate(
    dynamic latitude,
    dynamic longitude,
  ) {
    final lat = _toDouble(latitude);
    final lon = _toDouble(longitude);

    if (lat == null || lon == null) {
      return null;
    }

    if (lat < -90 || lat > 90 || lon < -180 || lon > 180) {
      return null;
    }

    return LatLng(lat, lon);
  }

  LatLng? get pickupPoint {
    return _coordinate(
      logisticsData["pickup_latitude"],
      logisticsData["pickup_longitude"],
    );
  }

  LatLng? get deliveryPoint {
    return _coordinate(
      logisticsData["delivery_latitude"],
      logisticsData["delivery_longitude"],
    );
  }

  Future<void> _loadRoute() async {
    final pickup = pickupPoint;
    final delivery = deliveryPoint;

    if (pickup == null || delivery == null) {
      return;
    }

    if (mounted) {
      setState(() {
        loadingRoute = true;
      });
    }

    try {
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${pickup.longitude},${pickup.latitude};'
        '${delivery.longitude},${delivery.latitude}'
        '?overview=full&geometries=geojson',
      );

      final response = await http.get(url);
if (response.statusCode < 200 ||
    response.statusCode >= 300) {
  throw Exception('Route request failed');
}
      final data = jsonDecode(response.body);

      final routes = data["routes"];

      if (routes is! List || routes.isEmpty) {
        throw Exception('No route found');
      }

      final geometry = routes.first["geometry"];
      final coordinates = geometry?["coordinates"];

      if (coordinates is! List) {
        throw Exception('Invalid route geometry');
      }

      final points = coordinates
          .whereType<List>()
          .where((point) => point.length >= 2)
          .map(
            (point) => LatLng(
              (point[1] as num).toDouble(),
              (point[0] as num).toDouble(),
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        routePoints = points;
        loadingRoute = false;
      });
    } catch (_) {
      if (!mounted) return;

      // The map still works with the two endpoints if routing fails.
      setState(() {
        routePoints = [pickup, delivery];
        loadingRoute = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Delivery Tracking",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? _buildErrorState()
              : tracking == null
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: loadTracking,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildOrderHeader(),
                          const SizedBox(height: 16),
                          _buildStatusCard(),
                          const SizedBox(height: 16),
                          _buildRouteCard(),
                          const SizedBox(height: 16),
                          _buildMapCard(),
                          const SizedBox(height: 16),
                          _buildTransportCard(),
                          const SizedBox(height: 16),
                          _buildTimeline(),
                        ],
                      ),
                    ),
    );
  }

  Map<String, dynamic> get logisticsData {
    final data = tracking?["tracking"];

    if (data is Map<String, dynamic>) {
      return data;
    }

    return {};
  }

  Widget _buildOrderHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF43A047),
          ],
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.local_shipping,
              color: Color(0xFF2E7D32),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Delivery for Order",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "#${widget.orderId.length > 8 ? widget.orderId.substring(0, 8) : widget.orderId}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final status =
        logisticsData["status"]?.toString() ??
        tracking?["order_status"]?.toString() ??
        "Pending";

    return _sectionCard(
      title: "Delivery Status",
      icon: Icons.track_changes,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatStatus(status),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Latest delivery status",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    final pickup =
        logisticsData["pickup_location"]?.toString() ??
        "Unknown";

    final delivery =
        logisticsData["delivery_location"]?.toString() ??
        "Unknown";

    final distance = logisticsData["distance_km"];

    return _sectionCard(
      title: "Delivery Route",
      icon: Icons.route,
      child: Column(
        children: [
          _locationRow(
           Icons.agriculture_outlined,
            "Pickup",
            pickup,
          ),

          const Padding(
            padding: EdgeInsets.only(
              left: 11,
              top: 5,
              bottom: 5,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 25,
                child: VerticalDivider(
                  width: 1,
                  thickness: 2,
                ),
              ),
            ),
          ),

          _locationRow(
            Icons.location_on_outlined,
            "Delivery",
            delivery,
          ),

          if (distance != null) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 10),
            _infoRow(
              Icons.straighten,
              "Distance",
              "${distance.toString()} km",
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    final pickup = pickupPoint;
    final delivery = deliveryPoint;

    if (pickup == null || delivery == null) {
      return _sectionCard(
        title: "Live Route Map",
        icon: Icons.map_outlined,
        child: const Text(
          "Map coordinates are not available for this delivery.",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    }

    final center = LatLng(
      (pickup.latitude + delivery.latitude) / 2,
      (pickup.longitude + delivery.longitude) / 2,
    );

    final points = routePoints.isNotEmpty
        ? routePoints
        : [pickup, delivery];

    return _sectionCard(
      title: "Delivery Route Map",
      icon: Icons.map_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 300,
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: center,
                      initialZoom: 6.5,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                      onMapReady: () {},
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.farmora.app',
                      ),
                      if (points.length >= 2)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: points,
                              strokeWidth: 5,
                              color: const Color(0xFF2E7D32),
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: pickup,
                            width: 50,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.18,
                                    ),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.agriculture,
                                color: Color(0xFF2E7D32),
                                size: 28,
                              ),
                            ),
                          ),
                          Marker(
                            point: delivery,
                            width: 50,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.18,
                                    ),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  if (loadingRoute)
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.94,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Loading road route...",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.agriculture,
                size: 18,
                color: Color(0xFF2E7D32),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  "Pickup",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.location_on,
                size: 18,
                color: Colors.red,
              ),
              const SizedBox(width: 6),
              const Text(
                "Destination",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Map data © OpenStreetMap contributors",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportCard() {
    final transport =
        logisticsData["transport_type"]?.toString() ??
        "Not available";

    final cost =
        logisticsData["transport_cost"];

    final estimatedDate =
        logisticsData["estimated_delivery_date"]?.toString();

    return _sectionCard(
      title: "Transport Details",
      icon: Icons.local_shipping_outlined,
      child: Column(
        children: [
          _infoRow(
            Icons.directions_car_outlined,
            "Transport",
            transport,
          ),

          const SizedBox(height: 12),

          _infoRow(
            Icons.currency_rupee,
            "Transport Cost",
            cost == null ? "Not available" : "₹$cost",
          ),

          if (estimatedDate != null) ...[
            const SizedBox(height: 12),
            _infoRow(
              Icons.calendar_today_outlined,
              "Estimated Delivery",
              estimatedDate,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final status =
        logisticsData["status"]?.toString().toLowerCase() ??
        "";

    int currentStep = _timelineStep(status);

    return _sectionCard(
      title: "Delivery Progress",
      icon: Icons.timeline,
      child: Column(
        children: [
          _timelineItem(
            title: "Order Confirmed",
            icon: Icons.check_circle_outline,
            completed: currentStep >= 0,
            current: currentStep == 0,
            isLast: false,
          ),
          _timelineItem(
            title: "Pickup",
            icon: Icons.inventory_2_outlined,
            completed: currentStep >= 1,
            current: currentStep == 1,
            isLast: false,
          ),
          _timelineItem(
            title: "In Transit",
            icon: Icons.local_shipping_outlined,
            completed: currentStep >= 2,
            current: currentStep == 2,
            isLast: false,
          ),
          _timelineItem(
            title: "Delivered",
            icon: Icons.home_outlined,
            completed: currentStep >= 3,
            current: currentStep == 3,
            isLast: true,
          ),
        ],
      ),
    );
  }

  int _timelineStep(String status) {
    switch (status) {
      case "confirmed":
      case "pending":
        return 0;

      case "pickup":
      case "picked_up":
      case "pickup_scheduled":
        return 1;

      case "in_transit":
      case "shipped":
        return 2;

      case "delivered":
      case "completed":
        return 3;

      default:
        return 0;
    }
  }

  Widget _timelineItem({
    required String title,
    required IconData icon,
    required bool completed,
    required bool current,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          child: Column(
            children: [
              Icon(
                icon,
                size: 24,
                color: completed
                    ? const Color(0xFF2E7D32)
                    : Colors.grey.shade400,
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 42,
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  color: completed
                      ? const Color(0xFF2E7D32)
                      : Colors.grey.shade300,
                ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: current || completed
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),

                if (current)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Current",
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _locationRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF2E7D32),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF2E7D32),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(
              alpha: 0.12,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF2E7D32),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "No delivery tracking available",
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? "Something went wrong",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadTracking,
              child: const Text(
                "Retry",
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return "Pending";

    return status
        .split("_")
        .map(
          (word) => word.isEmpty
              ? ""
              : word[0].toUpperCase() + word.substring(1),
        )
        .join(" ");
  }
}