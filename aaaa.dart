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
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC0/uk+oWSJ0eodcwFsfVOpmcbKZr9dKYL17lUoZkINifVIfgUHJf78UOQu1MVSHid/Qx/QPYn6FwIeMDckPaOaUTUBXdl1cfvDMZeADpBx+OzcAtmrhBn2HLY+PE8hu/SbHRRbHM4AGPbDJLbBl8WQSEHrFuluUN5N+safuVEQRCK7KGj2Y4WHw0oEannj0iBK09DubP9Z6WbKPFbmsv4oksL03z+mOmPnSQi1XZ6AqCloqZlLT41K7YyeBWioaFPS7+yyjrdOsTauy7xUcunulZE4tAUDiupoY/rVKi16lH4B+FQgttT7UQou5R6DwrUMKt51jIqgvlc+07klh9t1AgMBAAECggEABqMMTtbLNtSNjFaRwvaA3Ai+sIr+Ub5lG3s0Vd6+EFIH6QhvSxj6ayp/hjTDfDnigo5QZdSZMSRT2GM15Rck3yftf3x/WLOnzZC4I016wCXRGwDjFiDUyjYOUWTpFUMXpUfL3crGG7HOpqQ7gV4n3p0Psb0C1/U7hEosVgy3wMFhu19uVy73YfIOITOgJ0LIkrfLSCbsEZ0zF7NjQkrELFWJZ1RlXIt6JO/bUxZcscJV2T7Mulfsy7i03O6Fc4NEc+asWIu5e29/a+S1TFG4e0XvJdghbOA7IsVXtpi4lXSu0p46hlkIjdrjRUzQg8U21ZrW2FOn5tWcY3qF5YzwpwKBgQDd+5oCohcHJjfeo0GCQW5HlYllGdaSKnTd1eLO5dY3GrH+AvIUf4Q5WDGJCrMU0xKyHsv+YKfldy5N8gdQIN5lcTo0u1Mp7VaHiXt5G8c8fSqL0ezw4RmggywYonFqmZcTnLf6ScsabugNebnqriGdsyHIdz+phEGfEjiWrRfGVwKBgQDQu2JmQ4qgepEufYEY/TXTwSot6LMF4v5/8iZ5WskXeIGLjzdBPnLW38R4IIR10NdAixRPJL+lBitOeet75Z0S9JiOsvWrDGtn/3cWtVJpf29qMuM1VaEiqHcXPKK6BLN08e5vVPhzhnNpzlFOJ7gAO6/ShuJq6+19M9dn/RkVEwKBgHEHXaIdmpAfW69XfVGvs1FryOvbvi/qwlr6P2SODwc75omqQk1BqLfyOjbHZewilZBwsfoyiQsEJmW16RdZxSPuBW84Ot5MZRTaYi6GgGpCaVmMaJM2avAaGmfovstCrXRlBiDBVlN9SVcjNhFS3PcJcRg78ASGvUsb4giG1mY9AoGBAKgPZ8/M6+4AIarb9DjJjzBa4/oo1ROVS7J6ps2o8iZKqYtTmXqXrGEjtA3AqMYvi1B1arm6be+SAwZhld+g5ZJgjADBSJobGtOWVi1beupkZ7GLHXNQ6bd9Cr4T3TWHGXK8ZG0RbiWeCIkVTFNwGW9en1cTsXPDV+kp93LLzwkvAoGASTe8vo2QtzSEdnmc4vcMaqHVubmbNzjcUPDAvxtRqm7fqVGdg2NTJmbYbBcFN62jzLKsNFobrTIrwU9hQwFTzJow8JmEUQsV5FwPntfTcYbuu4UbTU9P8aF+PuJKZATUPDIUxuLYqws1Jwfs8Sr+S/M5hk34nMALfT2pNlpksXs=

       {
    "username": null,
    "status": 0,
    "favourites": [],
    "followings": [
        {
            "contentId": "5e8dd0d1-b35d-49d2-a930-b1bee25062a7",
            "name": "SRT-NoSuffix",
            "stocks": [
                {
                    "stock_code": "JG"
                },
                {
                    "stock_code": "ZFSW"
                },
                {
                    "stock_code": "502"
                },
                {
                    "stock_code": "AZG"
                },
                {
                    "stock_code": "BQC"
                },
                {
                    "stock_code": "S9B"
                },
                {
                    "stock_code": "S7OU"
                },
                {
                    "stock_code": "S68"
                },
                {
                    "stock_code": ".TRSGA7T"
                },
                {
                    "stock_code": ".TRSGCLL"
                }
            ],
            "customName": "",
            "userName": "testmobilesgx",
            "status": 1,
            "discoverable": 1,
            "shareCode": "WlCwzsro1kny",
            "lastUpdatedAt": "2022-09-06 17:59:14",
            "followers": 24
        }
    ]
}
