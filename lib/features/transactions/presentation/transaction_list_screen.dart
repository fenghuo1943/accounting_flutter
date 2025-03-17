import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accounting/core/network/api_service.dart';
import 'package:accounting/features/transactions/presentation/add_transaction_screen.dart';
import 'package:accounting/core/utils/storage_service.dart'; // 引入存储服务


class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ref.watch(apiServiceProvider);
    //final transactionsFuture = apiService.get('/transaction/user/');
    final userIdFuture = StorageService.getUserId();
    final tokenFuture = StorageService.getToken();

    return Scaffold(
      appBar: AppBar(title: const Text('账单列表')),
      body: FutureBuilder(
        future: Future.wait([userIdFuture, tokenFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('错误: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data![0] == null || snapshot.data![1] == null) {
            return const Center(child: Text('未找到用户ID或Token'));
          } else {
            final userId = snapshot.data![0]!;
            final token = snapshot.data![1]!;
            // 获取账单数据
            final transactionsFuture = apiService.get(
              '/transaction/user/$userId',
              options: Options(headers: {'Authorization': 'Bearer $token'}),
            );

            return FutureBuilder(
              future: transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('错误: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.data == null) {
                  return const Center(child: Text('未找到账单数据'));
                } else {
                  final transactions = snapshot.data!.data;
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return ListTile(
                        title: Text(transaction['type']),
                        subtitle: Text('金额: ${transaction['amount']}'),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

    /* return Scaffold(
      appBar: AppBar(title: const Text('账单列表')),
      body: FutureBuilder(
        future: transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('错误: ${snapshot.error}'));
          } else {
            final transactions = snapshot.data!.data;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text(transaction['type']),
                  subtitle: Text('金额: ${transaction['amount']}'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} */
