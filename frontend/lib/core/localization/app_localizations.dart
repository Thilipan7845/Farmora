import 'package:flutter/material.dart';
import 'language_controller.dart';


class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations(languageController.locale);
  }

  static const Map<String, Map<String, String>> _translations = {
    'en': {
      // Language
      'choose_language': 'Choose your language',
      'language_subtitle':
          'Select your preferred language to continue',
      'continue': 'Continue',

      // Login
      'welcome': 'Welcome to Farmora',
      'login_subtitle': 'Login to continue',
      'email': 'Email',
      'email_hint': 'Enter your email',
      'password': 'Password',
      'password_hint': 'Enter your password',
      'forgot_password': 'Forgot password?',
      'login': 'Login',
      'no_account': "Don't have an account?",
      'create_account': 'Create account',

      // Forgot password
      'forgot_title': 'Forgot Password',
      'forgot_subtitle':
          'Enter your email to reset your password',
      'send_reset': 'Send Reset Link',

      // Role selection
      'select_role': 'Select your role',
      'role_subtitle':
          'Choose how you want to use Farmora',
      'farmer': 'Farmer',
      'fpo': 'FPO',
      'buyer': 'Buyer',
      'farmer_description':
          'Sell your crops and get better market opportunities',
      'fpo_description':
          'Manage farmers and coordinate crop sales',
      'buyer_description':
          'Find crops and connect with farmers',

      // Terms
      'terms': 'Terms & Conditions',
      'privacy': 'Privacy Policy',
      'agree_terms':
          'I agree to the Terms & Conditions and Privacy Policy',

      // Validation
      'invalid_email': 'Please enter a valid email',
      'enter_email': 'Please enter your email',
      'enter_password': 'Please enter your password',
      'password_length':
          'Password must be at least 6 characters',

      // Register
      'register_title': 'Create your account',
      'register_subtitle':
          'Enter your details to create your Farmora account',
      'full_name': 'Full Name',
      'full_name_hint': 'Enter your full name',
      'mobile_number': 'Mobile Number',
      'mobile_hint': 'Enter your mobile number',
      'confirm_password': 'Confirm Password',
      'confirm_password_hint':
          'Re-enter your password',
      'create_account_button': 'Create Account',
      'enter_full_name': 'Please enter your full name',
      'enter_mobile': 'Please enter your mobile number',
      'valid_mobile':
          'Please enter a valid mobile number',
      'confirm_password_error':
          'Please confirm your password',
      'password_mismatch': 'Passwords do not match',
      'accept_terms_error':
          'Please accept the Terms & Conditions and Privacy Policy',
      'account_created':
          'Account creation will be connected to the backend soon',

      // Farmer dashboard
      'farmer_dashboard': 'Farmer Dashboard',
      'farmer_greeting': 'Welcome, Farmer!',
      'farmer_dashboard_subtitle':
          'Manage your crops and discover better market opportunities.',
      'add_crop_lot': 'Add Crop Lot',
      'my_crop_lots': 'My Crop Lots',
      'market': 'Market',
      'market_overview': 'Market Overview',
      'cotton': 'Cotton',
      'tomato': 'Tomato',
      'onion': 'Onion',
      'rising': 'Rising',
      'stable': 'Stable',
      'falling': 'Falling',
      'find_buyers': 'Find Buyers',

      // FPO dashboard
      'fpo_dashboard': 'FPO Dashboard',
      'fpo_greeting': 'Welcome, FPO!',
      'fpo_dashboard_subtitle':
          'Manage farmers and coordinate crop sales.',
      'farmers': 'Farmers',
      'crop_lots': 'Crop Lots',
      'offers': 'Offers',
      'orders': 'Orders',
      'manage_farmers': 'Manage Farmers',
      'view_crop_lots': 'View Crop Lots',
      'market_intelligence': 'Market Intelligence',
      'logistics': 'Logistics',

      // Buyer dashboard
      'buyer_dashboard': 'Buyer Dashboard',
      'buyer_greeting': 'Welcome, Buyer!',
      'buyer_dashboard_subtitle':
          'Find crops and connect with farmers.',
      'find_crop_lots': 'Find Crop Lots',
      'my_requirements': 'My Requirements',
      'my_offers': 'My Offers',
      'my_orders': 'My Orders',
      'requirements': 'Requirements',
    },

    'ta': {
      // Language
      'choose_language':
          'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்',
      'language_subtitle':
          'தொடர உங்கள் விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும்',
      'continue': 'தொடரவும்',

      // Login
      'welcome': 'Farmora-விற்கு வரவேற்கிறோம்',
      'login_subtitle': 'தொடர உள்நுழையவும்',
      'email': 'மின்னஞ்சல்',
      'email_hint': 'உங்கள் மின்னஞ்சலை உள்ளிடவும்',
      'password': 'கடவுச்சொல்',
      'password_hint': 'உங்கள் கடவுச்சொல்லை உள்ளிடவும்',
      'forgot_password':
          'கடவுச்சொல்லை மறந்துவிட்டீர்களா?',
      'login': 'உள்நுழைக',
      'no_account': 'கணக்கு இல்லையா?',
      'create_account': 'கணக்கை உருவாக்கவும்',

      // Forgot password
      'forgot_title':
          'கடவுச்சொல்லை மறந்துவிட்டீர்களா?',
      'forgot_subtitle':
          'கடவுச்சொல்லை மீட்டமைக்க உங்கள் மின்னஞ்சலை உள்ளிடவும்',
      'send_reset':
          'மீட்டமைப்பு இணைப்பை அனுப்பவும்',

      // Role selection
      'select_role': 'உங்கள் பங்கைத் தேர்ந்தெடுக்கவும்',
      'role_subtitle':
          'Farmora-வை எவ்வாறு பயன்படுத்த விரும்புகிறீர்கள் என்பதைத் தேர்ந்தெடுக்கவும்',
      'farmer': 'விவசாயி',
      'fpo': 'FPO',
      'buyer': 'வாங்குபவர்',
      'farmer_description':
          'உங்கள் பயிர்களை விற்று சிறந்த சந்தை வாய்ப்புகளைப் பெறுங்கள்',
      'fpo_description':
          'விவசாயிகளை நிர்வகித்து பயிர் விற்பனையை ஒருங்கிணைக்கவும்',
      'buyer_description':
          'பயிர்களைக் கண்டறிந்து விவசாயிகளுடன் இணையுங்கள்',

      // Terms
      'terms': 'விதிமுறைகள் மற்றும் நிபந்தனைகள்',
      'privacy': 'தனியுரிமைக் கொள்கை',
      'agree_terms':
          'விதிமுறைகள் மற்றும் நிபந்தனைகள் மற்றும் தனியுரிமைக் கொள்கையை ஏற்கிறேன்',

      // Validation
      'invalid_email':
          'சரியான மின்னஞ்சலை உள்ளிடவும்',
      'enter_email':
          'உங்கள் மின்னஞ்சலை உள்ளிடவும்',
      'enter_password':
          'உங்கள் கடவுச்சொல்லை உள்ளிடவும்',
      'password_length':
          'கடவுச்சொல் குறைந்தது 6 எழுத்துகள் இருக்க வேண்டும்',

      // Register
      'register_title': 'உங்கள் கணக்கை உருவாக்கவும்',
      'register_subtitle':
          'உங்கள் Farmora கணக்கை உருவாக்க உங்கள் விவரங்களை உள்ளிடவும்',
      'full_name': 'முழுப் பெயர்',
      'full_name_hint': 'உங்கள் முழுப் பெயரை உள்ளிடவும்',
      'mobile_number': 'மொபைல் எண்',
      'mobile_hint': 'உங்கள் மொபைல் எண்ணை உள்ளிடவும்',
      'confirm_password': 'கடவுச்சொல்லை உறுதிப்படுத்தவும்',
      'confirm_password_hint':
          'உங்கள் கடவுச்சொல்லை மீண்டும் உள்ளிடவும்',
      'create_account_button': 'கணக்கை உருவாக்கவும்',
      'enter_full_name':
          'உங்கள் முழுப் பெயரை உள்ளிடவும்',
      'enter_mobile':
          'உங்கள் மொபைல் எண்ணை உள்ளிடவும்',
      'valid_mobile':
          'சரியான மொபைல் எண்ணை உள்ளிடவும்',
      'confirm_password_error':
          'உங்கள் கடவுச்சொல்லை உறுதிப்படுத்தவும்',
      'password_mismatch':
          'கடவுச்சொற்கள் பொருந்தவில்லை',
      'accept_terms_error':
          'விதிமுறைகள் மற்றும் தனியுரிமைக் கொள்கையை ஏற்கவும்',
      'account_created':
          'கணக்கு உருவாக்கம் விரைவில் backend-உடன் இணைக்கப்படும்',

      // Farmer dashboard
      'farmer_dashboard': 'விவசாயி டாஷ்போர்டு',
      'farmer_greeting': 'வணக்கம், விவசாயி!',
      'farmer_dashboard_subtitle':
          'உங்கள் பயிர்களை நிர்வகித்து சிறந்த சந்தை வாய்ப்புகளைக் கண்டறியுங்கள்.',
      'add_crop_lot': 'பயிர் லாட்டைச் சேர்க்கவும்',
      'my_crop_lots': 'எனது பயிர் லாட்டுகள்',
      'market': 'சந்தை',
      'market_overview': 'சந்தை நிலவரம்',
      'cotton': 'பருத்தி',
      'tomato': 'தக்காளி',
      'onion': 'வெங்காயம்',
      'rising': 'உயர்ந்து வருகிறது',
      'stable': 'நிலையானது',
      'falling': 'குறைந்து வருகிறது',
      'find_buyers': 'வாங்குபவர்களைக் கண்டறியவும்',

      // FPO dashboard
      'fpo_dashboard': 'FPO டாஷ்போர்டு',
      'fpo_greeting': 'வரவேற்கிறோம், FPO!',
      'fpo_dashboard_subtitle':
          'விவசாயிகளை நிர்வகித்து பயிர் விற்பனையை ஒருங்கிணைக்கவும்.',
      'farmers': 'விவசாயிகள்',
      'crop_lots': 'பயிர் லாட்டுகள்',
      'offers': 'சலுகைகள்',
      'orders': 'ஆர்டர்கள்',
      'manage_farmers': 'விவசாயிகளை நிர்வகிக்கவும்',
      'view_crop_lots': 'பயிர் லாட்டுகளைப் பார்க்கவும்',
      'market_intelligence': 'சந்தை நுண்ணறிவு',
      'logistics': 'போக்குவரத்து',

      // Buyer dashboard
      'buyer_dashboard': 'வாங்குபவர் டாஷ்போர்டு',
      'buyer_greeting': 'வரவேற்கிறோம், வாங்குபவரே!',
      'buyer_dashboard_subtitle':
          'பயிர்களைக் கண்டறிந்து விவசாயிகளுடன் இணையுங்கள்.',
      'find_crop_lots': 'பயிர் லாட்டுகளைக் கண்டறியவும்',
      'my_requirements': 'எனது தேவைகள்',
      'my_offers': 'எனது சலுகைகள்',
      'my_orders': 'எனது ஆர்டர்கள்',
      'requirements': 'தேவைகள்',
    },

    'mr': {
      // Language
      'choose_language': 'तुमची भाषा निवडा',
      'language_subtitle':
          'पुढे जाण्यासाठी तुमची पसंतीची भाषा निवडा',
      'continue': 'पुढे चला',

      // Login
      'welcome': 'Farmora मध्ये आपले स्वागत आहे',
      'login_subtitle':
          'पुढे जाण्यासाठी लॉगिन करा',
      'email': 'ईमेल',
      'email_hint':
          'तुमचा ईमेल प्रविष्ट करा',
      'password': 'पासवर्ड',
      'password_hint':
          'तुमचा पासवर्ड प्रविष्ट करा',
      'forgot_password':
          'पासवर्ड विसरलात?',
      'login': 'लॉगिन',
      'no_account': 'खाते नाही?',
      'create_account': 'खाते तयार करा',

      // Forgot password
      'forgot_title': 'पासवर्ड विसरलात?',
      'forgot_subtitle':
          'पासवर्ड रीसेट करण्यासाठी तुमचा ईमेल प्रविष्ट करा',
      'send_reset':
          'रीसेट लिंक पाठवा',

      // Role selection
      'select_role': 'तुमची भूमिका निवडा',
      'role_subtitle':
          'तुम्हाला Farmora कसे वापरायचे आहे ते निवडा',
      'farmer': 'शेतकरी',
      'fpo': 'FPO',
      'buyer': 'खरेदीदार',
      'farmer_description':
          'तुमची पिके विकून चांगल्या बाजारपेठेच्या संधी मिळवा',
      'fpo_description':
          'शेतकऱ्यांचे व्यवस्थापन करा आणि पीक विक्रीचे समन्वय करा',
      'buyer_description':
          'पिके शोधा आणि शेतकऱ्यांशी संपर्क साधा',

      // Terms
      'terms': 'अटी व शर्ती',
      'privacy': 'गोपनीयता धोरण',
      'agree_terms':
          'मी अटी व शर्ती आणि गोपनीयता धोरण मान्य करतो/करते',

      // Validation
      'invalid_email':
          'कृपया योग्य ईमेल प्रविष्ट करा',
      'enter_email':
          'कृपया तुमचा ईमेल प्रविष्ट करा',
      'enter_password':
          'कृपया तुमचा पासवर्ड प्रविष्ट करा',
      'password_length':
          'पासवर्ड किमान 6 अक्षरांचा असावा',

      // Register
      'register_title':
          'तुमचे खाते तयार करा',
      'register_subtitle':
          'तुमचे Farmora खाते तयार करण्यासाठी तुमचे तपशील प्रविष्ट करा',
      'full_name': 'पूर्ण नाव',
      'full_name_hint':
          'तुमचे पूर्ण नाव प्रविष्ट करा',
      'mobile_number': 'मोबाईल नंबर',
      'mobile_hint':
          'तुमचा मोबाईल नंबर प्रविष्ट करा',
      'confirm_password':
          'पासवर्डची पुष्टी करा',
      'confirm_password_hint':
          'तुमचा पासवर्ड पुन्हा प्रविष्ट करा',
      'create_account_button':
          'खाते तयार करा',
      'enter_full_name':
          'कृपया तुमचे पूर्ण नाव प्रविष्ट करा',
      'enter_mobile':
          'कृपया तुमचा मोबाईल नंबर प्रविष्ट करा',
      'valid_mobile':
          'कृपया योग्य मोबाईल नंबर प्रविष्ट करा',
      'confirm_password_error':
          'कृपया तुमच्या पासवर्डची पुष्टी करा',
      'password_mismatch':
          'पासवर्ड जुळत नाहीत',
      'accept_terms_error':
          'कृपया अटी व शर्ती आणि गोपनीयता धोरण स्वीकारा',
      'account_created':
          'खाते तयार करण्याची प्रक्रिया लवकरच backend शी जोडली जाईल',

      // Farmer dashboard
      'farmer_dashboard':
          'शेतकरी डॅशबोर्ड',
      'farmer_greeting':
          'स्वागत आहे, शेतकरी!',
      'farmer_dashboard_subtitle':
          'तुमची पिके व्यवस्थापित करा आणि चांगल्या बाजारपेठेच्या संधी शोधा.',
      'add_crop_lot':
          'पीक लॉट जोडा',
      'my_crop_lots':
          'माझे पीक लॉट',
      'market': 'बाजार',
      'market_overview':
          'बाजाराचा आढावा',
      'cotton': 'कापूस',
      'tomato': 'टोमॅटो',
      'onion': 'कांदा',
      'rising': 'वाढत आहे',
      'stable': 'स्थिर',
      'falling': 'घसरत आहे',
      'find_buyers':
          'खरेदीदार शोधा',

      // FPO dashboard
      'fpo_dashboard':
          'FPO डॅशबोर्ड',
      'fpo_greeting':
          'स्वागत आहे, FPO!',
      'fpo_dashboard_subtitle':
          'शेतकऱ्यांचे व्यवस्थापन करा आणि पीक विक्रीचे समन्वय करा.',
      'farmers': 'शेतकरी',
      'crop_lots': 'पीक लॉट',
      'offers': 'ऑफर्स',
      'orders': 'ऑर्डर्स',
      'manage_farmers':
          'शेतकरी व्यवस्थापित करा',
      'view_crop_lots':
          'पीक लॉट पहा',
      'market_intelligence':
          'बाजारपेठेची माहिती',
      'logistics': 'लॉजिस्टिक्स',

      // Buyer dashboard
      'buyer_dashboard':
          'खरेदीदार डॅशबोर्ड',
      'buyer_greeting':
          'स्वागत आहे, खरेदीदार!',
      'buyer_dashboard_subtitle':
          'पिके शोधा आणि शेतकऱ्यांशी संपर्क साधा.',
      'find_crop_lots':
          'पीक लॉट शोधा',
      'my_requirements':
          'माझ्या आवश्यकता',
      'my_offers':
          'माझ्या ऑफर्स',
      'my_orders':
          'माझ्या ऑर्डर्स',
      'requirements':
          'आवश्यकता',
    },
  };

  String translate(String key) {
    return _translations[locale.languageCode]?[key] ??
        _translations['en']![key] ??
        key;
  }

  String get chooseLanguage =>
      translate('choose_language');

  String get languageSubtitle =>
      translate('language_subtitle');

  String get continueText =>
      translate('continue');

  String get welcome =>
      translate('welcome');

  String get loginSubtitle =>
      translate('login_subtitle');

  String get email =>
      translate('email');

  String get emailHint =>
      translate('email_hint');

  String get password =>
      translate('password');

  String get passwordHint =>
      translate('password_hint');

  String get forgotPassword =>
      translate('forgot_password');

  String get login =>
      translate('login');

  String get noAccount =>
      translate('no_account');

  String get createAccount =>
      translate('create_account');

  String get forgotTitle =>
      translate('forgot_title');

  String get forgotSubtitle =>
      translate('forgot_subtitle');

  String get sendReset =>
      translate('send_reset');

  String get selectRole =>
      translate('select_role');

  String get roleSubtitle =>
      translate('role_subtitle');

  String get farmer =>
      translate('farmer');

  String get fpo =>
      translate('fpo');

  String get buyer =>
      translate('buyer');

  String get farmerDescription =>
      translate('farmer_description');

  String get fpoDescription =>
      translate('fpo_description');

  String get buyerDescription =>
      translate('buyer_description');

  String get terms =>
      translate('terms');

  String get privacy =>
      translate('privacy');

  String get agreeTerms =>
      translate('agree_terms');

  String get invalidEmail =>
      translate('invalid_email');

  String get enterEmail =>
      translate('enter_email');

  String get enterPassword =>
      translate('enter_password');

  String get passwordLength =>
      translate('password_length');

  // Register
  String get registerTitle =>
      translate('register_title');

  String get registerSubtitle =>
      translate('register_subtitle');

  String get fullName =>
      translate('full_name');

  String get fullNameHint =>
      translate('full_name_hint');

  String get mobileNumber =>
      translate('mobile_number');

  String get mobileHint =>
      translate('mobile_hint');

  String get confirmPassword =>
      translate('confirm_password');

  String get confirmPasswordHint =>
      translate('confirm_password_hint');

  String get createAccountButton =>
      translate('create_account_button');

  String get enterFullName =>
      translate('enter_full_name');

  String get enterMobile =>
      translate('enter_mobile');

  String get validMobile =>
      translate('valid_mobile');

  String get confirmPasswordError =>
      translate('confirm_password_error');

  String get passwordMismatch =>
      translate('password_mismatch');

  String get acceptTermsError =>
      translate('accept_terms_error');

  String get accountCreated =>
      translate('account_created');

  // Farmer dashboard
  String get farmerDashboard =>
      translate('farmer_dashboard');

  String get farmerGreeting =>
      translate('farmer_greeting');

  String get farmerDashboardSubtitle =>
      translate('farmer_dashboard_subtitle');

  String get addCropLot =>
      translate('add_crop_lot');

  String get myCropLots =>
      translate('my_crop_lots');

  String get market =>
      translate('market');

  String get marketOverview =>
      translate('market_overview');

  String get cotton =>
      translate('cotton');

  String get tomato =>
      translate('tomato');

  String get onion =>
      translate('onion');

  String get rising =>
      translate('rising');

  String get stable =>
      translate('stable');

  String get falling =>
      translate('falling');

  String get findBuyers =>
      translate('find_buyers');

  // FPO dashboard
  String get fpoDashboard =>
      translate('fpo_dashboard');

  String get fpoGreeting =>
      translate('fpo_greeting');

  String get fpoDashboardSubtitle =>
      translate('fpo_dashboard_subtitle');

  String get farmers =>
      translate('farmers');

  String get cropLots =>
      translate('crop_lots');

  String get offers =>
      translate('offers');

  String get orders =>
      translate('orders');

  String get manageFarmers =>
      translate('manage_farmers');

  String get viewCropLots =>
      translate('view_crop_lots');

  String get marketIntelligence =>
      translate('market_intelligence');

  String get logistics =>
      translate('logistics');

  // Buyer dashboard
  String get buyerDashboard =>
      translate('buyer_dashboard');

  String get buyerGreeting =>
      translate('buyer_greeting');

  String get buyerDashboardSubtitle =>
      translate('buyer_dashboard_subtitle');

  String get findCropLots =>
      translate('find_crop_lots');

  String get myRequirements =>
      translate('my_requirements');

  String get myOffers =>
      translate('my_offers');

  String get myOrders =>
      translate('my_orders');

  String get requirements =>
      translate('requirements');
}