import 'package:flutter/material.dart';
import 'package:windego/windego.dart';
import 'package:flutter/foundation.dart';

import 'models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();

  /// App运行在Release环境时， kReleaseMode是由foundation 提供的常量
  Log.init(isDebug: !kReleaseMode);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String name, time;

  DateTime dateTime;
  String spLastCounter = 'last_counter';
  DateTime now = DateTime.now();

  void _incrementCounter() {
    setState(() {
      _counter++;
      SpUtil.setInt(spLastCounter, _counter);
      SpUtil.setString("name", "windego$_counter");
    });
  }

  @override
  void initState() {
    super.initState();

    /// use sp.
    _counter = SpUtil.getInt(spLastCounter, defValue: 0);

    /// string

    name = SpUtil.getString("name", defValue: "");
    Log.d("name: " + name);

    /// save object example.
    /// 存储实体对象示例。
    City city = City();
    city.name = "北京市";
    SpUtil.setObject("loc_city", city);

    City hasCity = SpUtil.getObj("loc_city", (v) => City.fromJson(v));
    Map hasCity1 = SpUtil.getObject("loc_city");
    Log.d("City: " + (hasCity == null ? "null" : hasCity.toString()));
    Log.d("City: $hasCity1");

    /// save object list example.
    /// 存储实体对象list示例。
    List<City> list = List();

    list.add(City(name: "北京市"));
    list.add(City(name: "保定市"));
    SpUtil.setObjectList("city_list", list);

    List<City> dataList =
        SpUtil.getObjList("city_list", (v) => City.fromJson(v));
    Log.d("CityList: " + (dataList == null ? "null" : dataList.toString()));
    Log.d(dataList[1].name);

    time = DateUtil.formatDate('YYYY年M月d日 HH时mm分ss秒');

    String dateStr = "2019-07-09 16:16:16";
    dateTime = DateUtil.getDateTime(dateStr);
    final millisecond = DateTime.now().millisecondsSinceEpoch;
    Log.d('millisecond $millisecond');

    String money = MoneyUtil.format("11112345", unitType: 2);
    Log.d('money $money');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'name:$name',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'now:$time',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'dateTime:$dateTime',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'getDateTimeByMs:${DateUtil.getDateTimeByMs(1603555660308)}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
