Map<String,dynamic> get getParams{
    Map<String,dynamic> params = {};
    if (userId != null) params['user_id'] = userId;
    if (deviceToken != null) params['device_token'] = deviceToken;
    if (deviceType != null) params['device_type'] = deviceType;
    if (watchListFolders != null) params['watchlist_folders'] = watchListFolders;
    if (lowerLimit != null) params['lower_limit'] = lowerLimit;
    if (upperLimit != null) params['upper_limit'] = upperLimit;
    if (notify != null) params['notify'] = notify;
    if (stockcode != null) params['stock_code'] = stockcode;
    if (cNotify != null) params['c_notify'] = cNotify;
    if (cmd != null) params['cmd'] = cmd;
    if (foldername != null) params['folder_name'] = foldername;
    if (foldernameNew != null) params['folder_name_new'] = foldernameNew;
    if (favouritesJson != null) params['favouritesJson'] = favouritesJson;
    return params;

  }
