  static void registerDeepLink(GoRouter routers) {
    appLink.uriLinkStream.listen((uri) {
      String? category = uri.queryParameters['cat'];
      String? type = uri.queryParameters['type'];
      String? code = uri.queryParameters['code'];
      if (category == "securities" &&
          type?.isNotEmpty == true &&
          code?.isNotEmpty == true) {
        routers.pushNamed(
          'security-details',
          pathParameters: {
            'stockType': type ?? '',
            'selectedStock': code ?? '',
          },
        );
      }
      else if (category == "derivatives" && code?.isNotEmpty == true) {
        routers.pushNamed('derivative-details',
          pathParameters: {
            'selectedStock': code ?? '',
          },
         );
      }
      else if(category == "indices" && code?.isNotEmpty == true){
        routers.pushNamed(
          'indices-details',
          pathParameters: {
            'selectedStock': code ?? '',
          },
        );
      }
    });
  }
