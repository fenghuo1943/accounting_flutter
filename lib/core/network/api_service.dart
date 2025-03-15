// core/network/api_service.dart
import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://your-backend-url.com/api'));
  return ApiService(dio);
});

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<Response> get(String path) async {
    return dio.get(path);
  }

  Future<Response> post(String path, dynamic data) async {
    return dio.post(path, data: data);
  }
}