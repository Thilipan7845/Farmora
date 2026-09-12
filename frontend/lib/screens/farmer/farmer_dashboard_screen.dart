import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() =>
      _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState
    extends State<FarmerDashboardScreen> {
  int _selectedIndex = 0;

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
          _buildOrdersPage(local),
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
        onRefresh: () async {
          await Future.delayed(
            const Duration(milliseconds: 600),
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
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
              color: Colors.white.withValues(alpha: 0.75),
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
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.inventory_2_outlined,
            value: '5',
            label: getText(
              en: 'Crop Lots',
              ta: 'பயிர் தொகுப்புகள்',
              mr: 'पिकांचे लॉट',
            ),
            iconBackground: const Color(0xFFE8F5E9),
            iconColor: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.local_offer_outlined,
            value: '2',
            label: getText(
              en: 'Offers',
              ta: 'சலுகைகள்',
              mr: 'ऑफर्स',
            ),
            iconBackground: const Color(0xFFFFF3E0),
            iconColor: const Color(0xFFE67E22),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.shopping_bag_outlined,
            value: '1',
            label: getText(
              en: 'Orders',
              ta: 'ஆர்டர்கள்',
              mr: 'ऑर्डर्स',
            ),
            iconBackground: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF1976D2),
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
      padding: const EdgeInsets.fromLTRB(11, 13, 8, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(11),
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
            color: const Color(0xFF2E7D32).withValues(
              alpha: 0.18,
            ),
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
                  borderRadius: BorderRadius.circular(13),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius: BorderRadius.circular(20),
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
            getText(
              en: 'Cotton',
              ta: 'பருத்தி',
              mr: 'कापूस',
            ),
            style: TextStyle(
              color: Colors.white.withValues(
                alpha: 0.8,
              ),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 5),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              const Text(
                '₹7,200',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  getText(
                    en: 'Current',
                    ta: 'தற்போதைய',
                    mr: 'सध्याची',
                  ),
                  style: TextStyle(
                    color: Colors.white.withValues(
                      alpha: 0.75,
                    ),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: Color(0xFFB9F6CA),
                size: 19,
              ),
              const SizedBox(width: 4),
              Text(
                getText(
                  en: 'Predicted ₹7,450 • Rising',
                  ta: 'கணிப்பு ₹7,450 • உயர்வு',
                  mr: 'अंदाज ₹7,450 • वाढ',
                ),
                style: const TextStyle(
                  color: Color(0xFFB9F6CA),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  color: Colors.white,
                  size: 21,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    getText(
                      en:
                          'Recommendation: WAIT for a better price',
                      ta:
                          'பரிந்துரை: நல்ல விலைக்காக காத்திருக்கவும்',
                      mr:
                          'शिफारस: चांगल्या किमतीसाठी थांबा',
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
                setState(() {
                  _selectedIndex = 2;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Colors.white.withValues(
                    alpha: 0.5,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
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
  // MY CROPS
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
          _cropRow(
            icon: Icons.grass_rounded,
            crop: getText(
              en: 'Cotton',
              ta: 'பருத்தி',
              mr: 'कापूस',
            ),
            quantity: '500 kg',
            status: getText(
              en: 'Available',
              ta: 'கிடைக்கிறது',
              mr: 'उपलब्ध',
            ),
            statusColor: const Color(0xFF2E7D32),
          ),
          Divider(
            height: 20,
            color: Colors.grey.shade200,
          ),
          _cropRow(
            icon: Icons.circle,
            crop: getText(
              en: 'Tomato',
              ta: 'தக்காளி',
              mr: 'टोमॅटो',
            ),
            quantity: '300 kg',
            status: getText(
              en: '2 Offers',
              ta: '2 சலுகைகள்',
              mr: '2 ऑफर्स',
            ),
            statusColor: const Color(0xFFE67E22),
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
            borderRadius: BorderRadius.circular(13),
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
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
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
            en: 'Cotton',
            ta: 'பருத்தி',
            mr: 'कापूस',
          ),
          price: '₹7,200',
          trend: getText(
            en: 'Rising',
            ta: 'உயர்வு',
            mr: 'वाढ',
          ),
          icon: Icons.trending_up_rounded,
          iconColor: const Color(0xFF2E7D32),
        ),
        const SizedBox(height: 9),
        _marketRow(
          crop: getText(
            en: 'Tomato',
            ta: 'தக்காளி',
            mr: 'टोमॅटो',
          ),
          price: '₹2,800',
          trend: getText(
            en: 'Stable',
            ta: 'நிலையானது',
            mr: 'स्थिर',
          ),
          icon: Icons.trending_flat_rounded,
          iconColor: const Color(0xFFF9A825),
        ),
        const SizedBox(height: 9),
        _marketRow(
          crop: getText(
            en: 'Onion',
            ta: 'வெங்காயம்',
            mr: 'कांदा',
          ),
          price: '₹3,100',
          trend: getText(
            en: 'Falling',
            ta: 'சரிவு',
            mr: 'घसरण',
          ),
          icon: Icons.trending_down_rounded,
          iconColor: const Color(0xFFD32F2F),
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
              borderRadius: BorderRadius.circular(13),
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
              fontSize: 15,
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
        _showComingSoon(
          getText(
            en: 'Buyer matching will be connected to the backend.',
            ta: 'வாங்குபவர் matching backend-ல் இணைக்கப்படும்.',
            mr: 'खरेदीदार matching backend शी जोडले जाईल.',
          ),
        );
      },
    );
  }

  // ============================================================
  // OFFERS
  // ============================================================

  Widget _buildOffersCard() {
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
            'You have 2 active buyer offers. Compare or negotiate before accepting.',
        ta:
            'உங்களிடம் 2 வாங்குபவர் சலுகைகள் உள்ளன. ஏற்கும் முன் ஒப்பிட்டு பேச்சுவார்த்தை நடத்துங்கள்.',
        mr:
            'तुमच्याकडे 2 सक्रिय खरेदीदार ऑफर्स आहेत. स्वीकारण्यापूर्वी तुलना किंवा वाटाघाटी करा.',
      ),
      buttonText: getText(
        en: 'View Offers',
        ta: 'சலுகைகளைப் பார்க்கவும்',
        mr: 'ऑफर्स पहा',
      ),
      onPressed: () {
        _showComingSoon(
          getText(
            en: 'Offers screen will be connected to the backend.',
            ta: 'சலுகைகள் screen backend-ல் இணைக்கப்படும்.',
            mr: 'ऑफर्स स्क्रीन backend शी जोडली जाईल.',
          ),
        );
      },
    );
  }

  // ============================================================
  // DELIVERY / OSM READY
  // ============================================================

  Widget _buildDeliveryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  getText(
                    en: 'In Transit',
                    ta: 'வழியில்',
                    mr: 'मार्गावर',
                  ),
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

          Text(
            getText(
              en: 'Order #FM1024 • Cotton • 500 kg',
              ta: 'ஆர்டர் #FM1024 • பருத்தி • 500 கிலோ',
              mr: 'ऑर्डर #FM1024 • कापूस • 500 किलो',
            ),
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 15),

          _deliveryTimeline(),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                _showMapMessage();
              },
              icon: const Icon(
                Icons.map_outlined,
                size: 19,
              ),
              label: Text(
                getText(
                  en: 'Track on Map',
                  ta: 'வரைபடத்தில் கண்காணிக்கவும்',
                  mr: 'नकाशावर ट्रॅक करा',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
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

  Widget _deliveryTimeline() {
    final steps = [
      getText(
        en: 'Order Confirmed',
        ta: 'ஆர்டர் உறுதி செய்யப்பட்டது',
        mr: 'ऑर्डर निश्चित',
      ),
      getText(
        en: 'Pickup Scheduled',
        ta: 'Pickup திட்டமிடப்பட்டது',
        mr: 'Pickup नियोजित',
      ),
      getText(
        en: 'Crop Picked Up',
        ta: 'பயிர் எடுத்துச் செல்லப்பட்டது',
        mr: 'पीक उचलले',
      ),
      getText(
        en: 'In Transit',
        ta: 'வழியில் உள்ளது',
        mr: 'मार्गावर',
      ),
      getText(
        en: 'Delivered',
        ta: 'வழங்கப்பட்டது',
        mr: 'वितरित',
      ),
    ];

    return Column(
      children: List.generate(
        steps.length,
        (index) {
          final completed = index <= 3;
          final current = index == 3;

          return Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: completed
                          ? const Color(0xFF1976D2)
                          : Colors.grey.shade300,
                    ),
                    child: completed
                        ? const Icon(
                            Icons.check,
                            size: 11,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  if (index < steps.length - 1)
                    Container(
                      width: 2,
                      height: 18,
                      color: completed
                          ? const Color(0xFF90CAF9)
                          : Colors.grey.shade300,
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Padding(
                padding:
                    const EdgeInsets.only(top: 0),
                child: Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: current
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: current
                        ? const Color(0xFF1976D2)
                        : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
                    en: 'Expected Net Realisation',
                    ta: 'எதிர்பார்க்கப்படும் நிகர வருவாய்',
                    mr: 'अपेक्षित निव्वळ प्राप्ती',
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

          const Text(
            '₹34,200',
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            getText(
              en:
                  'After estimated transport, storage and other costs',
              ta:
                  'போக்குவரத்து, சேமிப்பு மற்றும் பிற செலவுகளுக்குப் பிறகு',
              mr:
                  'वाहतूक, साठवणूक आणि इतर खर्चानंतर',
            ),
            style: TextStyle(
              color: Colors.white.withValues(
                alpha: 0.65,
              ),
              fontSize: 11.5,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _costItem(
                getText(
                  en: 'Sale',
                  ta: 'விற்பனை',
                  mr: 'विक्री',
                ),
                '₹37,000',
              ),
              _costItem(
                getText(
                  en: 'Transport',
                  ta: 'போக்குவரத்து',
                  mr: 'वाहतूक',
                ),
                '-₹2,000',
              ),
              _costItem(
                getText(
                  en: 'Storage',
                  ta: 'சேமிப்பு',
                  mr: 'साठवणूक',
                ),
                '-₹500',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _costItem(
    String title,
    String value,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(
                alpha: 0.55,
              ),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
                color: const Color(0xFF2E7D32),
                onTap: _showAddCropMessage,
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
                color: const Color(0xFFE67E22),
                onTap: () {
                  _showComingSoon(
                    getText(
                      en: 'Offers screen is ready for backend integration.',
                      ta: 'சலுகைகள் screen backend integration-க்கு தயாராக உள்ளது.',
                      mr: 'ऑफर्स स्क्रीन backend integration साठी तयार आहे.',
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
                color: const Color(0xFF1976D2),
                onTap: () {
                  _showComingSoon(
                    getText(
                      en: 'Support will be connected to the backend.',
                      ta: 'உதவி backend-ல் இணைக்கப்படும்.',
                      mr: 'मदत backend शी जोडली जाईल.',
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
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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

  Widget _buildCropsPage(AppLocalizations local) {
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

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _showAddCropMessage,
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
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            _largeCropCard(
              crop: getText(
                en: 'Cotton',
                ta: 'பருத்தி',
                mr: 'कापूस',
              ),
              variety: 'MCU-5',
              quantity: '500 kg',
              grade: 'Grade A',
              price: '₹7,500',
              status: getText(
                en: 'Available',
                ta: 'கிடைக்கிறது',
                mr: 'उपलब्ध',
              ),
              color: const Color(0xFF2E7D32),
            ),

            const SizedBox(height: 12),

            _largeCropCard(
              crop: getText(
                en: 'Tomato',
                ta: 'தக்காளி',
                mr: 'टोमॅटो',
              ),
              variety: 'Hybrid',
              quantity: '300 kg',
              grade: 'Grade A',
              price: '₹2,900',
              status: getText(
                en: 'Offers Received',
                ta: 'சலுகைகள் வந்துள்ளன',
                mr: 'ऑफर्स प्राप्त',
              ),
              color: const Color(0xFFE67E22),
            ),

            const SizedBox(height: 12),

            _largeCropCard(
              crop: getText(
                en: 'Onion',
                ta: 'வெங்காயம்',
                mr: 'कांदा',
              ),
              variety: 'Nashik Red',
              quantity: '800 kg',
              grade: 'Grade B',
              price: '₹3,000',
              status: getText(
                en: 'Sold',
                ta: 'விற்கப்பட்டது',
                mr: 'विकले',
              ),
              color: const Color(0xFF6A1B9A),
            ),
          ],
        ),
      ),
    );
  }

  Widget _largeCropCard({
    required String crop,
    required String variety,
    required String quantity,
    required String grade,
    required String price,
    required String status,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.grass_rounded,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        crop,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '$variety • $quantity • $grade',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MARKET PAGE
  // ============================================================

  Widget _buildMarketPage(AppLocalizations local) {
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
                    'Understand prices, trends and market movement before selling.',
                ta:
                    'விற்பனை செய்வதற்கு முன் விலை, போக்கு மற்றும் சந்தை மாற்றத்தைப் புரிந்து கொள்ளுங்கள்.',
                mr:
                    'विक्री करण्यापूर्वी किंमत, ट्रेंड आणि बाजारातील बदल समजून घ्या.',
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
              padding: const EdgeInsets.all(17),
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
                        fontWeight: FontWeight.w600,
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
        borderRadius: BorderRadius.circular(20),
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
              en: 'Cotton Price Trend',
              ta: 'பருத்தி விலை போக்கு',
              mr: 'कापूस किंमत ट्रेंड',
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            getText(
              en: 'Last 7 days',
              ta: 'கடந்த 7 நாட்கள்',
              mr: 'गेल्या 7 दिवस',
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
  // ORDERS PAGE
  // ============================================================

  Widget _buildOrdersPage(AppLocalizations local) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _pageHeading(
              getText(
                en: 'Orders',
                ta: 'ஆர்டர்கள்',
                mr: 'ऑर्डर्स',
              ),
            ),

            const SizedBox(height: 16),

            _orderCard(
              orderNumber: '#FM1024',
              buyer: 'ABC Textiles',
              crop: getText(
                en: 'Cotton • 500 kg',
                ta: 'பருத்தி • 500 கிலோ',
                mr: 'कापूस • 500 किलो',
              ),
              amount: '₹37,000',
              status: getText(
                en: 'In Transit',
                ta: 'வழியில்',
                mr: 'मार्गावर',
              ),
              statusColor: const Color(0xFF1976D2),
            ),

            const SizedBox(height: 12),

            _orderCard(
              orderNumber: '#FM1019',
              buyer: 'Sri Traders',
              crop: getText(
                en: 'Onion • 800 kg',
                ta: 'வெங்காயம் • 800 கிலோ',
                mr: 'कांदा • 800 किलो',
              ),
              amount: '₹24,800',
              status: getText(
                en: 'Delivered',
                ta: 'வழங்கப்பட்டது',
                mr: 'वितरित',
              ),
              statusColor: const Color(0xFF2E7D32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderCard({
    required String orderNumber,
    required String buyer,
    required String crop,
    required String amount,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                color: Color(0xFF2E7D32),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Order $orderNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
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
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _detailLine(
            getText(
              en: 'Buyer',
              ta: 'வாங்குபவர்',
              mr: 'खरेदीदार',
            ),
            buyer,
          ),
          _detailLine(
            getText(
              en: 'Crop',
              ta: 'பயிர்',
              mr: 'पीक',
            ),
            crop,
          ),
          _detailLine(
            getText(
              en: 'Order Value',
              ta: 'ஆர்டர் மதிப்பு',
              mr: 'ऑर्डर मूल्य',
            ),
            amount,
          ),
        ],
      ),
    );
  }

  Widget _detailLine(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE PAGE
  // ============================================================

  Widget _buildProfilePage(AppLocalizations local) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
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
                en: 'Your farm and account information',
                ta: 'உங்கள் பண்ணை மற்றும் கணக்கு தகவல்கள்',
                mr: 'तुमच्या शेताची आणि खात्याची माहिती',
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              en: '$title will be connected later.',
              ta: '$title பின்னர் இணைக்கப்படும்.',
              mr: '$title नंतर जोडले जाईल.',
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
        borderRadius: BorderRadius.circular(21),
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
                  borderRadius: BorderRadius.circular(14),
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
              style: OutlinedButton.styleFrom(
                foregroundColor: iconColor,
                side: BorderSide(
                  color: iconColor.withValues(
                    alpha: 0.35,
                  ),
                ),
                shape: RoundedRectangleBorder(
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
      indicatorColor: const Color(0xFFE8F5E9),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
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
          icon: const Icon(Icons.grass_outlined),
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
          icon: const Icon(Icons.insights_outlined),
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
          icon: const Icon(Icons.receipt_long_outlined),
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
          icon: const Icon(Icons.person_outline_rounded),
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
  // ACTIONS
  // ============================================================

  void _showAddCropMessage() {
    _showComingSoon(
      getText(
        en:
            'Create Crop Lot screen will be connected next.',
        ta:
            'பயிர் தொகுப்பு உருவாக்கும் screen அடுத்ததாக இணைக்கப்படும்.',
        mr:
            'पिकाचा लॉट तयार करण्याची स्क्रीन पुढे जोडली जाईल.',
      ),
    );
  }

  void _showMapMessage() {
    _showComingSoon(
      getText(
        en:
            'OpenStreetMap delivery tracking will be connected here.',
        ta:
            'OpenStreetMap delivery tracking இங்கே இணைக்கப்படும்.',
        mr:
            'OpenStreetMap delivery tracking येथे जोडले जाईल.',
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _notificationItem(
                  Icons.local_offer_outlined,
                  getText(
                    en:
                        'New buyer offer received for Cotton.',
                    ta:
                        'பருத்திக்கு புதிய வாங்குபவர் சலுகை வந்துள்ளது.',
                    mr:
                        'कापसासाठी नवीन खरेदीदार ऑफर आली आहे.',
                  ),
                ),
                _notificationItem(
                  Icons.trending_up,
                  getText(
                    en:
                        'Cotton price is showing an upward trend.',
                    ta:
                        'பருத்தி விலை உயர்ந்து வருகிறது.',
                    mr:
                        'कापसाच्या किमतीत वाढ होत आहे.',
                  ),
                ),
                _notificationItem(
                  Icons.local_shipping_outlined,
                  getText(
                    en:
                        'Your pickup has been scheduled.',
                    ta:
                        'உங்கள் pickup திட்டமிடப்பட்டுள்ளது.',
                    mr:
                        'तुमचा pickup नियोजित झाला आहे.',
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
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
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

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
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

    path.moveTo(0, size.height * 0.78);
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

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;

    final points = [
      Offset(0, size.height * 0.78),
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
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}