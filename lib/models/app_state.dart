import 'package:flutter/material.dart';
import 'models.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class AppState extends ChangeNotifier {
    // Attendance: persistent time-in state
    bool _hasCurrentTimeIn = false;
    bool get hasCurrentTimeIn => _hasCurrentTimeIn;
    void setHasCurrentTimeIn(bool value) {
      _hasCurrentTimeIn = value;
      notifyListeners();
    }
  // Theme color for header
  Color _headerColor = const Color(0xFF2563EB);
  Color get headerColor => _headerColor;

  // Current user
  final UserModel _currentUser = MockData.currentUser;
  UserModel get currentUser => _currentUser;

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

    _isLoading = false;
    _isAuthenticated = true;
    // Set selected company from user's account (e.g. from database)
    final companyId = _currentUser.companyId;
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
