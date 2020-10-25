void main(List<String> args) {
  RegExp reg = new RegExp(r"\B(?=(\d{3})+(?!\d))");
// 匹配一个位置：该位置后有3的倍数个数字，该位置的前面不能出现小数点
  var text = '1234567';
  var res = text.replaceAll(reg, ',');

  print(res);
}
