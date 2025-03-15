// core/network/api_service.dart
import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import 'package:accounting/core/utils/logger.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/v1'));
  return ApiService(dio);
});

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<Response> get(String path) async {
    try {
      final response = await dio.get(path);
      logger.i('请求成功: ${response.data}');
      return response;
    } on DioException catch (e) {
      logger.e('Dio 错误: ${e.message}');
      if (e.response != null) {
        logger.e('响应数据: ${e.response?.data}');
        logger.e('响应状态码: ${e.response?.statusCode}');
      } else {
        logger.e('无响应数据');
      }
      rethrow;
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      final response = await dio.post(path, data: data);
      logger.i('请求成功: ${response.data}');
      return response;
    } on DioException catch (e) {
      logger.e('Dio 错误: ${e.message}');
      if (e.response != null) {
        logger.e('响应数据: ${e.response?.data}');
        logger.e('响应状态码: ${e.response?.statusCode}');
      } else {
        logger.e('无响应数据');
      }
      rethrow;
    }
  }
}
