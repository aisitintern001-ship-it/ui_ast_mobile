import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class MockData {
  /// Current user (e.g. from database). companyId sets which company is selected on login.
  static const UserModel currentUser = UserModel(
    name: 'Mae Jezriel Llanes',
    email: 'mac.llanes@company.com',
    initials: 'M',
    role: 'Administrator',
    companyId: '2', // Australia Farm Innovations
  );

  static const List<CompanyModel> companies = [
    CompanyModel(
      id: '1',
      name: 'Pacific Harvest Co.',
      location: 'Australia',
      lastUpdated: 'Nov 18',
      hasNew: true,
    ),
    CompanyModel(
      id: '2',
      name: 'Australia Farm Innovations',
      location: 'Australia',
      lastUpdated: 'Oct 22',
    ),
    CompanyModel(
      id: '3',
      name: 'Australia Software Technology',
      location: 'Australia',
      lastUpdated: 'Nov 10',
    ),
    CompanyModel(
      id: '4',
      name: 'Innovative Fibre Industries',
      location: 'Australia',
      lastUpdated: 'Nov 15',
    ),
  ];

  static final List<FavoriteItem> favorites = [
    // Max 5 - matches reference
    const FavoriteItem(
      id: 'attendance',
      title: 'Attendance',
      icon: LucideIcons.clock,
      color: Color(0xFF3B82F6),
      route: '/attendance',
    ),
    const FavoriteItem(
      id: 'product',
      title: 'Product',
      icon: LucideIcons.shoppingBag,
      color: Color(0xFF3B82F6),
      route: '/product',
    ),
    const FavoriteItem(
      id: 'expense_claim',
      title: 'Expense Claim',
      icon: LucideIcons.dollarSign,
      color: Color(0xFF3B82F6),
      route: '/expense-claim',
    ),
    const FavoriteItem(
      id: 'leave_request',
      title: 'Leave Request',
      icon: LucideIcons.calendarRange,
      color: Color(0xFF3B82F6),
      route: '/leave-request',
    ),
  ];

  /// Categories and items for favorites picker (matches reference UI)
  static const List<Map<String, dynamic>> favoriteCategories = [
    {
      'label': 'Attendance',
      'items': [
        FavoriteItem(id: 'attendance', title: 'Attendance', icon: LucideIcons.clock, color: AppColors.iconOrange, route: '/attendance'),
        FavoriteItem(id: 'payslip', title: 'Payslip', icon: LucideIcons.handCoins, color: AppColors.iconOrange, route: '/payslip'),
        FavoriteItem(id: 'leave_request', title: 'Leave Request', icon: LucideIcons.calendar, color: AppColors.iconOrange, route: '/leave-request'),
        FavoriteItem(id: 'team_management', title: 'Team Management', icon: LucideIcons.users, color: AppColors.iconOrange, route: '/team-management'),
      ],
    },
    {
      'label': 'Product Library',
      'items': [
        FavoriteItem(id: 'product', title: 'Product', icon: LucideIcons.shoppingBag, color: AppColors.iconOrange, route: '/product'),
      ],
    },
    {
      'label': 'Finance',
      'items': [
        FavoriteItem(id: 'expense_claim', title: 'Expense Claim', icon: LucideIcons.dollarSign, color: AppColors.iconOrange, route: '/expense-claim'),
      ],
    },
  ];

  static final List<FavoriteItem> allMenuItems = [
    const FavoriteItem(
      id: 'attendance',
      title: 'Attendance',
      icon: LucideIcons.clock,
      color: AppColors.iconBlue,
      route: '/attendance',
    ),
    const FavoriteItem(
      id: 'product',
      title: 'Product',
      icon: LucideIcons.shoppingBag,
      color: AppColors.iconBlue,
      route: '/product',
    ),
    const FavoriteItem(
      id: 'expense_claim',
      title: 'Expense Claim',
      icon: LucideIcons.dollarSign,
      color: AppColors.iconBlue,
      route: '/expense-claim',
    ),
    const FavoriteItem(
      id: 'leave_request',
      title: 'Leave Request',
      icon: LucideIcons.calendar,
      color: AppColors.iconBlue,
      route: '/leave-request',
    ),
    const FavoriteItem(
      id: 'employee_hub',
      title: 'Employee Hub',
      icon: LucideIcons.users,
      color: AppColors.iconBlue,
      route: '/employee-hub',
    ),
    const FavoriteItem(
      id: 'user_reports',
      title: 'User Reports',
      icon: LucideIcons.chartBar,
      color: AppColors.iconOrange,
      route: '/user-reports',
    ),
    const FavoriteItem(
      id: 'payroll',
      title: 'Payroll',
      icon: LucideIcons.wallet,
      color: AppColors.iconYellow,
      route: '/payroll',
    ),
    const FavoriteItem(
      id: 'inventory',
      title: 'Inventory',
      icon: LucideIcons.boxes,
      color: AppColors.iconRed,
      route: '/inventory',
    ),
    const FavoriteItem(
      id: 'compliance',
      title: 'Compliance',
      icon: LucideIcons.shieldCheck,
      color: AppColors.iconBlue,
      route: '/compliance',
    ),
    const FavoriteItem(
      id: 'documents',
      title: 'Documents',
      icon: LucideIcons.folder,
      color: AppColors.iconOrange,
      route: '/documents',
    ),
    const FavoriteItem(
      id: 'analytics',
      title: 'Analytics',
      icon: LucideIcons.chartPie,
      color: AppColors.iconGreen,
      route: '/analytics',
    ),
    const FavoriteItem(
      id: 'approvals',
      title: 'Approvals',
      icon: LucideIcons.circleCheck,
      color: AppColors.iconTeal,
      route: '/approvals',
    ),
    const FavoriteItem(
      id: 'calendar',
      title: 'Calendar',
      icon: LucideIcons.calendarDays,
      color: AppColors.iconPurple,
      route: '/calendar',
    ),
  ];

  static const List<DashboardItem> dashboardItems = [
    DashboardItem(
      id: '1',
      title: 'Expense Claim - Mae Jezriel Llanes',
      subtitle: 'Travel reimbursement for client meeting',
      status: 'Not Started',
      date: 'Jan 5, 2025',
      statusColor: AppColors.statusPending,
      icon: LucideIcons.dollarSign,
      iconBgColor: Color(0xFFE9E6FD),
    ),
    DashboardItem(
      id: '2',
      title: 'Leave Request - Mae Jezriel Llanes',
      subtitle: 'Annual Leave - 3 days',
      status: 'For Approval',
      date: 'Jan 5, 2025',
      statusColor: AppColors.statusPending,
      icon: LucideIcons.calendar,
      iconBgColor: Color(0xFFD1FAE5),
    ),
    DashboardItem(
      id: '3',
      title: 'Overtime Request',
      subtitle: '2.5 hours - Jan 3, 2025',
      status: 'Pending Review',
      date: 'Jan 3, 2025',
      statusColor: AppColors.statusPending,
      icon: LucideIcons.clock,
      iconBgColor: Color(0xFFDBEAFE),
    ),
    DashboardItem(
      id: '5',
      title: 'Timesheet Approval',
      subtitle: 'Edward Peter',
      status: 'Pending Review',
      date: 'Dec 22',
      statusColor: AppColors.statusPending,
      icon: LucideIcons.clock,
      iconBgColor: Color(0xFFDBEAFE),
      category: 'Approved',
    ),
    DashboardItem(
      id: '6',
      title: 'Overtime Approval',
      subtitle: 'Daniel Gray',
      status: '2.5 hrs OT',
      date: 'Dec 1',
      statusColor: AppColors.statusApproved,
      icon: LucideIcons.clock,
      iconBgColor: Color(0xFFD1FAE5),
      category: 'Approved',
    ),
    DashboardItem(
      id: '7',
      title: 'Expense Claim Approval',
      subtitle: 'Maria Dela Rosa',
      status: '\u20B12,500 travel',
      date: 'Nov 9',
      statusColor: AppColors.statusApproved,
      icon: LucideIcons.dollarSign,
      iconBgColor: Color(0xFFD1FAE5),
      category: 'Approved',
    ),
    DashboardItem(
      id: '8',
      title: 'Time In Record',
      subtitle: '8:00 AM - Offline',
      status: 'Pending',
      date: 'Dec 22, 2025',
      statusColor: AppColors.statusPending,
      icon: LucideIcons.clock,
      iconBgColor: Color(0xFFDBEAFE),
      category: 'Sent for Review',
    ),
    DashboardItem(
      id: '9',
      title: 'Time Out Record',
      subtitle: '5:30 PM - Offline',
      status: 'Pending',
      date: 'Dec 22, 2025',
      statusColor: AppColors.statusPending,
      icon: LucideIcons.clock,
      iconBgColor: Color(0xFFDBEAFE),
      category: 'Sent for Review',
    ),
  ];

  static const List<NewsItem> companyNews = [
    NewsItem(
      id: '1',
      title: 'Annual Company Picnic 2024',
      content: 'We are excited to announce our Annual Company Picnic 2024! Join us for a day full of fun activities, food, and camaraderie. The event will be held at Nuvali Laguna on December 14, 2024. All employees and their families are invited. Please register through the Employee Hub by December 1.',
      date: 'Nov 18, 2024',
      isImportant: true,
      companyId: '3',
    ),
    NewsItem(
      id: '3',
      title: 'Annual Company Outing 2026',
      content: 'Join us for our annual company outing at Batangas Beach Resort on January 16, 2026',
      date: 'Jan 2, 2026',
      imageUrl: 'news/outing_2026.jpg',
      isImportant: true,
      companyId: '2', // Australia Farm Innovations
      attachments: [
        NewsAttachment(name: 'event_schedule.pdf', type: 'pdf', url: 'news/event_schedule.pdf'),
        NewsAttachment(name: 'resort_photo.jpg', type: 'image', url: 'news/resort_photo.jpg'),
      ],
    ),
    NewsItem(
      id: '4',
      title: 'New Farm Equipment Training',
      content: 'Mandatory training session for all field staff on the new harvesting equipment. Sessions will be held on January 20-22, 2026.',
      date: 'Jan 5, 2026',
      isImportant: true,
      companyId: '2', // Australia Farm Innovations
    ),
    NewsItem(
      id: '5',
      title: 'Q1 2026 Planning Meeting',
      content: 'All department heads are invited to attend the Q1 planning meeting on January 25, 2026 at the main conference room.',
      date: 'Jan 8, 2026',
      companyId: '2', // Australia Farm Innovations
    ),
    NewsItem(
      id: '2',
      title: 'New Office Policy Update',
      content: 'Effective December 1, the company will implement a hybrid work arrangement. Employees are required to report to the office at least 3 days per week. Please coordinate with your respective department heads for scheduling.',
      date: 'Nov 15, 2024',
      companyId: '3',
    ),
    NewsItem(
      id: '6',
      title: 'Year-End Performance Review',
      content: 'The year-end performance review period will begin on December 1 and end on December 20. All managers are required to complete evaluations for their team members. Employees should prepare their self-assessment forms available in the HR portal.',
      date: 'Nov 10, 2024',
      companyId: '3',
    ),
  ];
}
