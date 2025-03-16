import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accounting/core/network/api_service.dart';
import 'package:flutter/material.dart'; // 用于显示弹窗
import 'package:dio/dio.dart';
import 'package:accounting/core/utils/shared_preferences_service.dart';
import 'package:go_router/go_router.dart'; // 导入 go_router

final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthService(apiService);
});

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<bool> login(
    String username,
    String password,
    BuildContext context,
  ) async {
    try {
      final response = await _apiService.post(
        '/user/token',
        {'username': username, 'password': password},
        options: Options(
        contentType: Headers.formUrlEncodedContentType, // 明确指定表单格式
      ),
      );
      if (response.statusCode == 200) {
        // 假设后端返回的 access_token 存储在 response.data['access_token'] 中
        final accessToken = response.data['access_token'];
        if (accessToken != null) {
          // 保存 access_token
          await SharedPreferencesService.saveAccessToken(accessToken);
          final userInfoResponse = await _apiService.get(
            '/user/me',
            options: Options(
              headers: {
                'Authorization': 'Bearer $accessToken', // 设置请求头
              },
            ),
          );
          if (userInfoResponse.statusCode == 200) {
            final userInfo = userInfoResponse.data;

            // 保存用户信息
            await SharedPreferencesService.saveUserId(userInfo['id']);
            await SharedPreferencesService.saveUsername(userInfo['username']);
            await SharedPreferencesService.saveEmail(userInfo['email']);
            // 跳转至账单界面
            context.go('/transaction');
            //Navigator.pushReplacementNamed(context, '/transaction');
            return true;
          }
        }
      }
      return false;
    } on DioException catch (e) {
      _showErrorDialog(context, '登录失败', '用户名或密码错误');
      return false;
    }
  }

  Future<bool> register(
    String username,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final response = await _apiService.post(
        '/user/register',
        {'username': username, 'email': email, 'password': password},
        options: Options(
        contentType: Headers.jsonContentType, // 明确指定 JSON 格式
      ),
      );
      if (response.statusCode == 201) {
        // 注册成功，显示弹窗
        _showSuccessDialog(context, '注册成功', '注册成功，请登录');
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          final detail = responseData['detail'];
          if (detail == 'Username or email already exists') {
            _showErrorDialog(context, '注册失败', '用户名或邮箱已存在');
            return false;
          }
        }
      }
      _showErrorDialog(context, '注册失败', '未知错误，请重试');
      return false;
    }
  }

  void _showSuccessDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 关闭弹窗
                  //Navigator.pushReplacementNamed(context, '/'); // 跳转至登录界面
                },
                child: const Text('确定'),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('确定'),
              ),
            ],
          ),
    );
  }
}
