import 'package:flutter/material.dart';

import '../../services/order_service.dart';
import 'logistics_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool loading = true;
  String? errorMessage;

  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final data = await OrderService.getOrders();

      if (!mounted) return;

      setState(() {
        orders = data;
        loading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage = "Unable to load orders";
      });
    }
  }

  String _formatAmount(dynamic value) {
    if (value == null) return "₹0";

    final number = double.tryParse(value.toString());

    if (number == null) {
      return "₹$value";
    }

    return "₹${number.toStringAsFixed(0)}";
  }

  String _formatStatus(dynamic value) {
    if (value == null) return "Pending";

    final status = value.toString();

    if (status.isEmpty) return "Pending";

    return status[0].toUpperCase() + status.substring(1);
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
      case "delivered":
        return const Color(0xFF2E7D32);

      case "cancelled":
        return Colors.red;

      case "shipped":
      case "processing":
        return Colors.orange;

      case "confirmed":
        return Colors.blue;

      default:
        return Colors.grey.shade700;
    }
  }

  bool _canTrackOrder(Map<String, dynamic> order) {
    final status = order["status"]?.toString().toLowerCase();

    return status != "cancelled";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
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
              : orders.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: loadOrders,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final rawOrder = orders[index];

                          if (rawOrder is! Map<String, dynamic>) {
                            return const SizedBox.shrink();
                          }

                          return _buildOrderCard(rawOrder);
                        },
                      ),
                    ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final orderId = order["id"]?.toString() ?? "Unknown";

    final quantity = order["quantity"] ?? 0;

    final agreedPrice = order["agreed_price"];

    final totalAmount = order["total_amount"];

    final status = _formatStatus(order["status"]);

    final statusColor = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(
              alpha: 0.15,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID + Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Order #${orderId.length > 8 ? orderId.substring(0, 8) : orderId}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Quantity
          _infoRow(
            Icons.inventory_2_outlined,
            "Quantity",
            "$quantity kg",
          ),

          const SizedBox(height: 10),

          // Agreed price
          _infoRow(
            Icons.currency_rupee,
            "Agreed Price",
            "${_formatAmount(agreedPrice)} / kg",
          ),

          const SizedBox(height: 10),

          // Total amount
          _infoRow(
            Icons.payments_outlined,
            "Total Amount",
            _formatAmount(totalAmount),
          ),

          const SizedBox(height: 10),

          // Crop lot
          _infoRow(
            Icons.grass_outlined,
            "Crop Lot",
            order["crop_lot_id"]?.toString() ?? "Not available",
          ),

          const SizedBox(height: 18),

          // Track delivery
          if (_canTrackOrder(order))
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LogisticsScreen(
                        orderId: orderId,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.local_shipping_outlined,
                ),
                label: const Text(
                  "Track Delivery",
                ),
              ),
            ),
        ],
      ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 70,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              "No orders found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your confirmed orders will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadOrders,
              child: const Text(
                "Retry",
              ),
            ),
          ],
        ),
      ),
    );
  }
}