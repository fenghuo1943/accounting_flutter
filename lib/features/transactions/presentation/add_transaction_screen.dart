import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accounting/core/network/api_service.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('添加账单')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: '类型'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入类型';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: '金额'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入金额';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final apiService = ref.read(apiServiceProvider);
                    try {
                      await apiService.post('/transaction', {
                        'type': _typeController.text,
                        'amount': double.parse(_amountController.text),
                      });

                      // 检查页面是否仍然挂载
                      if (mounted) {
                        Navigator.pop(context); // 返回上一页
                      }
                    } catch (e) {
                      // 处理错误
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('提交失败: $e')),
                        );
                      }
                    }
                  }
                },
                child: const Text('提交'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}