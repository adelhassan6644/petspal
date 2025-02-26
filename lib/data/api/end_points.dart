import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoints {
  static String domain = dotenv.env['DOMAIN_DEV'] ?? "";
  static String baseUrl = dotenv.env['BASE_URL_DEV'] ?? "";
  static String apiKey = dotenv.env['API_KEY'] ?? "";
  static chatPort(id) => '${dotenv.env['CHAT_PORT']}$id';
  static String googleMapsBaseUrl = dotenv.env['GOOGLE_MAPS_BASE_URL'] ?? "";
  static const String generalTopic = 'petspal';
  static specificTopic(id) => '$id';

  ///Auth
  static const String socialMediaAuth = 'social-login';
  static const String forgetPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String changePassword = 'change-password';
  static const String register = 'register';
  static const String logIn = 'login';
  static const String resend = 'resend-otp';
  static const String verifyOtp = 'verify-otp';
  static const String suspendAccount = 'suspend-account';
  static const String reactivateAccount = 'reactivate-account';

  ///User Profile
  static const String editProfile = 'update-profile';
  static const String profile = 'me';
  static const String bankInfo = 'bank_info';

  ///Home
  static const String banners = 'banners';

  ///Expertises
  static const String myCars = 'user-cars';

  ///Categories && Products
  static const String vendors = 'vendors';
  static const String brands = 'brands';
  static const String categories = 'categories';
  static const String products = 'products';
  static const String bestSellers = 'best_sellers';
  static productDetails(id) => 'product/$id';


  ///cities
  static const String cities = 'cities';

  ///addresses
  static const String addresses = 'addresses';

  ///Talents
  static const String talents = 'talents';

  ///Feedbacks
  static feedbacks(id) => 'users/$id/feedbacks';
  static const String sendFeedback = 'feedbacks';

  ///Talents
  static const String systemHiring = 'talent/system-hiring';

  ///Chats
  static const String createChat = 'chats';
  static const String chats = 'chats';
  static deleteChat(id) => 'chats/$id';
  static chatDetails(id) => 'chats/$id';
  static chatMessages(id) => 'chat-messages/$id';
  static const String uploadFile = 'upload-file';

  ///Notification
  static const String notifications = 'notifications';
  static readNotification(id) => 'notifications/$id';
  static deleteNotification(id) => 'notifications/$id';

  ///Create Request
  static const String createRequest = 'company/orders';
  static const String createCustomRequest = 'company/custom_requests';

  ///Requests&Details
  static const String companyRequests = 'company/orders';
  static const String talentRequests = 'talent/orders';
  static companyRequest(id) => 'company/orders/$id';
  static companyStaff(id) => 'company/orders/$id/talents';
  static talentRequest(id) => 'talent/orders/$id';

  ///Request Actions
  static acceptRequest(id) => 'talent/orders/$id/accept';
  static rejectRequest(id) => 'talent/orders/$id/reject';
  static confirmAttended(id) => 'talent/orders/$id/confirm-attend';
  static confirmStaffAttendance(id) => 'company/orders/$id/is-attend';
  static cancelRequest(userType, id) => '$userType/orders/$id/cancel';
  static requestStatus(type) => '$type/get-filter';
  static const String cancelReasons = 'cancel-reasons';

  ///Check Out
  static checkOutOrder(id) => 'company/orders/$id/check-out';
  static checkOutByBankTransfer(id) => 'company/orders/$id/pay-by-bank';
  static applyOrderCoupon(id) => 'company/orders/$id/check-coupon';

  ///Transactions
  static const String transactions = 'transactions';

  ///Cart
  static const String cart = 'cart';
  static const String addToCart = 'cart/add';
  static const String updateCart = 'update/cart/quantity';
  static const String removeFromCart = 'cart/remove';
  static const checkOutProduct = 'check-out';
  static const applyProductCoupon = 'check-coupon';



  ///Setting
  static const String settings = 'settings';
  static const String faqs = 'faqs';
  static const String whoUs = 'who-us';
  static const String contactUs = 'contact-us';
  static const String countries = 'countries';

  ///Share
  static shareRoute(route, id) => "$baseUrl$route/?id=$id";

  ///Upload File Service
  static const String uploadFileService = 'store_attachment';

  /// maps
  static const String geoCodeUrl = '/maps/api/geocode/';
  static const String autoComplete = '/maps/api/place/autocomplete/';
//https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyB_l2x6zgnLTF4MKxX3S4Df9urLN6vLNP0
//'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=n,&key=AIzaSyB_l2x6zgnLTF4MKxX3S4Df9urLN6vLNP0
}
