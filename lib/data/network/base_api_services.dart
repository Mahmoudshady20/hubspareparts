abstract class BaseApiServices {
  Future<dynamic> getApi(String url, requestName, {headers});

  Future<dynamic> postApi(dynamic data, String url, requestName, {headers});
}
