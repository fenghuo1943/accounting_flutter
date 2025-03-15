import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // 不显示方法调用栈
    errorMethodCount: 5, // 显示错误的方法调用栈
    lineLength: 50, // 每行最大长度
    colors: true, // 启用颜色
    printEmojis: true, // 启用表情符号
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // 显示时间和启动时间
  ),
  level: kReleaseMode ? Level.warning : Level.debug, // 生产环境只记录警告及以上级别
);