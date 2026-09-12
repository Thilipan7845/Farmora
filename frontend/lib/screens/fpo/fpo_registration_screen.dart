import 'package:flutter/material.dart';

import 'fpo_dashboard_screen.dart';

class FpoRegistrationScreen extends StatefulWidget {
  const FpoRegistrationScreen({super.key});

  @override
  State<FpoRegistrationScreen> createState() =>
      _FpoRegistrationScreenState();
}

class _FpoRegistrationScreenState
    extends State<FpoRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fpoNameController = TextEditingController();
  final _registrationController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _villageController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _membersController = TextEditingController();

  String get languageCode {
    return Localizations.localeOf(context).languageCode;
  }

  String get pageTitle {
    switch (languageCode) {
      case 'ta':
        return 'FPO பதிவு';
      case 'mr':
        return 'FPO नोंदणी';
      default:
        return 'FPO Registration';
    }
  }

  String get subtitle {
    switch (languageCode) {
      case 'ta':
        return 'உங்கள் FPO பற்றிய விவரங்களை வழங்குங்கள்';
      case 'mr':
        return 'तुमच्या FPO ची माहिती द्या';
      default:
        return 'Tell us about your FPO';
    }
  }

  String get organisationSection {
    switch (languageCode) {
      case 'ta':
        return 'FPO விவரங்கள்';
      case 'mr':
        return 'FPO ची माहिती';
      default:
        return 'FPO Details';
    }
  }

  String get contactSection {
    switch (languageCode) {
      case 'ta':
        return 'தொடர்பு விவரங்கள்';
      case 'mr':
        return 'संपर्क माहिती';
      default:
        return 'Contact Details';
    }
  }

  String get locationSection {
    switch (languageCode) {
      case 'ta':
        return 'இருப்பிட விவரங்கள்';
      case 'mr':
        return 'स्थानाची माहिती';
      default:
        return 'Location Details';
    }
  }

  String get fpoNameLabel {
    switch (languageCode) {
      case 'ta':
        return 'FPO பெயர்';
      case 'mr':
        return 'FPO चे नाव';
      default:
        return 'FPO Name';
    }
  }

  String get registrationLabel {
    switch (languageCode) {
      case 'ta':
        return 'பதிவு எண்';
      case 'mr':
        return 'नोंदणी क्रमांक';
      default:
        return 'Registration Number';
    }
  }

  String get contactPersonLabel {
    switch (languageCode) {
      case 'ta':
        return 'தொடர்பு நபர்';
      case 'mr':
        return 'संपर्क व्यक्ती';
      default:
        return 'Contact Person';
    }
  }

  String get contactNumberLabel {
    switch (languageCode) {
      case 'ta':
        return 'தொடர்பு எண்';
      case 'mr':
        return 'संपर्क क्रमांक';
      default:
        return 'Contact Number';
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

  String get membersLabel {
    switch (languageCode) {
      case 'ta':
        return 'விவசாயி உறுப்பினர்களின் எண்ணிக்கை';
      case 'mr':
        return 'शेतकरी सदस्यांची संख्या';
      default:
        return 'Number of Farmer Members';
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

  String get secureMessage {
    switch (languageCode) {
      case 'ta':
        return 'உங்கள் FPO தகவல்கள் பாதுகாப்பாக பயன்படுத்தப்படும்';
      case 'mr':
        return 'तुमची FPO माहिती सुरक्षितपणे वापरली जाईल';
      default:
        return 'Your FPO information will be securely used';
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
    _fpoNameController.dispose();
    _registrationController.dispose();
    _contactPersonController.dispose();
    _contactNumberController.dispose();
    _villageController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _membersController.dispose();
    super.dispose();
  }

  void _completeRegistration() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    /*
     * BACKEND INTEGRATION WILL COME HERE.
     *
     * Final flow:
     *
     * FPO Registration
     *       ↓
     * FastAPI
     *       ↓
     * Save FPO profile + role
     *       ↓
     * role = fpo
     * profile_completed = true
     *       ↓
     * FPO Dashboard
     */

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const FpoDashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7),
      appBar: AppBar(
        title: Text(pageTitle),
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
                          Icons.groups_rounded,
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
                              pageTitle,
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
                  Icons.business_outlined,
                  organisationSection,
                ),

                const SizedBox(height: 14),

                _field(
                  controller: _fpoNameController,
                  label: fpoNameLabel,
                  icon: Icons.groups_outlined,
                ),

                _field(
                  controller: _registrationController,
                  label: registrationLabel,
                  icon: Icons.badge_outlined,
                ),

                const SizedBox(height: 10),

                _sectionTitle(
                  Icons.contact_phone_outlined,
                  contactSection,
                ),

                const SizedBox(height: 14),

                _field(
                  controller: _contactPersonController,
                  label: contactPersonLabel,
                  icon: Icons.person_outline,
                ),

                _field(
                  controller: _contactNumberController,
                  label: contactNumberLabel,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 10),

                _sectionTitle(
                  Icons.location_on_outlined,
                  locationSection,
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

                _field(
                  controller: _membersController,
                  label: membersLabel,
                  icon: Icons.people_outline,
                  keyboardType: TextInputType.number,
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
                    secureMessage,
                    textAlign: TextAlign.center,
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

  Widget _sectionTitle(
    IconData icon,
    String title,
  ) {
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
}