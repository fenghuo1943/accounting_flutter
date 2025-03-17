class Transaction {
  final String id; // 账单的唯一标识
  final double amount; // 账单金额
  final String category; // 账单分类（如餐饮、交通）
  final DateTime date; // 账单日期
  bool isSynced; // 是否已同步到服务器

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.isSynced = false, // 默认未同步
  });

  // 将对象转换为 Map，用于插入数据库
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(), // 将 DateTime 转换为字符串
      'isSynced': isSynced ? 1 : 0, // 将布尔值转换为整数（SQLite 不支持布尔类型）
    };
  }

  // 从 Map 中解析对象
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']), // 将字符串解析为 DateTime
      isSynced: map['isSynced'] == 1, // 将整数转换为布尔值
    );
  }

  // 复制对象（用于更新同步状态）
  Transaction copyWith({bool? isSynced}) {
    return Transaction(
      id: id,
      amount: amount,
      category: category,
      date: date,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}