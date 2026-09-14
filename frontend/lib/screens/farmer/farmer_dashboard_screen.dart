import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../services/crop_service.dart';
import '../../services/dashboard_service.dart';
import '../../services/order_service.dart';

import 'add_crop_lot_screen.dart';
import 'intelligence_screen.dart';
import 'buyer_matching_screen.dart';
import 'offers_screen.dart';
import 'orders_screen.dart';
import 'logistics_screen.dart';
import 'payment_screen.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() =>
      _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState
    extends State<FarmerDashboardScreen> {
  int _selectedIndex = 0;

  List<dynamic> cropLots = [];
  Map<String, dynamic> dashboardStats = {};
  List<dynamic> farmerOrders = [];

  bool loadingCrops = true;
  bool loadingStats = true;
  bool loadingOrders = true;

  @override
  void initState() {
    super.initState();

    loadCropLots();
    loadDashboardStats();
    loadFarmerOrders();
  }

  // ============================================================
  // LOAD CROP LOTS
  // ============================================================

  Future<void> loadCropLots() async {
    try {
      final data = await CropService.getCropLots();

      if (!mounted) return;

      setState(() {
        cropLots = data;
        loadingCrops = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingCrops = false;
      });
    }
  }

  // ============================================================
  // LOAD DASHBOARD STATS
  // ============================================================

  Future<void> loadDashboardStats() async {
    try {
      final data = await DashboardService.getStats();

      if (!mounted) return;

      setState(() {
        dashboardStats = data;
        loadingStats = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingStats = false;
      });
    }
  }

  // ============================================================
  // LOAD FARMER ORDERS
  // ============================================================

  Future<void> loadFarmerOrders() async {
    try {
      final data = await OrderService.getOrders();

      if (!mounted) return;

      setState(() {
        farmerOrders = data;
        loadingOrders = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        farmerOrders = [];
        loadingOrders = false;
      });
    }
  }

  // ============================================================
  // REFRESH EVERYTHING
  // ============================================================

  Future<void> refreshDashboard() async {
    await Future.wait([
      loadCropLots(),
      loadDashboardStats(),
      loadFarmerOrders(),
    ]);
  }

  // ============================================================
  // LANGUAGE
  // ============================================================

  String get languageCode {
    return Localizations.localeOf(context).languageCode;
  }

  String getText({
    required String en,
    required String ta,
    required String mr,
  }) {
    switch (languageCode) {
      case 'ta':
        return ta;

      case 'mr':
        return mr;

      default:
        return en;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F5),
      appBar: _buildAppBar(local),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHome(local),
          _buildCropsPage(local),
          _buildMarketPage(local),
          const OrdersScreen(),
          _buildProfilePage(local),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  PreferredSizeWidget _buildAppBar(
    AppLocalizations local,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.agriculture_rounded,
              color: Color(0xFF2E7D32),
              size: 25,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              local.farmerDashboard,
              style: const TextStyle(
                color: Color(0xFF172117),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),

          _iconButton(
            icon: Icons.notifications_none_rounded,
            onPressed: _showNotifications,
            badge: '3',
          ),

          const SizedBox(width: 4),

          _iconButton(
            icon: Icons.person_outline_rounded,
            onPressed: () {
              setState(() {
                _selectedIndex = 4;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? badge,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: const Color(0xFF344034),
          ),
        ),

        if (badge != null)
          Positioned(
            right: 4,
            top: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE65100),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // HOME
  // ============================================================

  Widget _buildHome(AppLocalizations local) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            18,
            10,
            18,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(local),

              const SizedBox(height: 18),

              _buildQuickStats(),

              const SizedBox(height: 20),

              _buildAiInsight(),

              const SizedBox(height: 22),

              _buildSectionHeader(
                title: getText(
                  en: 'My Crops',
                  ta: 'என் பயிர்கள்',
                  mr: 'माझी पिके',
                ),
                action: getText(
                  en: 'View All',
                  ta: 'அனைத்தையும் காண்க',
                  mr: 'सर्व पहा',
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),

              const SizedBox(height: 12),

              _buildCropPreview(),

              const SizedBox(height: 22),

              _buildSectionHeader(
                title: getText(
                  en: 'Market Snapshot',
                  ta: 'சந்தை நிலவரம்',
                  mr: 'बाजाराचा आढावा',
                ),
                action: getText(
                  en: 'Explore',
                  ta: 'பார்க்க',
                  mr: 'पहा',
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),

              const SizedBox(height: 12),

              _buildMarketSnapshot(),

              const SizedBox(height: 22),

              _buildBuyerMatchingCard(),

              const SizedBox(height: 18),

              _buildOffersCard(),

              const SizedBox(height: 18),

              _buildDeliveryCard(),

              const SizedBox(height: 18),

              _buildPaymentCard(),

              const SizedBox(height: 24),

              _buildQuickActions(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GREETING
  // ============================================================

  Widget _buildGreeting(AppLocalizations local) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5E9),
            Color(0xFFF4F8EF),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  local.farmerGreeting,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF17351B),
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  getText(
                    en:
                        'Make smarter decisions and get better value for your crops.',
                    ta:
                        'சிறந்த முடிவுகளை எடுத்து உங்கள் பயிர்களுக்கு நல்ல விலையைப் பெறுங்கள்.',
                    mr:
                        'स्मार्ट निर्णय घ्या आणि तुमच्या पिकांना चांगली किंमत मिळवा.',
                  ),
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xFF2E7D32),
                    ),

                    const SizedBox(width: 4),

                    Text(
                      getText(
                        en: 'Your Farm Location',
                        ta: 'உங்கள் பண்ணை இருப்பிடம்',
                        mr: 'तुमच्या शेताचे ठिकाण',
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.75,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.agriculture_rounded,
              size: 39,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK STATS
  // ============================================================

  Widget _buildQuickStats() {
    if (loadingStats) {
      return const SizedBox(
        height: 110,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.inventory_2_outlined,
            value:
                dashboardStats["crop_count"]?.toString() ??
                    "0",
            label: getText(
              en: 'Crop Lots',
              ta: 'பயிர் தொகுப்புகள்',
              mr: 'पिकांचे लॉट',
            ),
            iconBackground:
                const Color(0xFFE8F5E9),
            iconColor:
                const Color(0xFF2E7D32),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _statCard(
            icon: Icons.local_offer_outlined,
            value:
                dashboardStats["offer_count"]?.toString() ??
                    "0",
            label: getText(
              en: 'Offers',
              ta: 'சலுகைகள்',
              mr: 'ऑफर्स',
            ),
            iconBackground:
                const Color(0xFFFFF3E0),
            iconColor:
                const Color(0xFFE67E22),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _statCard(
            icon: Icons.shopping_bag_outlined,
            value:
                dashboardStats["order_count"]?.toString() ??
                    "0",
            label: getText(
              en: 'Orders',
              ta: 'ஆர்டர்கள்',
              mr: 'ऑर्डर्स',
            ),
            iconBackground:
                const Color(0xFFE3F2FD),
            iconColor:
                const Color(0xFF1976D2),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color iconBackground,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        11,
        13,
        8,
        13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AI INSIGHT
  // ============================================================

  Widget _buildAiInsight() {
    final hasCrop = cropLots.isNotEmpty;

    final cropName = hasCrop
        ? cropLots[0]["crop_name"]?.toString() ??
            "Crop"
        : getText(
            en: 'No crop selected',
            ta: 'பயிர் தேர்ந்தெடுக்கப்படவில்லை',
            mr: 'पीक निवडलेले नाही',
          );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF173F1C),
            Color(0xFF2E7D32),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32)
                .withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.16,
                  ),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Text(
                  getText(
                    en: 'Farmora AI Insight',
                    ta: 'Farmora AI நுண்ணறிவு',
                    mr: 'Farmora AI माहिती',
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  getText(
                    en: 'SMART',
                    ta: 'ஸ்மார்ட்',
                    mr: 'स्मार्ट',
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          Text(
            cropName,
            style: TextStyle(
              color: Colors.white.withValues(
                alpha: 0.8,
              ),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            getText(
              en: 'AI-powered market decision support',
              ta: 'AI அடிப்படையிலான சந்தை முடிவு உதவி',
              mr: 'AI आधारित बाजार निर्णय सहाय्य',
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.auto_graph_rounded,
                color: Color(0xFFB9F6CA),
                size: 19,
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Text(
                  getText(
                    en:
                        'Get live price prediction, trend and selling recommendation.',
                    ta:
                        'நேரடி விலை கணிப்பு, போக்கு மற்றும் விற்பனை பரிந்துரையைப் பெறுங்கள்.',
                    mr:
                        'थेट किंमत अंदाज, ट्रेंड आणि विक्री शिफारस मिळवा.',
                  ),
                  style: const TextStyle(
                    color: Color(0xFFB9F6CA),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.psychology_outlined,
                  color: Colors.white,
                  size: 21,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    getText(
                      en:
                          'Open Market Intelligence to get a recommendation for your crop.',
                      ta:
                          'உங்கள் பயிருக்கான பரிந்துரையைப் பெற சந்தை நுண்ணறிவைத் திறக்கவும்.',
                      mr:
                          'तुमच्या पिकासाठी शिफारस मिळवण्यासाठी बाजार माहिती उघडा.',
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 13),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {
                if (cropLots.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        getText(
                          en:
                              'Please add a crop lot first.',
                          ta:
                              'முதலில் ஒரு பயிர் தொகுப்பைச் சேர்க்கவும்.',
                          mr:
                              'कृपया प्रथम पीक लॉट जोडा.',
                        ),
                      ),
                    ),
                  );

                  return;
                }

                final crop = cropLots[0];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        IntelligenceScreen(
                      crop:
                          crop["crop_name"] ??
                              "Crop",
                      quantity: double.tryParse(
                            crop["quantity"]
                                    .toString(),
                          ) ??
                          0,
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Colors.white.withValues(
                    alpha: 0.5,
                  ),
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(13),
                ),
              ),
              child: Text(
                getText(
                  en: 'View Market Intelligence',
                  ta: 'சந்தை நுண்ணறிவைப் பார்க்கவும்',
                  mr: 'बाजार माहिती पहा',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CROP PREVIEW
  // ============================================================

  Widget _buildCropPreview() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          if (loadingCrops)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            )
          else if (cropLots.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                getText(
                  en: 'No crop lots added',
                  ta: 'பயிர் தொகுப்பு இல்லை',
                  mr: 'पीक लॉट उपलब्ध नाही',
                ),
              ),
            )
          else
            ...cropLots.map(
              (crop) {
                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: _cropRow(
                    icon: Icons.grass_rounded,
                    crop:
                        crop["crop_name"] ??
                            "Crop",
                    quantity:
                        "${crop["quantity"] ?? 0} kg",
                    status: getText(
                      en: "Available",
                      ta: "கிடைக்கிறது",
                      mr: "उपलब्ध",
                    ),
                    statusColor:
                        const Color(0xFF2E7D32),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _cropRow({
    required IconData icon,
    required String crop,
    required String quantity,
    required String status,
    required Color statusColor,
  }) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius:
                BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2E7D32),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                crop,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                quantity,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(
              alpha: 0.10,
            ),
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MARKET
  // ============================================================

  Widget _buildMarketSnapshot() {
    return Column(
      children: [
        _marketRow(
          crop: getText(
            en: 'Market Data',
            ta: 'சந்தை தரவு',
            mr: 'बाजार डेटा',
          ),
          price: getText(
            en: 'Live',
            ta: 'நேரடி',
            mr: 'थेट',
          ),
          trend: getText(
            en: 'AI',
            ta: 'AI',
            mr: 'AI',
          ),
          icon: Icons.insights_rounded,
          iconColor: const Color(0xFF2E7D32),
        ),

        const SizedBox(height: 9),

        _marketRow(
          crop: getText(
            en: 'Price Prediction',
            ta: 'விலை கணிப்பு',
            mr: 'किंमत अंदाज',
          ),
          price: getText(
            en: 'Available',
            ta: 'கிடைக்கும்',
            mr: 'उपलब्ध',
          ),
          trend: 'AI',
          icon: Icons.auto_graph_rounded,
          iconColor: const Color(0xFF1976D2),
        ),

        const SizedBox(height: 9),

        _marketRow(
          crop: getText(
            en: 'Selling Decision',
            ta: 'விற்பனை முடிவு',
            mr: 'विक्री निर्णय',
          ),
          price: getText(
            en: 'Personalized',
            ta: 'தனிப்பயன்',
            mr: 'वैयक्तिक',
          ),
          trend: 'AI',
          icon: Icons.psychology_outlined,
          iconColor: const Color(0xFFE67E22),
        ),
      ],
    );
  }

  Widget _marketRow({
    required String crop,
    required String price,
    required String trend,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              crop,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Text(
            price,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 10),

          Text(
            trend,
            style: TextStyle(
              color: iconColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUYER MATCHING
  // ============================================================

  Widget _buildBuyerMatchingCard() {
    return _featureCard(
      icon: Icons.people_alt_outlined,
      iconColor: const Color(0xFF1565C0),
      backgroundColor: const Color(0xFFE3F2FD),
      title: getText(
        en: 'Find the Best Buyers',
        ta: 'சிறந்த வாங்குபவர்களைக் கண்டறியுங்கள்',
        mr: 'सर्वोत्तम खरेदीदार शोधा',
      ),
      subtitle: getText(
        en:
            'Get matched with buyers based on price, quality and distance.',
        ta:
            'விலை, தரம் மற்றும் தூரத்தின் அடிப்படையில் வாங்குபவர்களைப் பெறுங்கள்.',
        mr:
            'किंमत, गुणवत्ता आणि अंतरानुसार खरेदीदार मिळवा.',
      ),
      buttonText: getText(
        en: 'Find Buyers',
        ta: 'வாங்குபவர்களை கண்டறி',
        mr: 'खरेदीदार शोधा',
      ),
      onPressed: () {
        if (cropLots.isEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(
                getText(
                  en: 'Add a crop lot first.',
                  ta: 'முதலில் பயிர் தொகுப்பைச் சேர்க்கவும்.',
                  mr: 'प्रथम पीक लॉट जोडा.',
                ),
              ),
            ),
          );

          return;
        }

        final crop = cropLots[0];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                BuyerMatchingScreen(
              cropLotId: crop["id"].toString(),
              cropName: crop["crop_name"]?.toString() ?? "Crop",
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // OFFERS
  // ============================================================

  Widget _buildOffersCard() {
    final offerCount =
        dashboardStats["offer_count"] ?? 0;

    return _featureCard(
      icon: Icons.local_offer_outlined,
      iconColor: const Color(0xFFE65100),
      backgroundColor: const Color(0xFFFFF3E0),
      title: getText(
        en: 'Offers Waiting for You',
        ta: 'உங்களுக்காக காத்திருக்கும் சலுகைகள்',
        mr: 'तुमच्यासाठी आलेल्या ऑफर्स',
      ),
      subtitle: getText(
        en:
            'You have $offerCount active buyer offers. Compare or negotiate before accepting.',
        ta:
            'உங்களிடம் $offerCount வாங்குபவர் சலுகைகள் உள்ளன. ஏற்கும் முன் ஒப்பிட்டு பேச்சுவார்த்தை நடத்துங்கள்.',
        mr:
            'तुमच्याकडे $offerCount सक्रिय खरेदीदार ऑफर्स आहेत. स्वीकारण्यापूर्वी तुलना किंवा वाटाघाटी करा.',
      ),
      buttonText: getText(
        en: 'View Offers',
        ta: 'சலுகைகளைப் பார்க்கவும்',
        mr: 'ऑफर्स पहा',
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const OffersScreen(),
          ),
        );
      },
    );
  }

  // ============================================================
  // DELIVERY
  // ============================================================

  Widget _buildDeliveryCard() {
    Map<String, dynamic>? activeOrder;

    for (final item in farmerOrders) {
      if (item is Map<String, dynamic>) {
        final status = item["status"]?.toString().toLowerCase();

        if (status != "cancelled") {
          activeOrder = item;
          break;
        }
      }
    }

    if (loadingOrders) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (activeOrder == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.local_shipping_outlined,
                    color: Color(0xFF1976D2),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    getText(
                      en: 'Delivery Tracking',
                      ta: 'டெலிவரி கண்காணிப்பு',
                      mr: 'डिलिव्हरी ट्रॅकिंग',
                    ),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              getText(
                en: 'No active orders available for delivery tracking.',
                ta: 'டெலிவரி கண்காணிப்புக்கு செயலில் உள்ள ஆர்டர்கள் இல்லை.',
                mr: 'डिलिव्हरी ट्रॅकिंगसाठी सक्रिय ऑर्डर उपलब्ध नाहीत.',
              ),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                },
                icon: const Icon(Icons.receipt_long_outlined, size: 19),
                label: Text(
                  getText(
                    en: 'View My Orders',
                    ta: 'என் ஆர்டர்களைப் பார்க்கவும்',
                    mr: 'माझे ऑर्डर्स पहा',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final orderId = activeOrder["id"]?.toString();
    final orderStatus = activeOrder["status"]?.toString() ?? "pending";
    final quantity = activeOrder["quantity"]?.toString() ?? "0";
    final totalAmount = activeOrder["total_amount"];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  getText(
                    en: 'Active Delivery',
                    ta: 'நடப்பு டெலிவரி',
                    mr: 'सक्रिय डिलिव्हरी',
                  ),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatDeliveryStatus(orderStatus),
                  style: const TextStyle(
                    color: Color(0xFF1976D2),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _deliveryInfo(
                  getText(en: 'Order', ta: 'ஆர்டர்', mr: 'ऑर्डर'),
                  orderId == null
                      ? '--'
                      : '#${orderId.length > 8 ? orderId.substring(0, 8) : orderId}',
                ),
              ),
              Expanded(
                child: _deliveryInfo(
                  getText(en: 'Quantity', ta: 'அளவு', mr: 'प्रमाण'),
                  '$quantity kg',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (totalAmount != null)
            _deliveryInfo(
              getText(en: 'Order Value', ta: 'ஆர்டர் மதிப்பு', mr: 'ऑर्डर मूल्य'),
              '₹${totalAmount.toString()}',
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: orderId == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LogisticsScreen(orderId: orderId),
                        ),
                      );
                    },
              icon: const Icon(Icons.map_outlined, size: 19),
              label: Text(
                getText(
                  en: 'Track Delivery',
                  ta: 'டெலிவரியை கண்காணிக்கவும்',
                  mr: 'डिलिव्हरी ट्रॅक करा',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDeliveryStatus(String status) {
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

  Widget _deliveryInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PAYMENT
  // ============================================================

  Widget _buildPaymentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF263238),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.white,
                size: 25,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  getText(
                    en: 'Payments',
                    ta: 'கொடுப்பனவுகள்',
                    mr: 'पेमेंट्स',
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            getText(
              en:
                  'View your sales, received amount and pending payments.',
              ta:
                  'உங்கள் விற்பனை, பெறப்பட்ட தொகை மற்றும் நிலுவைத் தொகையைப் பார்க்கவும்.',
              mr:
                  'तुमची विक्री, मिळालेली रक्कम आणि प्रलंबित पेमेंट पहा.',
            ),
            style: TextStyle(
              color: Colors.white.withValues(
                alpha: 0.70,
              ),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PaymentScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.account_balance_wallet,
              ),
              label: Text(
                getText(
                  en: 'View Payments',
                  ta: 'கொடுப்பனவுகளைப் பார்க்கவும்',
                  mr: 'पेमेंट्स पहा',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor:
                    const Color(0xFF263238),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          getText(
            en: 'Quick Actions',
            ta: 'விரைவு செயல்கள்',
            mr: 'जलद कृती',
          ),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _quickAction(
                icon: Icons.add_circle_outline,
                label: getText(
                  en: 'Add Crop',
                  ta: 'பயிர் சேர்க்க',
                  mr: 'पीक जोडा',
                ),
                color:
                    const Color(0xFF2E7D32),
                onTap: () async {
                  final result =
                      await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const AddCropLotScreen(),
                    ),
                  );

                  if (result == true) {
                    await refreshDashboard();
                  }
                },
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _quickAction(
                icon: Icons.local_offer_outlined,
                label: getText(
                  en: 'Offers',
                  ta: 'சலுகைகள்',
                  mr: 'ऑफर्स',
                ),
                color:
                    const Color(0xFFE67E22),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const OffersScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _quickAction(
                icon: Icons.help_outline,
                label: getText(
                  en: 'Support',
                  ta: 'உதவி',
                  mr: 'मदत',
                ),
                color:
                    const Color(0xFF1976D2),
                onTap: () {
                  _showComingSoon(
                    getText(
                      en:
                          'Support will be connected to the backend.',
                      ta:
                          'உதவி backend-ல் இணைக்கப்படும்.',
                      mr:
                          'मदत backend शी जोडली जाईल.',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 25,
            ),

            const SizedBox(height: 7),

            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CROPS PAGE
  // ============================================================

  Widget _buildCropsPage(
    AppLocalizations local,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _pageHeading(
              getText(
                en: 'My Crop Lots',
                ta: 'என் பயிர் தொகுப்புகள்',
                mr: 'माझे पिकांचे लॉट',
              ),
            ),

            const SizedBox(height: 15),

            if (loadingCrops)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (cropLots.isEmpty)
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Text(
                    getText(
                      en: 'No crop lots added',
                      ta: 'பயிர் தொகுப்பு இல்லை',
                      mr: 'पीक लॉट उपलब्ध नाही',
                    ),
                  ),
                ),
              )
            else
              Column(
                children:
                    cropLots.map((crop) {
                  return Container(
                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),
                    padding:
                        const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                      border: Border.all(
                        color:
                            Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFE8F5E9,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                          ),
                          child: const Icon(
                            Icons.grass,
                            color:
                                Color(0xFF2E7D32),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                crop["crop_name"] ??
                                    "Crop",
                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "${crop["quantity"] ?? 0} kg",
                                style: TextStyle(
                                  color: Colors
                                      .grey.shade600,
                                ),
                              ),

                              if (crop[
                                      "quality_grade"] !=
                                  null)
                                Text(
                                  "Grade: ${crop["quality_grade"]}",
                                  style: TextStyle(
                                    color: Colors
                                        .grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons
                              .arrow_forward_ios,
                          size: 16,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result =
                      await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const AddCropLotScreen(),
                    ),
                  );

                  if (result == true) {
                    await refreshDashboard();
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(
                  getText(
                    en: 'Create Crop Lot',
                    ta: 'பயிர் தொகுப்பை உருவாக்கவும்',
                    mr: 'पिकाचा लॉट तयार करा',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MARKET PAGE
  // ============================================================

  Widget _buildMarketPage(
    AppLocalizations local,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _pageHeading(
              getText(
                en: 'Market Intelligence',
                ta: 'சந்தை நுண்ணறிவு',
                mr: 'बाजार माहिती',
              ),
            ),

            const SizedBox(height: 7),

            Text(
              getText(
                en:
                    'Use AI to understand prices, trends and selling decisions.',
                ta:
                    'விலைகள், போக்குகள் மற்றும் விற்பனை முடிவுகளைப் புரிந்துகொள்ள AI-ஐ பயன்படுத்துங்கள்.',
                mr:
                    'किंमती, ट्रेंड आणि विक्री निर्णय समजून घेण्यासाठी AI वापरा.',
              ),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            _buildAiInsight(),

            const SizedBox(height: 20),

            _marketGraphCard(),

            const SizedBox(height: 20),

            _buildMarketSnapshot(),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(19),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.bar_chart_rounded,
                    color: Color(0xFF2E7D32),
                    size: 30,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      getText(
                        en:
                            'Market arrivals can influence price movement.',
                        ta:
                            'சந்தை வரத்துகள் விலை மாற்றத்தை பாதிக்கலாம்.',
                        mr:
                            'बाजारातील आवक किंमतीतील बदलावर परिणाम करू शकते.',
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                      ),
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

  Widget _marketGraphCard() {
    return Container(
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            getText(
              en: 'Market Price Trend',
              ta: 'சந்தை விலை போக்கு',
              mr: 'बाजार किंमत ट्रेंड',
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            getText(
              en: 'AI market intelligence',
              ta: 'AI சந்தை நுண்ணறிவு',
              mr: 'AI बाजार माहिती',
            ),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 18),

          Expanded(
            child: CustomPaint(
              painter: _TrendPainter(),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE
  // ============================================================

  Widget _buildProfilePage(
    AppLocalizations local,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Container(
              width: 88,
              height: 88,
              decoration:
                  const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFF2E7D32),
                size: 48,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              getText(
                en: 'Farmer Profile',
                ta: 'விவசாயி சுயவிவரம்',
                mr: 'शेतकरी प्रोफाइल',
              ),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              getText(
                en:
                    'Your farm and account information',
                ta:
                    'உங்கள் பண்ணை மற்றும் கணக்கு தகவல்கள்',
                mr:
                    'तुमच्या शेताची आणि खात्याची माहिती',
              ),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 24),

            _profileItem(
              Icons.person_outline,
              getText(
                en: 'Personal Information',
                ta: 'தனிப்பட்ட தகவல்',
                mr: 'वैयक्तिक माहिती',
              ),
            ),

            _profileItem(
              Icons.landscape_outlined,
              getText(
                en: 'Farm Details',
                ta: 'பண்ணை விவரங்கள்',
                mr: 'शेताची माहिती',
              ),
            ),

            _profileItem(
              Icons.account_balance_outlined,
              getText(
                en: 'Bank Details',
                ta: 'வங்கி விவரங்கள்',
                mr: 'बँक माहिती',
              ),
            ),

            _profileItem(
              Icons.notifications_none,
              getText(
                en: 'Notification Settings',
                ta: 'அறிவிப்பு அமைப்புகள்',
                mr: 'सूचना सेटिंग्ज',
              ),
            ),

            _profileItem(
              Icons.help_outline,
              getText(
                en: 'Help & Support',
                ta: 'உதவி & ஆதரவு',
                mr: 'मदत आणि समर्थन',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileItem(
    IconData icon,
    String title,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF2E7D32),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
        ),
        onTap: () {
          _showComingSoon(
            getText(
              en:
                  '$title will be connected later.',
              ta:
                  '$title பின்னர் இணைக்கப்படும்.',
              mr:
                  '$title नंतर जोडले जाईल.',
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // COMMON UI
  // ============================================================

  Widget _buildSectionHeader({
    required String title,
    required String action,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        TextButton(
          onPressed: onPressed,
          child: Text(
            action,
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _pageHeading(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _featureCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(21),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 13),

          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: onPressed,
              style:
                  OutlinedButton.styleFrom(
                foregroundColor: iconColor,
                side: BorderSide(
                  color: iconColor.withValues(
                    alpha: 0.35,
                  ),
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      height: 68,
      backgroundColor: Colors.white,
      elevation: 4,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      indicatorColor:
          const Color(0xFFE8F5E9),
      destinations: [
        NavigationDestination(
          icon: const Icon(
            Icons.home_outlined,
          ),
          selectedIcon: const Icon(
            Icons.home_rounded,
            color: Color(0xFF2E7D32),
          ),
          label: getText(
            en: 'Home',
            ta: 'முகப்பு',
            mr: 'होम',
          ),
        ),

        NavigationDestination(
          icon: const Icon(
            Icons.grass_outlined,
          ),
          selectedIcon: const Icon(
            Icons.grass_rounded,
            color: Color(0xFF2E7D32),
          ),
          label: getText(
            en: 'Crops',
            ta: 'பயிர்கள்',
            mr: 'पिके',
          ),
        ),

        NavigationDestination(
          icon: const Icon(
            Icons.insights_outlined,
          ),
          selectedIcon: const Icon(
            Icons.insights_rounded,
            color: Color(0xFF2E7D32),
          ),
          label: getText(
            en: 'Market',
            ta: 'சந்தை',
            mr: 'बाजार',
          ),
        ),

        NavigationDestination(
          icon: const Icon(
            Icons.receipt_long_outlined,
          ),
          selectedIcon: const Icon(
            Icons.receipt_long_rounded,
            color: Color(0xFF2E7D32),
          ),
          label: getText(
            en: 'Orders',
            ta: 'ஆர்டர்கள்',
            mr: 'ऑर्डर्स',
          ),
        ),

        NavigationDestination(
          icon: const Icon(
            Icons.person_outline_rounded,
          ),
          selectedIcon: const Icon(
            Icons.person_rounded,
            color: Color(0xFF2E7D32),
          ),
          label: getText(
            en: 'Profile',
            ta: 'சுயவிவரம்',
            mr: 'प्रोफाइल',
          ),
        ),
      ],
    );
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              25,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  getText(
                    en: 'Notifications',
                    ta: 'அறிவிப்புகள்',
                    mr: 'सूचना',
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                _notificationItem(
                  Icons.local_offer_outlined,
                  getText(
                    en:
                        'New buyer offers will appear here.',
                    ta:
                        'புதிய வாங்குபவர் சலுகைகள் இங்கே தோன்றும்.',
                    mr:
                        'नवीन खरेदीदार ऑफर्स येथे दिसतील.',
                  ),
                ),

                _notificationItem(
                  Icons.trending_up,
                  getText(
                    en:
                        'Market intelligence updates will appear here.',
                    ta:
                        'சந்தை நுண்ணறிவு புதுப்பிப்புகள் இங்கே தோன்றும்.',
                    mr:
                        'बाजार माहिती अपडेट्स येथे दिसतील.',
                  ),
                ),

                _notificationItem(
                  Icons.local_shipping_outlined,
                  getText(
                    en:
                        'Delivery updates will appear here.',
                    ta:
                        'டெலிவரி புதுப்பிப்புகள் இங்கே தோன்றும்.',
                    mr:
                        'डिलिव्हरी अपडेट्स येथे दिसतील.',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _notificationItem(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration:
                const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2E7D32),
              size: 19,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMING SOON
  // ============================================================

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }
}

// ============================================================
// SIMPLE MARKET TREND PAINTER
// ============================================================

class _TrendPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(
      0,
      size.height * 0.78,
    );

    path.lineTo(
      size.width * 0.15,
      size.height * 0.68,
    );

    path.lineTo(
      size.width * 0.30,
      size.height * 0.72,
    );

    path.lineTo(
      size.width * 0.43,
      size.height * 0.48,
    );

    path.lineTo(
      size.width * 0.57,
      size.height * 0.56,
    );

    path.lineTo(
      size.width * 0.70,
      size.height * 0.31,
    );

    path.lineTo(
      size.width * 0.84,
      size.height * 0.37,
    );

    path.lineTo(
      size.width,
      size.height * 0.13,
    );

    canvas.drawPath(
      path,
      paint,
    );

    final dotPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;

    final points = [
      Offset(
        0,
        size.height * 0.78,
      ),
      Offset(
        size.width * 0.15,
        size.height * 0.68,
      ),
      Offset(
        size.width * 0.30,
        size.height * 0.72,
      ),
      Offset(
        size.width * 0.43,
        size.height * 0.48,
      ),
      Offset(
        size.width * 0.57,
        size.height * 0.56,
      ),
      Offset(
        size.width * 0.70,
        size.height * 0.31,
      ),
      Offset(
        size.width * 0.84,
        size.height * 0.37,
      ),
      Offset(
        size.width,
        size.height * 0.13,
      ),
    ];

    for (final point in points) {
      canvas.drawCircle(
        point,
        4,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}