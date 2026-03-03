import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class MockData {
  static const UserModel currentUser = UserModel(
    name: 'John Mel C. Haniba',
    email: 'mac.llanes@company.com',
    initials: 'A',
    role: 'Administrator',
  );

  static const List<CompanyModel> companies = [
    CompanyModel(
      id: '1',
      name: 'Ace Company Filing a Title',
      location: 'Pasig City, Metro Manila, Philippines',
      lastUpdated: 'Nov 18',
      hasNew: true,
      tag: 'NEW',
    ),
    CompanyModel(
      id: '2',
      name: 'Goldfish Company Filing Ltd.',
      location: 'Makati City, Metro Manila',
      lastUpdated: 'Oct 22',
    ),
    CompanyModel(
      id: '3',
      name: 'TechForward Solutions Inc.',
      location: 'Quezon City, Metro Manila',
      lastUpdated: 'Nov 10',
    ),
    CompanyModel(
      id: '4',
      name: 'Pacific Bridge Corporation',
      location: 'Taguig City, Metro Manila',
      lastUpdated: 'Nov 15',
    ),
    CompanyModel(
      id: '5',
      name: 'Horizon Global Partners',
      location: 'Mandaluyong City, Metro Manila',
      lastUpdated: 'Sep 30',
    ),
  ];

  static final List<FavoriteItem> favorites = [
    const FavoriteItem(
      id: 'employee_hub',
      title: 'Employee Hub',
      icon: Icons.people_alt_rounded,
      color: AppColors.iconBlue,
      route: '/employee-hub',
    ),
    const FavoriteItem(
      id: 'user_reports',
      title: 'User Reports',
      icon: Icons.bar_chart_rounded,
      color: AppColors.iconOrange,
      route: '/user-reports',
    ),
    const FavoriteItem(
      id: 'capital_ops',
      title: 'Capital Ops',
      icon: Icons.account_balance_rounded,
      color: AppColors.iconGreen,
      route: '/capital-ops',
    ),
    const FavoriteItem(
      id: 'tax_management',
      title: 'Tax Management',
      icon: Icons.receipt_long_rounded,
      color: Color.fromARGB(255, 87, 90, 231),
      route: '/tax-management',
    ),
    const FavoriteItem(
      id: 'survey',
      title: 'Survey',
      icon: Icons.poll_rounded,
      color: AppColors.iconTeal,
      route: '/survey',
    ),
  ];

  static final List<FavoriteItem> allMenuItems = [
    const FavoriteItem(
      id: 'employee_hub',
      title: 'Employee Hub',
      icon: Icons.people_alt_rounded,
      color: AppColors.iconBlue,
      route: '/employee-hub',
    ),
    const FavoriteItem(
      id: 'user_reports',
      title: 'User Reports',
      icon: Icons.bar_chart_rounded,
      color: AppColors.iconOrange,
      route: '/user-reports',
    ),
    const FavoriteItem(
      id: 'capital_ops',
      title: 'Capital Ops',
      icon: Icons.account_balance_rounded,
      color: AppColors.iconGreen,
      route: '/capital-ops',
    ),
    const FavoriteItem(
      id: 'tax_management',
      title: 'Tax Management',
      icon: Icons.receipt_long_rounded,
      color: AppColors.iconPurple,
      route: '/tax-management',
    ),
    const FavoriteItem(
      id: 'survey',
      title: 'Survey',
      icon: Icons.poll_rounded,
      color: AppColors.iconTeal,
      route: '/survey',
    ),
    const FavoriteItem(
      id: 'payroll',
      title: 'Payroll',
      icon: Icons.payments_rounded,
      color: AppColors.iconYellow,
      route: '/payroll',
    ),
    const FavoriteItem(
      id: 'inventory',
      title: 'Inventory',
      icon: Icons.inventory_2_rounded,
      color: AppColors.iconRed,
      route: '/inventory',
    ),
    const FavoriteItem(
      id: 'compliance',
      title: 'Compliance',
      icon: Icons.verified_rounded,
      color: AppColors.iconBlue,
      route: '/compliance',
    ),
    const FavoriteItem(
      id: 'documents',
      title: 'Documents',
      icon: Icons.folder_rounded,
      color: AppColors.iconOrange,
      route: '/documents',
    ),
    const FavoriteItem(
      id: 'analytics',
      title: 'Analytics',
      icon: Icons.analytics_rounded,
      color: AppColors.iconGreen,
      route: '/analytics',
    ),
    const FavoriteItem(
      id: 'approvals',
      title: 'Approvals',
      icon: Icons.check_circle_rounded,
      color: AppColors.iconTeal,
      route: '/approvals',
    ),
    const FavoriteItem(
      id: 'calendar',
      title: 'Calendar',
      icon: Icons.calendar_month_rounded,
      color: AppColors.iconPurple,
      route: '/calendar',
    ),
  ];

  static const List<DashboardItem> dashboardItems = [
    DashboardItem(
      id: '1',
      title: 'Fletcher Whitfield Leave',
      subtitle: 'Annual Leave · 3 days',
      status: 'Pending',
      date: 'Nov 18',
      statusColor: AppColors.statusPending,
    ),
    DashboardItem(
      id: '2',
      title: 'Contractor Request',
      subtitle: 'IT Department · Software Dev',
      status: 'Approved',
      date: 'Nov 15',
      statusColor: AppColors.statusApproved,
    ),
    DashboardItem(
      id: '3',
      title: 'Employee Reimbursement',
      subtitle: 'Finance · Travel Expense',
      status: 'Sent for Review',
      date: 'Nov 14',
      statusColor: AppColors.statusSentReview,
    ),
    DashboardItem(
      id: '4',
      title: 'Team Performance',
      subtitle: 'Q4 Review · Operations',
      status: 'Pending',
      date: 'Nov 12',
      statusColor: AppColors.statusPending,
    ),
    DashboardItem(
      id: '5',
      title: 'Company Events',
      subtitle: 'Year-end party planning',
      status: 'Approved',
      date: 'Nov 10',
      statusColor: AppColors.statusApproved,
    ),
    DashboardItem(
      id: '6',
      title: 'Total Reimbursement',
      subtitle: 'Nov batch · 12 requests',
      status: 'Sent for Review',
      date: 'Nov 8',
      statusColor: AppColors.statusSentReview,
    ),
    DashboardItem(
      id: '7',
      title: 'Compliance Filing',
      subtitle: 'BIR · Q3 Submission',
      status: 'Pending',
      date: 'Nov 5',
      statusColor: AppColors.statusPending,
    ),
    DashboardItem(
      id: '8',
      title: 'Survey',
      subtitle: 'Employee satisfaction · 2024',
      status: 'Approved',
      date: 'Nov 3',
      statusColor: AppColors.statusApproved,
    ),
  ];

  static const List<NewsItem> companyNews = [
    NewsItem(
      id: '1',
      title: 'Annual Company Picnic 2024',
      content: 'We are excited to announce our Annual Company Picnic 2024! Join us for a day full of fun activities, food, and camaraderie. The event will be held at Nuvali Laguna on December 14, 2024. All employees and their families are invited. Please register through the Employee Hub by December 1.',
      date: 'Nov 18, 2024',
      isImportant: true,
    ),
    NewsItem(
      id: '2',
      title: 'New Office Policy Update',
      content: 'Effective December 1, the company will implement a hybrid work arrangement. Employees are required to report to the office at least 3 days per week. Please coordinate with your respective department heads for scheduling.',
      date: 'Nov 15, 2024',
    ),
    NewsItem(
      id: '3',
      title: 'Year-End Performance Review',
      content: 'The year-end performance review period will begin on December 1 and end on December 20. All managers are required to complete evaluations for their team members. Employees should prepare their self-assessment forms available in the HR portal.',
      date: 'Nov 10, 2024',
    ),
  ];
}
