import 'dart:convert';

class HealthTopic {
  final String type;
  final String id;
  final String title;
  final String translationId;
  final String translationTitle;
  final String categories;
  final String populations;
  final String myHFTitle;
  final String myHFDescription;
  final String myHFCategory;
  final String myHFCategoryHeading;
  final int lastUpdate;
  final String imageUrl;
  final String imageAlt;
  final String accessibleVersion;
  final RelatedItems relatedItems;
  final Sections sections;
  final dynamic moreInfoItems; // Can be null or dynamic
  final String healthfinderLogo;
  final String healthfinderUrl;

  HealthTopic({
    required this.type,
    required this.id,
    required this.title,
    required this.translationId,
    required this.translationTitle,
    required this.categories,
    required this.populations,
    required this.myHFTitle,
    required this.myHFDescription,
    required this.myHFCategory,
    required this.myHFCategoryHeading,
    required this.lastUpdate,
    required this.imageUrl,
    required this.imageAlt,
    required this.accessibleVersion,
    required this.relatedItems,
    required this.sections,
    this.moreInfoItems,
    required this.healthfinderLogo,
    required this.healthfinderUrl,
  });

  factory HealthTopic.fromJson(Map<String, dynamic> json) {
    return HealthTopic(
      type: json['Type'].toString(),
      id: json['Id'].toString(),
      title: json['Title'].toString(),
      translationId: json['TranslationId'].toString(),
      translationTitle: json['TranslationTitle'].toString(),
      categories: json['Categories'].toString(),
      populations: json['Populations'].toString(),
      myHFTitle: json['MyHFTitle'].toString(),
      myHFDescription: json['MyHFDescription'].toString(),
      myHFCategory: json['MyHFCategory'].toString(),
      myHFCategoryHeading: json['MyHFCategoryHeading'].toString(),
      lastUpdate: int.tryParse(json['LastUpdate'].toString()) ?? 0,
      imageUrl: json['ImageUrl'].toString(),
      imageAlt: json['ImageAlt'].toString(),
      accessibleVersion: json['AccessibleVersion'].toString(),
      relatedItems: RelatedItems.fromJson(json['RelatedItems']),
      sections: Sections.fromJson(json['Sections']),
      moreInfoItems: json['MoreInfoItems'],
      healthfinderLogo: json['HealthfinderLogo'].toString(),
      healthfinderUrl: json['HealthfinderUrl'].toString(),
    );
  }
}

class RelatedItems {
  final List<RelatedItem> relatedItem;

  RelatedItems({required this.relatedItem});

  factory RelatedItems.fromJson(Map<String, dynamic> json) {
    var list = json['RelatedItem'] as List;
    return RelatedItems(
      relatedItem: list.map((i) => RelatedItem.fromJson(i)).toList(),
    );
  }
}

class RelatedItem {
  final String type;
  final String id;
  final String title;
  final String url;

  RelatedItem({
    required this.type,
    required this.id,
    required this.title,
    required this.url,
  });

  factory RelatedItem.fromJson(Map<String, dynamic> json) {
    return RelatedItem(
      type: json['Type'].toString(),
      id: json['Id'].toString(),
      title: json['Title'].toString(),
      url: json['Url'].toString(),
    );
  }
}

class Sections {
  final List<Section> section;

  Sections({required this.section});

  factory Sections.fromJson(Map<String, dynamic> json) {
    var list = json['section'] as List;
    return Sections(
      section: list.map((i) => Section.fromJson(i)).toList(),
    );
  }
}

class Section {
  final String title;
  final String description;
  final String content;

  Section({
    required this.title,
    required this.description,
    required this.content,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      title: json['Title'].toString(),
      description: json['Description'].toString(),
      content: json['Content'].toString(),
    );
  }
}
