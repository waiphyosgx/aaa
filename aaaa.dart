import 'dart:convert';

class RequestModel {
  final int? limit;
  final List<int>? assetClass;
  final bool? assetClassFilterEnabled;
  final List<int>? sector;
  final bool? sectorFilterEnabled;
  final int? fromDate;
  final bool? fromDateFilterEnabled;
  final int? toDate;
  final bool? toDateFilterEnabled;
  final int? category;
  final bool? categoryFilterEnabled;
  final String? securityCode;
  final bool? securityCodeFilterEnabled;
  final String? title;
  final bool? titleFilterEnabled;
  final String? lang;

  RequestModel({
    this.limit,
    this.assetClass,
    this.assetClassFilterEnabled,
    this.sector,
    this.sectorFilterEnabled,
    this.fromDate,
    this.fromDateFilterEnabled,
    this.toDate,
    this.toDateFilterEnabled,
    this.category,
    this.categoryFilterEnabled,
    this.securityCode,
    this.securityCodeFilterEnabled,
    this.title,
    this.titleFilterEnabled,
    this.lang,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (limit != null) data['limit'] = limit;
    if (assetClass != null) data['assetClass'] = assetClass;
    if (assetClassFilterEnabled != null) data['assetClassFilterEnabled'] = assetClassFilterEnabled;
    if (sector != null) data['sector'] = sector;
    if (sectorFilterEnabled != null) data['sectorFilterEnabled'] = sectorFilterEnabled;
    if (fromDate != null) data['fromDate'] = fromDate;
    if (fromDateFilterEnabled != null) data['fromDateFilterEnabled'] = fromDateFilterEnabled;
    if (toDate != null) data['toDate'] = toDate;
    if (toDateFilterEnabled != null) data['toDateFilterEnabled'] = toDateFilterEnabled;
    if (category != null) data['category'] = category;
    if (categoryFilterEnabled != null) data['categoryFilterEnabled'] = categoryFilterEnabled;
    if (securityCode != null) data['securityCode'] = securityCode;
    if (securityCodeFilterEnabled != null) data['securityCodeFilterEnabled'] = securityCodeFilterEnabled;
    if (title != null) data['title'] = title;
    if (titleFilterEnabled != null) data['titleFilterEnabled'] = titleFilterEnabled;
    if (lang != null) data['lang'] = lang;

    return data;
  }

  String toJsonString() {
    return json.encode(toJson());
  }
}
