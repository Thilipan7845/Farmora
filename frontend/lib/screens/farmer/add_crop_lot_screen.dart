import 'package:flutter/material.dart';

import '../../services/crop_service.dart';

class AddCropLotScreen extends StatefulWidget {
  const AddCropLotScreen({super.key});

  @override
  State<AddCropLotScreen> createState() => _AddCropLotScreenState();
}

class _AddCropLotScreenState extends State<AddCropLotScreen> {
  final _formKey = GlobalKey<FormState>();

  // ============================================================
  // FORM CONTROLLERS
  // ============================================================

  final cropController = TextEditingController();
  final varietyController = TextEditingController();
  final quantityController = TextEditingController();
  final qualityGradeController = TextEditingController();
  final priceController = TextEditingController();
  final harvestDateController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  bool loading = false;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    cropController.dispose();
    varietyController.dispose();
    quantityController.dispose();
    qualityGradeController.dispose();
    priceController.dispose();
    harvestDateController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();

    super.dispose();
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> selectHarvestDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );

    if (selectedDate == null) {
      return;
    }

    final formattedDate =
        "${selectedDate.year.toString().padLeft(4, '0')}-"
        "${selectedDate.month.toString().padLeft(2, '0')}-"
        "${selectedDate.day.toString().padLeft(2, '0')}";

    harvestDateController.text = formattedDate;
  }

  // ============================================================
  // SAVE CROP
  // ============================================================

  Future<void> saveCrop() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final cropData = {
        "crop_name": cropController.text.trim(),
        "variety": varietyController.text.trim(),
        "quantity": double.parse(
          quantityController.text.trim(),
        ),
        "quality_grade": qualityGradeController.text.trim(),
        "expected_price": double.parse(
          priceController.text.trim(),
        ),
        "harvest_date": harvestDateController.text.trim(),
        "latitude": double.parse(
          latitudeController.text.trim(),
        ),
        "longitude": double.parse(
          longitudeController.text.trim(),
        ),
        "crop_image_url": null,
      };

      await CropService.createCropLot(cropData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Crop lot created successfully",
          ),
        ),
      );

      // Return true so Farmer Dashboard refreshes
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Crop Lot",
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==================================================
                // CROP NAME
                // ==================================================

                TextFormField(
                  controller: cropController,

                  decoration: const InputDecoration(
                    labelText: "Crop Name",
                    hintText: "Example: Cotton",
                    prefixIcon: Icon(
                      Icons.grass,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Enter crop name";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // VARIETY
                // ==================================================

                TextFormField(
                  controller: varietyController,

                  decoration: const InputDecoration(
                    labelText: "Variety",
                    hintText: "Example: Bt Cotton",
                    prefixIcon: Icon(
                      Icons.eco,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Enter crop variety";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // QUANTITY
                // ==================================================

                TextFormField(
                  controller: quantityController,

                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  decoration: const InputDecoration(
                    labelText: "Quantity (kg)",
                    hintText: "Example: 500",
                    prefixIcon: Icon(
                      Icons.inventory_2,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Enter quantity";
                    }

                    final quantity =
                        double.tryParse(value);

                    if (quantity == null ||
                        quantity <= 0) {
                      return "Enter valid quantity";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // QUALITY GRADE
                // ==================================================

                TextFormField(
                  controller: qualityGradeController,

                  decoration: const InputDecoration(
                    labelText: "Quality Grade",
                    hintText: "Example: A",
                    prefixIcon: Icon(
                      Icons.verified,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Enter quality grade";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // EXPECTED PRICE
                // ==================================================

                TextFormField(
                  controller: priceController,

                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  decoration: const InputDecoration(
                    labelText: "Expected Price",
                    hintText: "Example: 7200",
                    prefixIcon: Icon(
                      Icons.currency_rupee,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Enter expected price";
                    }

                    final price =
                        double.tryParse(value);

                    if (price == null ||
                        price <= 0) {
                      return "Enter valid price";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // HARVEST DATE
                // ==================================================

                TextFormField(
                  controller: harvestDateController,

                  readOnly: true,

                  onTap: selectHarvestDate,

                  decoration: const InputDecoration(
                    labelText: "Harvest Date",
                    hintText: "Select harvest date",
                    prefixIcon: Icon(
                      Icons.calendar_month,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Select harvest date";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // LATITUDE
                // ==================================================

                TextFormField(
                  controller: latitudeController,

                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),

                  decoration: const InputDecoration(
                    labelText: "Latitude",
                    hintText: "Example: 11.0168",
                    prefixIcon: Icon(
                      Icons.location_on,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Enter latitude";
                    }

                    final latitude =
                        double.tryParse(value);

                    if (latitude == null ||
                        latitude < -90 ||
                        latitude > 90) {
                      return "Enter valid latitude";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // LONGITUDE
                // ==================================================

                TextFormField(
                  controller: longitudeController,

                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),

                  decoration: const InputDecoration(
                    labelText: "Longitude",
                    hintText: "Example: 76.9558",
                    prefixIcon: Icon(
                      Icons.location_on,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Enter longitude";
                    }

                    final longitude =
                        double.tryParse(value);

                    if (longitude == null ||
                        longitude < -180 ||
                        longitude > 180) {
                      return "Enter valid longitude";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // ==================================================
                // CREATE BUTTON
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    onPressed:
                        loading ? null : saveCrop,

                    child: loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,

                            child:
                                CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Create Crop Lot",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}