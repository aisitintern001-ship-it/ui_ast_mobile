import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class AppState extends ChangeNotifier {
    // Attendance: persistent time-in state
    bool _hasCurrentTimeIn = false;
  DateTime? _currentTimeInAt;
    bool get hasCurrentTimeIn => _hasCurrentTimeIn;
  DateTime? get currentTimeInAt => _currentTimeInAt;
    void setHasCurrentTimeIn(bool value) {
      _hasCurrentTimeIn = value;
    if (value) {
      _currentTimeInAt ??= DateTime.now();
    } else {
      _currentTimeInAt = null;
    }
    notifyListeners();
  }

  void markTimeIn([DateTime? at]) {
    _hasCurrentTimeIn = true;
    _currentTimeInAt = at ?? DateTime.now();
    notifyListeners();
  }

  void markTimeOut() {
    _hasCurrentTimeIn = false;
    _currentTimeInAt = null;
      notifyListeners();
    }
  // Theme color for header
  Color _headerColor = const Color(0xFF2563EB);
  Color get headerColor => _headerColor;

  // Current user
  UserModel _currentUser = MockData.currentUser;
  UserModel get currentUser => _currentUser;
  String _activeAccountKey = MockData.currentUser.email;

  static const String _profileNameKey = 'profile_name';
  static const String _profileEmailKey = 'profile_email';
  static const String _profilePhoneKey = 'profile_phone';
  static const String _profileJobTitleKey = 'profile_job_title';
  static const String _profileDepartmentKey = 'profile_department';
  static const String _profileLocationKey = 'profile_location';
  static const String _profilePhotoBase64Key = 'profile_photo_base64';

  String _profileName = MockData.currentUser.name;
  String _profileEmail = MockData.currentUser.email;
  String _profilePhone = '+61 400 123 456';
  String _profileJobTitle = 'Farm Manager';
  String _profileDepartment = 'Operations';
  String _profileLocation = 'Sydney, Australia';
  String? _profilePhotoBase64;

  String get profileName => _profileName;
  String get profileEmail => _profileEmail;
  String get profilePhone => _profilePhone;
  String get profileJobTitle => _profileJobTitle;
  String get profileDepartment => _profileDepartment;
  String get profileLocation => _profileLocation;
  String? get profilePhotoBase64 => _profilePhotoBase64;

  // Check if user is admin
  bool get isAdmin => _currentUser.role.toLowerCase() == 'administrator' ||
                      _currentUser.role.toLowerCase() == 'admin';

  // Selected company
  CompanyModel? _selectedCompany;
  CompanyModel? get selectedCompany => _selectedCompany;

  // Companies list
  List<CompanyModel> get companies => MockData.companies;

  // Favorites
  final List<FavoriteItem> _favorites = List.from(MockData.favorites);
  List<FavoriteItem> get favorites => _favorites;

  // All menu items
  List<FavoriteItem> get allMenuItems => MockData.allMenuItems;

  // Favorite categories for picker
  List<Map<String, dynamic>> get favoriteCategories =>
      MockData.favoriteCategories;

  // Dashboard items
  List<DashboardItem> get dashboardItems => MockData.dashboardItems;

  // Dashboard filter (wireframe: Pending selected by default)
  String _dashboardFilter = 'Pending';
  String get dashboardFilter => _dashboardFilter;

  // News
  List<NewsItem> get news => MockData.companyNews;
  NewsItem? _activeNews;
  NewsItem? get activeNews => _activeNews;

  // Bottom nav
  // Start on Home tab by default after login
  int _currentNavIndex = 1;
  int get currentNavIndex => _currentNavIndex;

  // Is authenticated
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AppState() {
    _loadProfileFromPrefs();
  }

  String _initialsFromName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  String _profileKeyForUser(String baseKey, String email) {
    final normalized = email.trim().toLowerCase();
    return '${baseKey}_$normalized';
  }

  Future<void> _loadProfileFromPrefs({bool shouldNotify = true}) async {
    final accountEmail = _activeAccountKey;
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(
      _profileKeyForUser(_profileNameKey, accountEmail),
    );
    final savedEmail = prefs.getString(
      _profileKeyForUser(_profileEmailKey, accountEmail),
    );

    _profileName = _currentUser.name;
    _profileEmail = _currentUser.email;
    _profilePhone = '+61 400 123 456';
    _profileJobTitle = 'Farm Manager';
    _profileDepartment = 'Operations';
    _profileLocation = 'Sydney, Australia';
    _profilePhotoBase64 = null;

    _profileName = (savedName ?? _profileName).trim();
    _profileEmail = (savedEmail ?? _profileEmail).trim();
    _profilePhone =
        prefs.getString(_profileKeyForUser(_profilePhoneKey, accountEmail)) ??
        _profilePhone;
    _profileJobTitle =
        prefs.getString(_profileKeyForUser(_profileJobTitleKey, accountEmail)) ??
        _profileJobTitle;
    _profileDepartment =
        prefs.getString(_profileKeyForUser(_profileDepartmentKey, accountEmail)) ??
        _profileDepartment;
    _profileLocation =
        prefs.getString(_profileKeyForUser(_profileLocationKey, accountEmail)) ??
        _profileLocation;
    _profilePhotoBase64 = prefs.getString(
      _profileKeyForUser(_profilePhotoBase64Key, accountEmail),
    );

    _currentUser = _currentUser.copyWith(
      name: _profileName,
      email: _profileEmail,
      initials: _initialsFromName(_profileName),
    );
    if (shouldNotify) {
      notifyListeners();
    }
  }

  Future<void> saveProfileInfo({
    required String name,
    required String email,
    required String phone,
    required String jobTitle,
    required String department,
    required String location,
  }) async {
    final accountEmail = _activeAccountKey;
    _profileName = name.trim().isEmpty ? _profileName : name.trim();
    _profileEmail = email.trim().isEmpty ? _profileEmail : email.trim();
    _profilePhone = phone.trim();
    _profileJobTitle = jobTitle.trim();
    _profileDepartment = department.trim();
    _profileLocation = location.trim();

    _currentUser = _currentUser.copyWith(
      name: _profileName,
      email: _profileEmail,
      initials: _initialsFromName(_profileName),
    );
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _profileKeyForUser(_profileNameKey, accountEmail),
      _profileName,
    );
    await prefs.setString(
      _profileKeyForUser(_profileEmailKey, accountEmail),
      _profileEmail,
    );
    await prefs.setString(
      _profileKeyForUser(_profilePhoneKey, accountEmail),
      _profilePhone,
    );
    await prefs.setString(
      _profileKeyForUser(_profileJobTitleKey, accountEmail),
      _profileJobTitle,
    );
    await prefs.setString(
      _profileKeyForUser(_profileDepartmentKey, accountEmail),
      _profileDepartment,
    );
    await prefs.setString(
      _profileKeyForUser(_profileLocationKey, accountEmail),
      _profileLocation,
    );
  }

  Future<void> setProfilePhotoBase64(String? photoBase64) async {
    final accountEmail = _activeAccountKey;
    _profilePhotoBase64 = photoBase64;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    if (photoBase64 == null || photoBase64.isEmpty) {
      await prefs.remove(_profileKeyForUser(_profilePhotoBase64Key, accountEmail));
      return;
    }
    await prefs.setString(
      _profileKeyForUser(_profilePhotoBase64Key, accountEmail),
      photoBase64,
    );
  }

  Color companyColor(CompanyModel company) {
    switch (company.id) {
      case '1':
        return const Color(0xFF2563EB); // Pacific Harvest Co.
      case '2':
        // Australia Farm Innovations (fallback solid color)
        return const Color(0xFFF25329);
      case '3':
        return const Color(0xFF7561DB); // Australia Software Technology
      case '4':
        return const Color(0xFF10B981); // Innovative Fibre Industries
      default:
        return AppColors.headerOrange;
    }
  }

  // Gradient for Australia Farm Innovations
  LinearGradient? companyHeaderGradient(CompanyModel company) {
    if (company.id == '2') {
      return const LinearGradient(
        colors: [
          Color(0xFFF25329), // #f25329
          Color(0xFFF86037), // #f86037
          Color(0xFFFE6C45), // #fe6c45
          Color(0xFFFF8260), // #ff8260
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    }
    if (company.id == '1') {
      return const LinearGradient(
        colors: [
          Color(0xFF3F75ED), // #3f75ed
          Color(0xFF5081EF), // #5081ef
          Color(0xFF6792F1), // #6792f1
          Color(0xFFBCCFF9), // #bccff9
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    }
    if (company.id == '3') {
      return const LinearGradient(
        colors: [
          Color(0xFF7A67DC), // #3f75ed
          Color(0xFF7D6ADD), // #5081ef
          Color(0xFF8472DF), // #6792f1
          Color(0xFF8D7CE1), // #bccff9
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    }
    return null;

    
  }

  void setHeaderColor(Color color) {
    _headerColor = color;
    notifyListeners();
  }

  void selectCompany(CompanyModel? company) {
    _selectedCompany = company;

    // Update header color based on selected company name
    if (company != null) {
      _headerColor = companyColor(company);
    } else {
      _headerColor = AppColors.headerOrange;
    }

    notifyListeners();
  }

  void setDashboardFilter(String filter) {
    _dashboardFilter = filter;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void showNews(NewsItem news) {
    _activeNews = news;
    notifyListeners();
  }

  void dismissNews() {
    _activeNews = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();

    UserModel? matchedUser;
    for (final user in MockData.loginUsers) {
      if (user.email.toLowerCase() == normalizedEmail) {
        matchedUser = user;
        break;
      }
    }

    final expectedPassword = MockData.loginPasswordsByEmail[normalizedEmail];
    final isValidLogin =
        matchedUser != null &&
        expectedPassword != null &&
        normalizedPassword == expectedPassword;

    if (!isValidLogin) {
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }

    _currentUser = matchedUser;
    _activeAccountKey = normalizedEmail;
    await _loadProfileFromPrefs(shouldNotify: false);

    _isLoading = false;
    _isAuthenticated = true;
    // Set selected company from user's account (e.g. from database)
    final companyId = _currentUser.companyId;
    _selectedCompany = null;
    if (companyId != null) {
      for (final c in companies) {
        if (c.id == companyId) {
          selectCompany(c);
          break;
        }
      }
    }
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    _selectedCompany = null;
    _hasCurrentTimeIn = false;
    _currentTimeInAt = null;
    notifyListeners();
  }

  void reorderFavorites(int oldIndex, int newIndex) {
    final item = _favorites.removeAt(oldIndex);
    _favorites.insert(newIndex, item);
    notifyListeners();
  }

  static const int maxFavorites = 5;

  void addFavorite(FavoriteItem item) {
    if (!_favorites.any((f) => f.id == item.id) &&
        _favorites.length < maxFavorites) {
      _favorites.add(item);
      notifyListeners();
    }
  }

  void removeFavorite(String id) {
    _favorites.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  void setFavorites(List<FavoriteItem> items) {
    _favorites
      ..clear()
      ..addAll(items.take(maxFavorites));
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.any((f) => f.id == id);

  List<DashboardItem> get filteredDashboardItems {
    if (_dashboardFilter == 'All') return dashboardItems;
    return dashboardItems
        .where((item) => item.category == _dashboardFilter)
        .toList();
  }

  int get pendingCount =>
      dashboardItems.where((i) => i.category == 'Pending').length;
  int get approvedCount =>
      dashboardItems.where((i) => i.category == 'Approved').length;
  int get sentForReviewCount =>
      dashboardItems.where((i) => i.category == 'Sent for Review').length;
}
