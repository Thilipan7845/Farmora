import 'package:flutter/material.dart';

import '../../services/buyer_matching_service.dart';
import '../../services/offer_service.dart';

class BuyerMatchingScreen extends StatefulWidget {
  final String cropLotId;
  final String cropName;

  const BuyerMatchingScreen({
    super.key,
    required this.cropLotId,
    this.cropName = '',
  });

  @override
  State<BuyerMatchingScreen> createState() =>
      _BuyerMatchingScreenState();
}

class _BuyerMatchingScreenState
    extends State<BuyerMatchingScreen> {
  bool loading = true;

  List<dynamic> buyers = [];

  String cropName = '';
  double availableQuantity = 0;

  @override
  void initState() {
    super.initState();
    loadBuyers();
  }

  Future<void> loadBuyers() async {
    try {
      final response =
          await BuyerMatchingService.findBuyers(
        widget.cropLotId,
      );

      final matches = response["matches"];

      if (!mounted) return;

      setState(() {
        cropName =
            response["crop_name"] ??
            widget.cropName;

        availableQuantity =
            _toDouble(response["available_quantity"]);

        buyers = matches is List ? matches : [];

        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to find buyers. Please try again.",
          ),
        ),
      );
    }
  }

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  String _formatNumber(dynamic value) {
    final number = _toDouble(value);

    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    }

    return number.toStringAsFixed(2);
  }

  // ============================================================
  // MAKE OFFER
  // ============================================================

  Future<void> _showMakeOfferDialog(
    Map<String, dynamic> buyer,
  ) async {
    final quantityController =
        TextEditingController(
      text: availableQuantity > 0
          ? availableQuantity.toString()
          : '',
    );

    final priceController =
        TextEditingController(
      text: _formatNumber(
        buyer["buyer_max_price"],
      ),
    );

    final messageController =
        TextEditingController();

    final formKey =
        GlobalKey<FormState>();

    bool submitting = false;
    final messenger = ScaffoldMessenger.of(context);

    await showDialog(
      context: context,
      barrierDismissible: !submitting,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            dialogStateContext,
            setDialogState,
          ) {
            return AlertDialog(
              title: const Text(
                "Make an Offer",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        buyer["company_name"]
                                ?.toString() ??
                            "Buyer",
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller:
                            quantityController,
                        keyboardType:
                            const TextInputType
                                .numberWithOptions(
                          decimal: true,
                        ),
                        decoration:
                            const InputDecoration(
                          labelText:
                              "Quantity (kg)",
                          prefixIcon: Icon(
                            Icons
                                .inventory_2_outlined,
                          ),
                        ),
                        validator: (value) {
                          final quantity =
                              double.tryParse(
                            value?.trim() ?? '',
                          );

                          if (quantity == null ||
                              quantity <= 0) {
                            return "Enter a valid quantity";
                          }

                          if (availableQuantity >
                                  0 &&
                              quantity >
                                  availableQuantity) {
                            return "Cannot exceed available quantity";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller:
                            priceController,
                        keyboardType:
                            const TextInputType
                                .numberWithOptions(
                          decimal: true,
                        ),
                        decoration:
                            const InputDecoration(
                          labelText:
                              "Offered Price (₹)",
                          prefixIcon: Icon(
                            Icons.currency_rupee,
                          ),
                        ),
                        validator: (value) {
                          final price =
                              double.tryParse(
                            value?.trim() ?? '',
                          );

                          if (price == null ||
                              price <= 0) {
                            return "Enter a valid price";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller:
                            messageController,
                        maxLines: 3,
                        decoration:
                            const InputDecoration(
                          labelText:
                              "Message (optional)",
                          hintText:
                              "Add a message to the buyer",
                          prefixIcon: Icon(
                            Icons
                                .message_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: submitting
                      ? null
                      : () {
                          Navigator.pop(
                            dialogContext,
                          );
                        },
                  child: const Text(
                    "Cancel",
                  ),
                ),
                ElevatedButton(
                  onPressed: submitting
                      ? null
                      : () async {
                          if (!formKey
                              .currentState!
                              .validate()) {
                            return;
                          }

                          setDialogState(() {
                            submitting = true;
                          });

                          try {
                            final quantity =
                                double.parse(
                              quantityController
                                  .text
                                  .trim(),
                            );

                            final offeredPrice =
                                double.parse(
                              priceController
                                  .text
                                  .trim(),
                            );

                            final message =
                                messageController
                                    .text
                                    .trim();

                            final offerData = {
                              "crop_lot_id":
                                  widget.cropLotId,
                              "quantity":
                                  quantity,
                              "offered_price":
                                  offeredPrice,
                              "message":
                                  message.isEmpty
                                      ? "Interested in purchasing this crop lot."
                                      : message,
                            };

                            await OfferService
                                .createOffer(
                              offerData,
                            );

                            if (!dialogContext.mounted) {
                              return;
                            }

                            Navigator.pop(
                              dialogContext,
                            );

                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Offer sent successfully",
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!dialogContext.mounted) {
                              return;
                            }

                            setDialogState(() {
                              submitting = false;
                            });

                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Unable to send offer: $e",
                                ),
                              ),
                            );
                          }
                        },
                  child: submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Send Offer",
                        ),
                ),
              ],
            );
          },
        );
      },
    );

    quantityController.dispose();
    priceController.dispose();
    messageController.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Find Buyers",
        ),
      ),
      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadBuyers,
              child: buyers.isEmpty
                  ? ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height:
                              MediaQuery.of(
                                    context,
                                  ).size.height *
                                  0.3,
                        ),
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Center(
                          child: Text(
                            "No matching buyers found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Center(
                          child: Text(
                            "Try again later or check another crop lot.",
                            textAlign:
                                TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding:
                          const EdgeInsets.all(16),
                      children: [
                        _buildCropSummaryCard(),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${buyers.length} Matching Buyer${buyers.length == 1 ? '' : 's'}",
                          style:
                              const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ...buyers.map(
                          (buyer) =>
                              _buildBuyerCard(
                            buyer,
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  // ============================================================
  // CROP SUMMARY
  // ============================================================

  Widget _buildCropSummaryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(14),
                color:
                    Colors.green.shade100,
              ),
              child: Icon(
                Icons.agriculture,
                color:
                    Colors.green.shade700,
                size: 28,
              ),
            ),
            const SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    cropName.isNotEmpty
                        ? cropName
                        : "Selected Crop",
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Available: ${_formatNumber(availableQuantity)} kg",
                    style: TextStyle(
                      color:
                          Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BUYER CARD
  // ============================================================

  Widget _buildBuyerCard(
    dynamic buyer,
  ) {
    if (buyer is! Map) {
      return const SizedBox.shrink();
    }

    final buyerData =
        Map<String, dynamic>.from(
      buyer,
    );

    final int matchScore =
        _toDouble(
          buyerData["match_score"],
        ).round();

    final String companyName =
        buyerData["company_name"]
                ?.toString() ??
            "Buyer";

    final String businessType =
        buyerData["business_type"]
                ?.toString() ??
            "Agricultural Buyer";

    final String preferredLocation =
        buyerData["preferred_location"]
                ?.toString() ??
            "Location not available";

    final String deliveryLocation =
        buyerData["delivery_location"]
                ?.toString() ??
            "";

    final bool deliveryRequired =
        buyerData["delivery_required"] ==
            true;

    final double requiredQuantity =
        _toDouble(
      buyerData["required_quantity"],
    );

    final double buyerMinPrice =
        _toDouble(
      buyerData["buyer_min_price"],
    );

    final double buyerMaxPrice =
        _toDouble(
      buyerData["buyer_max_price"],
    );

    final double farmerExpectedPrice =
        _toDouble(
      buyerData["farmer_expected_price"],
    );

    final double distance =
        _toDouble(
      buyerData["distance_km"],
    );

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),
      elevation: 2,
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 27,
                  backgroundColor:
                      Colors.green.shade100,
                  child: Text(
                    "$matchScore%",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Colors.green.shade800,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        companyName,
                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        businessType,
                        style: TextStyle(
                          color:
                              Colors.grey
                                  .shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 18,
            ),

            const Divider(),

            const SizedBox(
              height: 12,
            ),

            _infoRow(
              Icons.inventory_2_outlined,
              "Required quantity",
              "${_formatNumber(requiredQuantity)} kg",
            ),

            const SizedBox(
              height: 10,
            ),

            _infoRow(
              Icons.location_on_outlined,
              "Preferred location",
              preferredLocation,
            ),

            const SizedBox(
              height: 10,
            ),

            _infoRow(
              Icons.route_outlined,
              "Distance",
              "${distance.toStringAsFixed(2)} km",
            ),

            const SizedBox(
              height: 10,
            ),

            _infoRow(
              Icons.currency_rupee,
              "Buyer price range",
              "₹${_formatNumber(buyerMinPrice)} - ₹${_formatNumber(buyerMaxPrice)}",
            ),

            const SizedBox(
              height: 10,
            ),

            _infoRow(
              Icons.sell_outlined,
              "Your expected price",
              "₹${_formatNumber(farmerExpectedPrice)}",
            ),

            if (deliveryRequired) ...[
              const SizedBox(
                height: 10,
              ),
              _infoRow(
                Icons.local_shipping_outlined,
                "Delivery",
                deliveryLocation
                        .isNotEmpty
                    ? "Required → $deliveryLocation"
                    : "Required",
              ),
            ],

            const SizedBox(
              height: 16,
            ),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
                color:
                    Colors.green.shade50,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: 20,
                    color:
                        Colors.green.shade700,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      "Match score: $matchScore%",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                        color:
                            Colors.green.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            // ======================================================
            // MAKE OFFER BUTTON
            // ======================================================

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showMakeOfferDialog(
                    buyerData,
                  );
                },
                icon: const Icon(
                  Icons.local_offer_outlined,
                ),
                label: const Text(
                  "Make Offer",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _infoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 21,
          color: Colors.grey.shade700,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      Colors.grey.shade600,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                value,
                style:
                    const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}