import 'package:flutter/material.dart';
import 'models.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class AppState extends ChangeNotifier {
  // Theme color for header
  Color _headerColor = const Color.fromARGB(255, 75, 72, 235);
  Color get headerColor => _headerColor;

  // Current user
  final UserModel _currentUser = MockData.currentUser;
  UserModel get currentUser => _currentUser;

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

  // Dashboard items
  List<DashboardItem> get dashboardItems => MockData.dashboardItems;

  // Dashboard filter
  String _dashboardFilter = 'All';
  String get dashboardFilter => _dashboardFilter;

  // News
  List<NewsItem> get news => MockData.companyNews;
  NewsItem? _activeNews;
  NewsItem? get activeNews => _activeNews;

  // Bottom nav
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  // Is authenticated
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setHeaderColor(Color color) {
    _headerColor = color;
    notifyListeners();
  }

  void selectCompany(CompanyModel? company) {
    _selectedCompany = company;

    // Update header color based on selected company name
    if (company != null) {
      switch (company.name) {
        case 'Pacific Harvest Co.':
          _headerColor = const Color(0xFF6366F1); // purple
          break;
        case 'Australia Farm Innovations':
          _headerColor = const Color(0xFFF97316); // orange
          break;
        case 'Australia Software Technology':
          _headerColor = const Color(0xFF2563EB); // blue
          break;
        case 'Innovative Fibre Industries':
          _headerColor = const Color(0xFF10B981); // green
          break;
        default:
          _headerColor = AppColors.headerOrange;
      }
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

  void addFavorite(FavoriteItem item) {
    if (!_favorites.any((f) => f.id == item.id)) {
      _favorites.add(item);
      notifyListeners();
    }
  }

  void removeFavorite(String id) {
    _favorites.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.any((f) => f.id == id);

  List<DashboardItem> get filteredDashboardItems {
    if (_dashboardFilter == 'All') return dashboardItems;
    return dashboardItems.where((item) => item.status == _dashboardFilter).toList();
  }

  int get pendingCount => dashboardItems.where((i) => i.status == 'Pending').length;
  int get approvedCount => dashboardItems.where((i) => i.status == 'Approved').length;
  int get sentForReviewCount => dashboardItems.where((i) => i.status == 'Sent for Review').length;
}
