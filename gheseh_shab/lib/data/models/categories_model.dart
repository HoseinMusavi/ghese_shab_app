import 'dart:convert';

class CategoriesModel {
  final String status;
  final List<Category> categories;
  final List<Category> allCategories;
  final List<dynamic> unwantedCategories;

  CategoriesModel({
    required this.status,
    required this.categories,
    required this.allCategories,
    required this.unwantedCategories,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      status: json['status'] as String,
      categories: (json['categories'] as List)
          .map((item) => Category.fromJson(item))
          .toList(),
      allCategories: (json['allCategories'] as List)
          .map((item) => Category.fromJson(item))
          .toList(),
      unwantedCategories: json['unwantedCategories'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'categories': categories.map((item) => item.toJson()).toList(),
      'allCategories': allCategories.map((item) => item.toJson()).toList(),
      'unwantedCategories': unwantedCategories,
    };
  }
}

class Category {
  final int id;
  final String name;
  final int defaultHidden;
  final String? createdAt;
  final String? updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.defaultHidden,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      defaultHidden: json['default_hidden'] as int,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'default_hidden': defaultHidden,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
