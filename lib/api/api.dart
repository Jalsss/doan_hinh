import 'package:connectivity/connectivity.dart';
import 'package:doan_hinh/notification/notification.config.dart';
import 'package:http/http.dart';


Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

class Api {

  static final Api _instance = Api._internal();

   static void apiGet(String port, String url, String params) async {
    check().then((intenet) async {
      if (intenet != null && intenet) {
        final response = await get(port + url + params);
        return response;
      } else {
        return MyDialog('Lỗi kết nối, vui lòng kiểm tra kết nối mạng và thử lại');
      }
    });
  }

  apiPost(String port, String url, Map<String,String> params) async {
    var uri = Uri.http(port, url, params);
    check().then((intenet) async {
      if (intenet != null && intenet) {
        final response = await post(uri);
        if(response.statusCode == 200) {
          return response;
        } else {
          return MyDialog(response.body);
        }
      } else {
        return MyDialog('Lỗi kết nối, vui lòng kiểm tra kết nối mạng và thử lại');
      }
    });
  }

  factory Api() {
    return _instance;
  }

  Api._internal();
}