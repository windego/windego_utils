import 'package:windego_utils/src/num_util.dart';

// changeF2Y                   : 分 转 元, format格式输出.
// changeFStr2YWithUnit        : 分字符串 转 元, format 与 unit 格式 输出.
// changeF2YWithUnit           : 分 转 元, format 与 unit 格式 输出.
// changeYWithUnit             : 元, format 与 unit 格式 输出.
// changeY2F                   : 元 转 分.

enum MoneyUnit {
  NORMAL, // 6.00
  YUAN, // ¥6.00
  YUAN_ZH, // 6.00元
  DOLLAR, // $6.00
}
enum MoneyFormat {
  NORMAL, //保留两位小数(6.00元)
  END_INTEGER, //去掉末尾'0'(6.00元 -> 6元, 6.60元 -> 6.6元)
  YUAN_INTEGER, //整元(6.00元 -> 6元)
}

///
class MoneyUtil {
  static const String YUAN = '¥';
  static const String YUAN_ZH = '元';
  static const String DOLLAR = '\$';

  static String format(String moneyTxt, {int unitType = 0}) {
    // 匹配一个位置：该位置后有3的倍数个数字，该位置的前面不能出现小数点
    // dart 正则没有/g?
    RegExp reg = new RegExp(r"\B(?=(\d{3})+(?!\d))");
    var formatMoney = moneyTxt.replaceAll(reg, ',');
    return addUnit(formatMoney, unitType);
  }

  /// with unit.
  /// 拼接单位.
  static String addUnit(String moneyTxt, int unit) {
    if (moneyTxt == null || moneyTxt.isEmpty) return null;
    switch (unit) {
      case 0:
        moneyTxt = moneyTxt;
        break;
      case 1:
        moneyTxt = moneyTxt + ' ' + YUAN_ZH;
        break;
      case 2:
        moneyTxt = YUAN + ' ' + moneyTxt;
        break;
      default:
        break;
    }
    return moneyTxt;
  }

  /// fen to yuan, format output.
  /// 分 转 元, format格式输出.
  static String changeF2Y(int amount,
      {MoneyFormat format = MoneyFormat.NORMAL}) {
    if (amount == null) return null;
    String moneyTxt;
    double yuan = NumUtil.divide(amount, 100);
    switch (format) {
      case MoneyFormat.NORMAL:
        moneyTxt = yuan.toStringAsFixed(2);
        break;
      case MoneyFormat.END_INTEGER:
        if (amount % 100 == 0) {
          moneyTxt = yuan.toInt().toString();
        } else if (amount % 10 == 0) {
          moneyTxt = yuan.toStringAsFixed(1);
        } else {
          moneyTxt = yuan.toStringAsFixed(2);
        }
        break;
      case MoneyFormat.YUAN_INTEGER:
        moneyTxt = (amount % 100 == 0)
            ? yuan.toInt().toString()
            : yuan.toStringAsFixed(2);
        break;
    }
    return moneyTxt;
  }

  /// fen str to yuan, format & unit  output.
  /// 分字符串 转 元, format 与 unit 格式 输出.
  static String changeFStr2YWithUnit(String amountStr,
      {MoneyFormat format = MoneyFormat.NORMAL,
      MoneyUnit unit = MoneyUnit.NORMAL}) {
    int amount;
    if (amountStr != null) {
      double value = double.tryParse(amountStr);
      amount = (value == null ? null : value.toInt());
    }
    return changeF2YWithUnit(amount, format: format, unit: unit);
  }

  /// fen to yuan, format & unit  output.
  /// 分 转 元, format 与 unit 格式 输出.
  static String changeF2YWithUnit(int amount,
      {MoneyFormat format = MoneyFormat.NORMAL,
      MoneyUnit unit = MoneyUnit.NORMAL}) {
    return withUnit(changeF2Y(amount, format: format), unit);
  }

  /// yuan, format & unit  output.(yuan is int,double,str).
  /// 元, format 与 unit 格式 输出.
  static String changeYWithUnit(Object yuan, MoneyUnit unit,
      {MoneyFormat format}) {
    if (yuan == null) return null;
    String yuanTxt = yuan.toString();
    if (format != null) {
      int amount = changeY2F(yuan);
      yuanTxt = changeF2Y(amount.toInt(), format: format);
    }
    return withUnit(yuanTxt, unit);
  }

  /// yuan to fen.
  /// 元 转 分，
  static int changeY2F(Object yuan) {
    if (yuan == null) return null;
    return NumUtil.multiplyDecStr(yuan.toString(), '100').toInt();
  }

  /// with unit.
  /// 拼接单位.
  static String withUnit(String moneyTxt, MoneyUnit unit) {
    if (moneyTxt == null || moneyTxt.isEmpty) return null;
    switch (unit) {
      case MoneyUnit.YUAN:
        moneyTxt = YUAN + moneyTxt;
        break;
      case MoneyUnit.YUAN_ZH:
        moneyTxt = moneyTxt + YUAN_ZH;
        break;
      case MoneyUnit.DOLLAR:
        moneyTxt = DOLLAR + moneyTxt;
        break;
      default:
        break;
    }
    return moneyTxt;
  }
}
