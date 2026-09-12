import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../farmer/farmer_registration_screen.dart';
import '../fpo/fpo_registration_screen.dart';
import '../buyer/buyer_registration_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState
    extends State<RoleSelectionScreen> {
  String? selectedRole;

  void _continue() {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).selectRole,
          ),
        ),
      );
      return;
    }

    if (selectedRole == 'farmer') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const FarmerRegistrationScreen(),
        ),
      );
    } else if (selectedRole == 'fpo') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const FpoRegistrationScreen(),
        ),
      );
    } else if (selectedRole == 'buyer') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const BuyerRegistrationScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmora'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                local.selectRole,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                local.roleSubtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),

              _buildRoleCard(
                role: 'farmer',
                title: local.farmer,
                description: local.farmerDescription,
                icon: Icons.agriculture,
              ),

              const SizedBox(height: 16),

              _buildRoleCard(
                role: 'fpo',
                title: local.fpo,
                description: local.fpoDescription,
                icon: Icons.groups,
              ),

              const SizedBox(height: 16),

              _buildRoleCard(
                role: 'buyer',
                title: local.buyer,
                description: local.buyerDescription,
                icon: Icons.shopping_cart,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _continue,
                  child: Text(
                    local.continueText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.08)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 36,
              color: Theme.of(context).colorScheme.primary,
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            if (isSelected)
              Icon(
                Icons.check_circle,
                color:
                    Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}