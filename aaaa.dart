import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_model.freezed.dart';
part 'data_model.g.dart';

@freezed
class DataModel with _$DataModel {
  const factory DataModel({
    required Data data,
  }) = _DataModel;

  factory DataModel.fromJson(Map<String, dynamic> json) => _$DataModelFromJson(json);
}


@freezed
class Data with _$Data {
  const factory Data({
    required Categories categories,
    required AssetClassesSecurities assetClassesSecurities,
    required Sectors sectors,
    required ListData list,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Categories with _$Categories {
  const factory Categories({
    required List<CategoryData> data,
  }) = _Categories;

  factory Categories.fromJson(Map<String, dynamic> json) => _$CategoriesFromJson(json);
}

@freezed
class CategoryData with _$CategoryData {
  const factory CategoryData({
    required Category data,
  }) = _CategoryData;

  factory CategoryData.fromJson(Map<String, dynamic> json) => _$CategoryDataFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
class AssetClassesSecurities with _$AssetClassesSecurities {
  const factory AssetClassesSecurities({
    required List<AssetClassData> data,
  }) = _AssetClassesSecurities;

  factory AssetClassesSecurities.fromJson(Map<String, dynamic> json) => _$AssetClassesSecuritiesFromJson(json);
}

@freezed
class AssetClassData with _$AssetClassData {
  const factory AssetClassData({
    required Category data,
  }) = _AssetClassData;

  factory AssetClassData.fromJson(Map<String, dynamic> json) => _$AssetClassDataFromJson(json);
}

@freezed
class Sectors with _$Sectors {
  const factory Sectors({
    required List<AssetClassData> data,
  }) = _Sectors;

  factory Sectors.fromJson(Map<String, dynamic> json) => _$SectorsFromJson(json);
}

@freezed
class ListData with _$ListData {
  const factory ListData({
    required int count,
    required List<ListItem> results,
  }) = _ListData;

  factory ListData.fromJson(Map<String, dynamic> json) => _$ListDataFromJson(json);
}

@freezed
class ListItem with _$ListItem {
  const factory ListItem({
    required ListItemData data,
  }) = _ListItem;

  factory ListItem.fromJson(Map<String, dynamic> json) => _$ListItemFromJson(json);
}

@freezed
class ListItemData with _$ListItemData {
  const factory ListItemData({
    required String contentType,
    required int id,
    required String title,
    required CategoryData category,
    required List<AssetClassData> assetClass,
    required Link link,
    String? migrated,
    required int dateArticle,
  }) = _ListItemData;

  factory ListItemData.fromJson(Map<String, dynamic> json) => _$ListItemDataFromJson(json);
}

@freezed
class Link with _$Link {
  const factory Link({
    required String url,
  }) = _Link;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
}
