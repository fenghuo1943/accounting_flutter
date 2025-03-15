// app/router.dart
import 'package:go_router/go_router.dart';
import 'package:accounting/features/auth/auth_screen.dart';
import 'package:accounting/features/transactions/presentation/transaction_list_screen.dart';
import 'package:accounting/features/transactions/presentation/add_transaction_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => const TransactionListScreen(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddTransactionScreen(),
    ),
  ],
);