 final jsonData = {
      "cmd": "getusersinfo",
      "user_id": "6c121508-aaf3-4a7f-9aed-882b1f881aff",
      "device_token": "6c121508-aaf3-4a7f-9aed-882b1f881aff"
    };

    // Make the POST request
    final response = await dio.post(
      'https://qatrademobile.qasgx.com/v7/api.php',
      data: jsonData,
      options: Options(
        headers: {
          "User-Agent": "SGX Mobile App 3.9.10-QA / 34",
          "X-Auth-Timestamp": "1712805563364",
          "X-Auth-Token": "iqfyfnvHzmSsAw3FDK/c4tbitsGPlzWIC4rHirOybw8jfAqLKr8rzHjDrKvMl3Ap43pCEpW9N9nJk37Z+fT7euaYKNjb86ob3lH/6zR8Crw5Cli7SmpnA+eZLCnN2q03oVVLJbNjeJ5PtGG/yGVwEnw2UffOaiioSv+5hR7fIATmalE/G5m9QMmiAXX7XRvmLcpMkdhXyQkIsO4UTJtWdBYXuIjzSR8cn3aIWWGIihpqIiA70O+S72pabEoqGR5+a/FirSQkmMIfaw1MdUoV0w+rbKMHCs8ope8vJ9bWAKZk91Dy3W+SgOXSjQdDDd7OFwxuvcuGADWzAx0+JOBjkg==",
          "Content-Type": "application/x-www-form-urlencoded"
        },
