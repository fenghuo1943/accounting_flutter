// core/network/api_service.dart
import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import 'package:accounting/core/utils/logger.dart';
import 'package:accounting/core/utils/storage_service.dart'; // 引入存储服务

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/v1'));
  return ApiService(dio);
});

class ApiService {
  final Dio dio;

  //ApiService(this.dio);
  ApiService(this.dio) {
    // 添加拦截器
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 自动添加 Token 到请求头
          final token = await StorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token 过期，尝试刷新 Token
            try {
              final newToken = await _refreshToken();
              if (newToken != null) {
                // 更新请求头并重试
                error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                return handler.resolve(await dio.fetch(error.requestOptions));
              }
            } catch (e) {
              logger.e('刷新 Token 失败: $e');
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
  // 刷新 Token
  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();
      final response = await dio.post('/user/refresh_token', data: {'refresh_token': refreshToken});
      final newToken = response.data['access_token'];
      await StorageService.saveToken(newToken);
      return newToken;
    } catch (e) {
      logger.e('刷新 Token 失败: $e');
      return null;
    }
  }
  // 获取用户的所有账单
  Future<Response> getTransactions(String userId,String accessToken) async {
    return await get('/transaction/user/$userId',options: Options(
              headers: {
                'Authorization': 'Bearer $accessToken', // 设置请求头
              },
            ),);
  }

  // 创建账单
  Future<Response> createTransaction(Map<String, dynamic> data,String accessToken) async {
    return await post('/transactions', data,options: Options(
              headers: {
                'Authorization': 'Bearer $accessToken', // 设置请求头
              },
            ),);
  }
  
  Future<Response> get(String path, {Options? options}) async {
    try {
      final response = await dio.get(
      path,
      options: options, // 支持自定义请求头
    );
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

  Future<Response> post(String path,
  dynamic data, {
  Options? options, // 支持自定义请求头
}) async {
    try {
    final response = await dio.post(
      path,
      data: data, // 直接使用传入的 data
      options: options, // 支持自定义请求头
    );
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
