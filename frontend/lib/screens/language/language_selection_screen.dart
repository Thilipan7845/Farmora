import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/language_controller.dart';
import '../auth/account_access_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends State<LanguageSelectionScreen> {
  String? selectedLanguage;

  final List<Map<String, String>> languages = [
    {
      'name': 'English',
      'code': 'en',
    },
    {
      'name': 'தமிழ்',
      'code': 'ta',
    },
    {
      'name': 'मराठी',
      'code': 'mr',
    },
  ];

  void _continue() {
    if (selectedLanguage == null) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AccountAccessScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              Text(
                local.chooseLanguage,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                local.languageSubtitle,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 28),

              ...languages.map(
                (language) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildLanguageCard(
                      languageName: language['name']!,
                      languageCode: language['code']!,
                    ),
                  );
                },
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      selectedLanguage == null ? null : _continue,
                  child: Text(
                    local.continueText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String languageName,
    required String languageCode,
  }) {
    final isSelected = selectedLanguage == languageName;

    return InkWell(
      onTap: () {
        setState(() {
          selectedLanguage = languageName;
        });

        languageController.setLanguage(languageCode);
      },
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                languageName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
            ),
          ],
        ),
      ),
    );
  }
}