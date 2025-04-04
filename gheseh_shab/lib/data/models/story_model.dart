import 'package:flutter/src/widgets/framework.dart';

class StoryModel {
  int? id;
  int? categoryId;
  int? playlistId;
  dynamic playlistPosition;
  String? slug;
  String? name;
  String? image;
  int? sort;
  String? buyLink;
  String? info;
  dynamic infoTranslate;
  String? infoDir;
  String? infoTranslateDir;
  int? length;
  int? active;
  int? plays;
  int? price;
  String? sampleAudio;
  int? sharesCount;
  int? minAge;
  int? maxAge;
  String? author;
  String? translator;
  String? editor;
  String? typeOfWork;
  String? imaging;
  String? announcer;
  String? literaryStyle;
  String? mainTitle;
  String? publisher;
  String? studio;
  String? publicationDate;
  String? language;
  String? createdAt;
  String? updatedAt;

  StoryModel({
    this.id,
    this.categoryId,
    this.playlistId,
    this.playlistPosition,
    this.slug,
    this.name,
    this.image,
    this.sort,
    this.buyLink,
    this.info,
    this.infoTranslate,
    this.infoDir,
    this.infoTranslateDir,
    this.length,
    this.active,
    this.plays,
    this.price,
    this.sampleAudio,
    this.sharesCount,
    this.minAge,
    this.maxAge,
    this.author,
    this.translator,
    this.editor,
    this.typeOfWork,
    this.imaging,
    this.announcer,
    this.literaryStyle,
    this.mainTitle,
    this.publisher,
    this.studio,
    this.publicationDate,
    this.language,
    this.createdAt,
    this.updatedAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      playlistId: json['playlist_id'] ?? 0,
      playlistPosition: json['playlist_position'],
      slug: json['slug'] ?? "",
      name: json['name'] ?? "بدون عنوان",
      image: json['image'] ?? "",
      sort: json['sort'] ?? 0,
      buyLink: json['buy_link'] ?? "",
      info: json['info'] ?? "",
      infoTranslate: json['info_translate'],
      infoDir: json['info_dir'] ?? "",
      infoTranslateDir: json['info_translate_dir'] ?? "",
      length: json['length'] ?? 0,
      active: json['active'] ?? 0,
      plays: json['plays'] ?? 0,
      price: json['price'] ?? 0,
      sampleAudio: json['sample_audio'] ?? "",
      sharesCount: json['shares_count'] ?? 0,
      minAge: json['min_age'] ?? 0,
      maxAge: json['max_age'] ?? 0,
      author: json['author'] ?? "ناشناس",
      translator: json['translator'] ?? "",
      editor: json['editor'] ?? "",
      typeOfWork: json['type_of_work'] ?? "",
      imaging: json['imaging'] ?? "",
      announcer: json['announcer'] ?? "",
      literaryStyle: json['literary_style'] ?? "",
      mainTitle: json['main_title'] ?? "",
      publisher: json['publisher'] ?? "",
      studio: json['studio'] ?? "",
      publicationDate: json['publication_date'] ?? "",
      language: json['language'] ?? "نامشخص",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Widget? get isPopular => null;

  Widget? get isForeign => null;

  Widget? get isIranian => null;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category_id": categoryId,
      "playlist_id": playlistId,
      "playlist_position": playlistPosition,
      "slug": slug,
      "name": name,
      "image": image,
      "sort": sort,
      "buy_link": buyLink,
      "info": info,
      "info_translate": infoTranslate,
      "info_dir": infoDir,
      "info_translate_dir": infoTranslateDir,
      "length": length,
      "active": active,
      "plays": plays,
      "price": price,
      "sample_audio": sampleAudio,
      "shares_count": sharesCount,
      "min_age": minAge,
      "max_age": maxAge,
      "author": author,
      "translator": translator,
      "editor": editor,
      "type_of_work": typeOfWork,
      "imaging": imaging,
      "announcer": announcer,
      "literary_style": literaryStyle,
      "main_title": mainTitle,
      "publisher": publisher,
      "studio": studio,
      "publication_date": publicationDate,
      "language": language,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
