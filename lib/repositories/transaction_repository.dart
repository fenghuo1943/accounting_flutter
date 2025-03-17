import '../database/database_helper.dart';
import '../model/transaction.dart';
import '../core/network/api_service.dart';
import 'package:accounting/core/utils/storage_service.dart'; // 引入存储服务

class TransactionRepository {
  final ApiService _api;
  final DatabaseHelper _dbHelper;

  TransactionRepository(this._api, this._dbHelper);

  // 添加账单
  Future<void> addTransaction(Transaction transaction) async {
    await _dbHelper.insertTransaction(transaction);
    try {
      final accessToken = await StorageService.getToken();
    if (accessToken == null) {
      throw Exception('未找到 accessToken');
    }
      await _api.createTransaction(transaction.toMap(), accessToken);
      await _dbHelper.updateTransactionSyncStatus(transaction.id, true);
    } catch (e) {
      // 标记为未同步，后续自动重试
    }
  }

  // 同步未同步的账单
  Future<void> syncPendingTransactions() async {
    final pendingTransactions = await _dbHelper.getPendingTransactions();
    for (final transaction in pendingTransactions) {
      await addTransaction(transaction);
    }
  }

  // 获取所有账单
  Future<List<Transaction>> getTransactions() async {
    return await _dbHelper.getTransactions();
  }
}