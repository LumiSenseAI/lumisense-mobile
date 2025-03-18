import 'package:network_info_plus/network_info_plus.dart';

class IPService {
  static Future<String> getIPAddress() async {
    final info = NetworkInfo();
    String? ipAddress = await info.getWifiIP();
    if (ipAddress == null) {
      throw Exception('Adresse IP non trouvée');
    }
    return ipAddress;
  }
}