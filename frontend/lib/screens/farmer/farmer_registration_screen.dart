import 'package:flutter/material.dart';

import 'farmer_dashboard_screen.dart';

class FarmerRegistrationScreen extends StatefulWidget {
  const FarmerRegistrationScreen({super.key});

  @override
  State<FarmerRegistrationScreen> createState() =>
      _FarmerRegistrationScreenState();
}

class _FarmerRegistrationScreenState
    extends State<FarmerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _villageController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _landController = TextEditingController();
  final _cultivatedController = TextEditingController();

  final Map<String, bool> crops = {
    'Cotton': false,
    'Rice': false,
    'Wheat': false,
    'Sugarcane': false,
    'Onion': false,
    'Tomato': false,
  };

  String get languageCode {
    return Localizations.localeOf(context).languageCode;
  }

  String get title {
    switch (languageCode) {
      case 'ta':
        return 'விவசாயி பதிவு';
      case 'mr':
        return 'शेतकरी नोंदणी';
      default:
        return 'Farmer Registration';
    }
  }

  String get subtitle {
    switch (languageCode) {
      case 'ta':
        return 'உங்கள் பண்ணையைப் பற்றிய விவரங்களை வழங்குங்கள்';
      case 'mr':
        return 'तुमच्या शेताची माहिती द्या';
      default:
        return 'Tell us about your farm';
    }
  }

  String get villageLabel {
    switch (languageCode) {
      case 'ta':
        return 'கிராமம் / பகுதி';
      case 'mr':
        return 'गाव / परिसर';
      default:
        return 'Village / Area';
    }
  }

  String get districtLabel {
    switch (languageCode) {
      case 'ta':
        return 'மாவட்டம்';
      case 'mr':
        return 'जिल्हा';
      default:
        return 'District';
    }
  }

  String get stateLabel {
    switch (languageCode) {
      case 'ta':
        return 'மாநிலம்';
      case 'mr':
        return 'राज्य';
      default:
        return 'State';
    }
  }

  String get landAreaLabel {
    switch (languageCode) {
      case 'ta':
        return 'மொத்த நிலப்பரப்பு (ஏக்கர்)';
      case 'mr':
        return 'एकूण जमीन क्षेत्र (एकर)';
      default:
        return 'Total Land Area (acres)';
    }
  }

  String get cultivatedAreaLabel {
    switch (languageCode) {
      case 'ta':
        return 'தற்போது பயிரிடப்படும் நிலப்பரப்பு (ஏக்கர்)';
      case 'mr':
        return 'सध्या लागवड केलेले क्षेत्र (एकर)';
      default:
        return 'Currently Cultivated Area (acres)';
    }
  }

  String get cropsTitle {
    switch (languageCode) {
      case 'ta':
        return 'பயிரிடப்படும் பயிர்கள்';
      case 'mr':
        return 'लागवड केलेली पिके';
      default:
        return 'Crops Cultivated';
    }
  }

  String get completeButton {
    switch (languageCode) {
      case 'ta':
        return 'பதிவை நிறைவு செய்க';
      case 'mr':
        return 'नोंदणी पूर्ण करा';
      default:
        return 'Complete Registration';
    }
  }

  String get selectCropMessage {
    switch (languageCode) {
      case 'ta':
        return 'குறைந்தது ஒரு பயிரையாவது தேர்ந்தெடுக்கவும்.';
      case 'mr':
        return 'किमान एक पीक निवडा.';
      default:
        return 'Please select at least one crop.';
    }
  }

  String requiredMessage(String field) {
    switch (languageCode) {
      case 'ta':
        return '$field-ஐ உள்ளிடவும்.';
      case 'mr':
        return '$field प्रविष्ट करा.';
      default:
        return 'Please enter $field.';
    }
  }

  @override
  void dispose() {
    _villageController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _landController.dispose();
    _cultivatedController.dispose();
    super.dispose();
  }

  void _completeRegistration() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final selectedCrops =
        crops.entries.where((entry) => entry.value).toList();

    if (selectedCrops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(selectCropMessage),
        ),
      );
      return;
    }

    /*
     * BACKEND INTEGRATION WILL COME HERE.
     *
     * Final flow:
     *
     * Farmer Registration
     *        ↓
     * FastAPI
     *        ↓
     * Save farmer profile + role
     *        ↓
     * role = farmer
     * profile_completed = true
     *        ↓
     * Farmer Dashboard
     */

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const FarmerDashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7),
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE8F5E9),
                        Color(0xFFF4FAF4),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: const Icon(
                          Icons.agriculture_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B1B1B),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                _sectionTitle(
                  icon: Icons.location_on_outlined,
                  title: languageCode == 'ta'
                      ? 'இருப்பிட விவரங்கள்'
                      : languageCode == 'mr'
                          ? 'स्थानाची माहिती'
                          : 'Location Details',
                ),

                const SizedBox(height: 14),

                _field(
                  controller: _villageController,
                  label: villageLabel,
                  icon: Icons.home_work_outlined,
                ),

                _field(
                  controller: _districtController,
                  label: districtLabel,
                  icon: Icons.location_city_outlined,
                ),

                _field(
                  controller: _stateController,
                  label: stateLabel,
                  icon: Icons.map_outlined,
                ),

                const SizedBox(height: 10),

                _sectionTitle(
                  icon: Icons.landscape_outlined,
                  title: languageCode == 'ta'
                      ? 'நில விவரங்கள்'
                      : languageCode == 'mr'
                          ? 'जमिनीची माहिती'
                          : 'Land Details',
                ),

                const SizedBox(height: 14),

                _field(
                  controller: _landController,
                  label: landAreaLabel,
                  icon: Icons.landscape_outlined,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),

                _field(
                  controller: _cultivatedController,
                  label: cultivatedAreaLabel,
                  icon: Icons.grass_outlined,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),

                const SizedBox(height: 10),

                _sectionTitle(
                  icon: Icons.eco_outlined,
                  title: cropsTitle,
                ),

                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    children: crops.keys.map(
                      (crop) {
                        return CheckboxListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                          title: Text(
                            _cropName(crop),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          secondary: Icon(
                            _cropIcon(crop),
                            color: const Color(0xFF2E7D32),
                          ),
                          activeColor:
                              const Color(0xFF2E7D32),
                          value: crops[crop],
                          onChanged: (value) {
                            setState(() {
                              crops[crop] = value ?? false;
                            });
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _completeRegistration,
                    icon: const Icon(
                      Icons.check_circle_outline,
                    ),
                    label: Text(
                      completeButton,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: Text(
                    languageCode == 'ta'
                        ? 'உங்கள் விவரங்கள் பாதுகாப்பாக பயன்படுத்தப்படும்'
                        : languageCode == 'mr'
                            ? 'तुमची माहिती सुरक्षितपणे वापरली जाईल'
                            : 'Your information will be securely used',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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

  Widget _sectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 21,
          color: const Color(0xFF2E7D32),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF2E7D32),
              width: 1.5,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return requiredMessage(label);
          }
          return null;
        },
      ),
    );
  }

  String _cropName(String crop) {
    if (languageCode == 'ta') {
      switch (crop) {
        case 'Cotton':
          return 'பருத்தி';
        case 'Rice':
          return 'நெல்';
        case 'Wheat':
          return 'கோதுமை';
        case 'Sugarcane':
          return 'கரும்பு';
        case 'Onion':
          return 'வெங்காயம்';
        case 'Tomato':
          return 'தக்காளி';
      }
    }

    if (languageCode == 'mr') {
      switch (crop) {
        case 'Cotton':
          return 'कापूस';
        case 'Rice':
          return 'तांदूळ';
        case 'Wheat':
          return 'गहू';
        case 'Sugarcane':
          return 'ऊस';
        case 'Onion':
          return 'कांदा';
        case 'Tomato':
          return 'टोमॅटो';
      }
    }

    return crop;
  }

  IconData _cropIcon(String crop) {
    switch (crop) {
      case 'Cotton':
        return Icons.cloud_outlined;
      case 'Rice':
        return Icons.grass;
      case 'Wheat':
        return Icons.grass_outlined;
      case 'Sugarcane':
        return Icons.energy_savings_leaf_outlined;
      case 'Onion':
        return Icons.circle_outlined;
      case 'Tomato':
        return Icons.local_florist_outlined;
      default:
        return Icons.eco_outlined;
    }
  }
}