  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (limit != null) {
      data['limit'] = limit;
    }
    if (assetClass != null && assetClass!.isNotEmpty) {
      data['assetClass'] = assetClass;
    }
    if (assetClassFilterEnabled != null) {
      data['assetClassFilterEnabled'] = assetClassFilterEnabled;
    }
    if (sector != null && sector!.isNotEmpty) {
      data['sector'] = sector;
    }
    if (sectorFilterEnabled != null) {
      data['sectorFilterEnabled'] = sectorFilterEnabled;
    }
    if (fromDate != null) {
      data['fromDate'] = fromDate;
    }
    if (fromDateFilterEnabled != null) {
      data['fromDateFilterEnabled'] = fromDateFilterEnabled;
    }
    if (toDate != null) {
      data['toDate'] = toDate;
    }
    if (toDateFilterEnabled != null) {
      data['toDateFilterEnabled'] = toDateFilterEnabled;
    }
    if (category != null) {
      data['category'] = category;
    }
    if (categoryFilterEnabled != null) {
      data['categoryFilterEnabled'] = categoryFilterEnabled;
    }
    if (securityCode != null && securityCode!.isNotEmpty) {
      data['securityCode'] = securityCode;
    }
    if (securityCodeFilterEnabled != null) {
      data['securityCodeFilterEnabled'] = securityCodeFilterEnabled;
    }
    if (title != null && title!.isNotEmpty) {
      data['title'] = title;
    }
    if (titleFilterEnabled != null) {
      data['titleFilterEnabled'] = titleFilterEnabled;
    }
    if (lang != null && lang!.isNotEmpty) {
      data['lang'] = lang;
    }

    return data;
  }
