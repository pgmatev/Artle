import 'package:http/http.dart';

class Utils {
  static String artleApiKey = '9YJVYwomXuhCiSN6G41K5zJE7kkYMmxnDbJ9fo_g8xhLy3DJZx2DGpvLYV5AHj42NLuoD4S8GTiJf0abBqREVQ';
  static String baseUrl = Uri.encodeFull("http://10.108.7.75:5000/api/v1/");
  static Client client = Client();
}