import 'package:flutter/material.dart';

import '../../services/offer_service.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({
    super.key,
  });

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  bool loading = true;
  String? errorMessage;

  List<dynamic> offers = [];

  @override
  void initState() {
    super.initState();
    loadOffers();
  }

  // ============================================================
  // LOAD OFFERS
  // ============================================================

  Future<void> loadOffers() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final data = await OfferService.getIncomingOffers();

      if (!mounted) return;

      setState(() {
        offers = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // UPDATE STATUS
  // ============================================================

  Future<void> updateStatus(
    String offerId,
    String status,
  ) async {
    try {
      setState(() {
        loading = true;
      });

      await OfferService.updateOfferStatus(
        offerId,
        status,
      );

      await loadOffers();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == "accepted"
                ? "Offer accepted successfully"
                : "Offer rejected successfully",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unable to update offer: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // SAFE VALUE HELPERS
  // ============================================================

  String value(
    Map<String, dynamic> offer,
    String key, {
    String fallback = "—",
  }) {
    final data = offer[key];

    if (data == null) {
      return fallback;
    }

    final text = data.toString().trim();

    if (text.isEmpty) {
      return fallback;
    }

    return text;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Crop Offers",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadOffers,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (loading && offers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null && offers.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 120),
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 16),
          const Text(
            "Unable to load offers",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: loadOffers,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
          ),
        ],
      );
    }

    if (offers.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 180),
          Icon(
            Icons.local_offer_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              "No offers received",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              "Buyer offers for your crop lots will appear here.",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: offers.length,
          itemBuilder: (context, index) {
            final rawOffer = offers[index];

            if (rawOffer is! Map) {
              return const SizedBox.shrink();
            }

            final offer = Map<String, dynamic>.from(
              rawOffer,
            );

            return _buildOfferCard(offer);
          },
        ),

        if (loading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }

  // ============================================================
  // OFFER CARD
  // ============================================================

  Widget _buildOfferCard(
    Map<String, dynamic> offer,
  ) {
    final offerId = value(
      offer,
      "id",
    );

    final companyName = value(
      offer,
      "company_name",
      fallback: "Buyer",
    );

    final cropName = value(
      offer,
      "crop_name",
      fallback: "Crop",
    );

    final quantity = value(
      offer,
      "quantity",
    );

    final offeredPrice = value(
      offer,
      "offered_price",
    );

    final message = value(
      offer,
      "message",
      fallback: "",
    );

    final status = value(
      offer,
      "status",
      fallback: "pending",
    ).toLowerCase();

    final isPending =
        status == "pending" ||
        status == "created";

    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ====================================================
            // BUYER
            // ====================================================

            Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Offer ID: $offerId",
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _statusChip(status),
              ],
            ),

            const SizedBox(height: 18),

            // ====================================================
            // CROP
            // ====================================================

            _detailRow(
              Icons.grass,
              "Crop",
              cropName,
            ),

            // ====================================================
            // QUANTITY
            // ====================================================

            _detailRow(
              Icons.inventory_2_outlined,
              "Quantity",
              "$quantity kg",
            ),

            // ====================================================
            // PRICE
            // ====================================================

            _detailRow(
              Icons.currency_rupee,
              "Offered Price",
              "₹$offeredPrice",
            ),

            // ====================================================
            // MESSAGE
            // ====================================================

            if (message.isNotEmpty &&
                message != "—") ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color:
                        Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ),
            ],

            // ====================================================
            // ACTIONS
            // ====================================================

            if (isPending) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        updateStatus(
                          offerId,
                          "accepted",
                        );
                      },
                      icon: const Icon(
                        Icons.check,
                      ),
                      label: const Text(
                        "Accept",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child:
                        OutlinedButton.icon(
                      onPressed: () {
                        updateStatus(
                          offerId,
                          "rejected",
                        );
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                      label: const Text(
                        "Reject",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STATUS CHIP
  // ============================================================

  Widget _statusChip(
    String status,
  ) {
    String label;

    switch (status) {
      case "accepted":
        label = "Accepted";
        break;

      case "rejected":
        label = "Rejected";
        break;

      case "pending":
        label = "Pending";
        break;

      default:
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF2E7D32),
          ),
          const SizedBox(width: 10),
          Text(
            "$title:",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}