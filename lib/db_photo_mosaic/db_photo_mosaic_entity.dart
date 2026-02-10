class WorkEntity {
  final int? id;
  final String name;
  final String thumbnailPath;
  final String imagePath;
  final int? templateId;
  final String createdAt;
  final String updatedAt;

  WorkEntity({
    this.id,
    required this.name,
    required this.thumbnailPath,
    required this.imagePath,
    this.templateId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail_path': thumbnailPath,
      'image_path': imagePath,
      'template_id': templateId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory WorkEntity.fromMap(Map<String, dynamic> map) {
    return WorkEntity(
      id: map['id'] as int?,
      name: map['name'] as String,
      thumbnailPath: map['thumbnail_path'] as String,
      imagePath: map['image_path'] as String,
      templateId: map['template_id'] as int?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }
}

class TemplateEntity {
  final int? id;
  final String name;
  final String type;
  final String layoutData;
  final String? thumbnailPath;
  final int sortOrder;

  TemplateEntity({
    this.id,
    required this.name,
    required this.type,
    required this.layoutData,
    this.thumbnailPath,
    required this.sortOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'layout_data': layoutData,
      'thumbnail_path': thumbnailPath,
      'sort_order': sortOrder,
    };
  }

  factory TemplateEntity.fromMap(Map<String, dynamic> map) {
    return TemplateEntity(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
      layoutData: map['layout_data'] as String,
      thumbnailPath: map['thumbnail_path'] as String?,
      sortOrder: map['sort_order'] as int,
    );
  }
}

class FilterEntity {
  final int? id;
  final String name;
  final String type;
  final double intensity;
  final String? thumbnailPath;

  FilterEntity({
    this.id,
    required this.name,
    required this.type,
    required this.intensity,
    this.thumbnailPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'intensity': intensity,
      'thumbnail_path': thumbnailPath,
    };
  }

  factory FilterEntity.fromMap(Map<String, dynamic> map) {
    return FilterEntity(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
      intensity: map['intensity'] as double,
      thumbnailPath: map['thumbnail_path'] as String?,
    );
  }
}

class StickerEntity {
  final int? id;
  final String name;
  final String category;
  final String imagePath;
  final int sortOrder;

  StickerEntity({
    this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.sortOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image_path': imagePath,
      'sort_order': sortOrder,
    };
  }

  factory StickerEntity.fromMap(Map<String, dynamic> map) {
    return StickerEntity(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      imagePath: map['image_path'] as String,
      sortOrder: map['sort_order'] as int,
    );
  }
}

class BackgroundEntity {
  final int? id;
  final String name;
  final String type;
  final String value;
  final String? thumbnailPath;

  BackgroundEntity({
    this.id,
    required this.name,
    required this.type,
    required this.value,
    this.thumbnailPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'value': value,
      'thumbnail_path': thumbnailPath,
    };
  }

  factory BackgroundEntity.fromMap(Map<String, dynamic> map) {
    return BackgroundEntity(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
      value: map['value'] as String,
      thumbnailPath: map['thumbnail_path'] as String?,
    );
  }
}
