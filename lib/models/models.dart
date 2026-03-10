import 'package:flutter/material.dart';

class UserModel {
  final String name;
  final String email;
  final String initials;
  final String role;
  /// Company id this user belongs to (e.g. from database). Used to set selected company on login.
  final String? companyId;

  const UserModel({
    required this.name,
    required this.email,
    required this.initials,
    required this.role,
    this.companyId,
  });
}

class CompanyModel {
  final String id;
  final String name;
  final String location;
  final String lastUpdated;
  final bool hasNew;
  final String? tag;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.location,
    required this.lastUpdated,
    this.hasNew = false,
    this.tag,
  });
}

class FavoriteItem {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  const FavoriteItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class DashboardItem {
  final String id;
  final String title;
  final String subtitle;
  final String status;
  final String date;
  final Color statusColor;
  final IconData icon;
  final Color iconBgColor;
  /// Which tab this item belongs to: 'Pending', 'Approved', or 'Sent for Review'
  final String category;

  const DashboardItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.date,
    required this.statusColor,
    this.icon = Icons.circle,
    this.iconBgColor = Colors.grey,
    this.category = 'Pending',
  });
}

class NewsItem {
  final String id;
  final String title;
  final String content;
  final String date;
  final String? imageUrl;
  final bool isImportant;
  final String companyId;
  final List<NewsAttachment> attachments;

  const NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.imageUrl,
    this.isImportant = false,
    required this.companyId,
    this.attachments = const [],
  });
}

class NewsAttachment {
  final String name;
  final String type; // 'pdf', 'image', etc.
  final String url;
  const NewsAttachment({required this.name, required this.type, required this.url});
}

class MenuItemModel {
  final String id;
  final String title;
  final IconData icon;
  final String? badge;
  final Color? badgeColor;

  const MenuItemModel({
    required this.id,
    required this.title,
    required this.icon,
    this.badge,
    this.badgeColor,
  });
}
