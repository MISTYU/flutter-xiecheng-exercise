import 'dart:async';
import 'dart:convert';
import 'package:xiecheng_app/model/hoem_model.dart';
import 'package:http/http.dart' as http;

const homeUrl = 'http://www.devio.org/io/flutter_app/json/home_page.json';

class HomeDao {
  static Future<HomeModel> fetch() async {
    print('fetch');
    final response = await http.get(
      Uri.parse(homeUrl),
    );
    print('response');
    print(response.statusCode);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 修复中文乱码问题
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    } else {
      throw Exception('Faild to load home_page.json');
    }
  }
}
