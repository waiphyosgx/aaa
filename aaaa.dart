 Map<String, dynamic> get queryParams {
    final result = <String, dynamic>{};

    if (categories != null && categories!.isNotEmpty) {
      result['categories'] = categories!.join(',');
    }

    if (!isBlank(searchType)) {
      result['searchType'] = searchType;
    }

    if (!isBlank(searchValue)) {
      result['searchValue'] = searchValue;
    }

    if (!isBlank(from)) {
      result['from'] = from;
    }

    if (!isBlank(to)) {
      result['to'] = to;
    }

    if (subcategories != null && subcategories!.isNotEmpty) {
      result['subcategories'] = subcategories!.join(',');
    }

    if (!isBlank(value)) {
      result['value'] = value;
    }

    if (!isBlank(titleFilter)) {
      result['titleFilter'] = titleFilter;
    }

    if (!isBlank(pageStart)) {
      result['pagestart'] = pageStart;
    }

    if (!isBlank(pageSize)) {
      result['pagesize'] = pageSize;
    }

    if (!isBlank(periodStart)) {
      result['periodstart'] = periodStart;
    }

    if (!isBlank(periodEnd)) {
      result['periodend'] = periodEnd;
    }

    return result;
  }
