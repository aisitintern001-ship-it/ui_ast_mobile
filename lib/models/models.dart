import 'package:flutter/material.dart';

class UserModel {
  final String name;
  final String email;
  final String initials;
  final String role;

  const UserModel({
    required this.name,
    required this.email,
    required this.initials,
    required this.role,
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

  const DashboardItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.date,
    required this.statusColor,
  });
}

class NewsItem {
  final String id;
  final String title;
  final String content;
  final String date;
  final String? imageUrl;
  final bool isImportant;

  const NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.imageUrl,
    this.isImportant = false,
  });
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
