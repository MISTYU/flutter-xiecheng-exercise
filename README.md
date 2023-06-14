# xiecheng_app

A new Flutter project.

## Getting Started

### http
```dart
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String showResult = '';
  Future<CommonModel> fetchPost() async {
    var url = Uri.https(
      'www.devio.org',
      '/io/flutter_app/json/test_common_model.json',
    );
    final response = await http.get(url);
    final result = json.decode(response.body);
    return CommonModel.fromJson(result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('http'),
        ),
        body: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                fetchPost().then((CommonModel value) {
                  setState(() {
                    showResult =
                        '请求结果: \n hideAppBar: ${value.hideAppBar}\n icon: ${value.icon} \n';
                  });
                });
              },
              child: const Text(
                '点我',
                style: TextStyle(fontSize: 26),
              ),
            ),
            Text(showResult),
          ],
        ),
      ),
    );
  }
}

class CommonModel {
  late final String icon;
  late final String title;
  late final String url;
  late final String statusBarColor;
  late bool hideAppBar;

  CommonModel({
    required this.icon,
    required this.title,
    required this.url,
    required this.statusBarColor,
    required this.hideAppBar,
  });

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      icon: json['icon'],
      title: json['title'],
      url: json['url'],
      statusBarColor: json['statusBarColor'],
      hideAppBar: json['hideAppBar'],
    );
  }
}
```

### FutureBuilder
```dart
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<CommonModel> fetchPost() async {
    var url = Uri.https(
      'www.devio.org',
      '/io/flutter_app/json/test_common_model.json',
    );
    final response = await http.get(url);
    Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
    final result = json.decode(utf8decoder.convert(response.bodyBytes));
    return CommonModel.fromJson(result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Future 与 FutureBuilder 实用技巧'),
          ),
          body: FutureBuilder<CommonModel>(
              future: fetchPost(),
              builder: (context, AsyncSnapshot<CommonModel> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('Input a URL to start');
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                    return const Text('');
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text(
                        '${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      );
                    } else {
                      return Column(
                        children: <Widget>[
                          Text('icon: ${snapshot.data?.icon}'),
                          Text(
                              'statusBarColor: ${snapshot.data?.statusBarColor}'),
                          Text('title: ${snapshot.data?.title}'),
                          Text('url: ${snapshot.data?.url}'),
                        ],
                      );
                    }
                }
              })),
    );
  }
}

class CommonModel {
  late final String icon;
  late final String title;
  late final String url;
  late final String statusBarColor;
  late bool hideAppBar;

  CommonModel({
    required this.icon,
    required this.title,
    required this.url,
    required this.statusBarColor,
    required this.hideAppBar,
  });

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      icon: json['icon'],
      title: json['title'],
      url: json['url'],
      statusBarColor: json['statusBarColor'],
      hideAppBar: json['hideAppBar'],
    );
  }
}
```

### ListView
垂直方向滚动
```dart
const CITY_NAMES = [
  '北京',
  '上海',
  '广州',
  '深圳',
  '杭州',
  '苏州',
  '成都',
  '武汉',
  '郑州',
  '洛阳',
  '厦门',
  '青岛',
  '拉萨',
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Flutter ListView'),
          ),
          body: ListView(
            children: _buildList(),
          )),
    );
  }

  List<Widget> _buildList() {
    return CITY_NAMES.map((city) => _item(city)).toList();
  }

  Widget _item(city) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(bottom: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.teal),
      child: Text(
        city,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
```

### 可展开的列表 ExpansionTile
```dart
const CITY_NAMES = {
  '北京': ['东城区', '西城区', '朝阳区', '丰台区', '石景山区', '海淀区', '顺义区'],
  '上海': ['黄浦区', '徐汇区', '长宁区', '静安区', '普陀区', '闸北区', '虹口区'],
  '广州': ['越秀', '海珠', '荔湾', '天河', '白云', '黄埔', '南沙', '番禺'],
  '深圳': ['南山', '福田', '罗湖', '盐田', '龙岗', '宝安', '龙华'],
  '杭州': ['上城区', '下城区', '江干区', '拱墅区', '西湖区', '滨江区'],
  '武汉': ['姑苏区', '吴中区', '相城区', '高新区', '虎丘区', '工业园区', '吴江区'],
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final title = '列表展开与收起';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          child: ListView(
            children: _buildList(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildList() {
    List<Widget> widgets = [];
    CITY_NAMES.keys.forEach((key) {
      widgets.add(_item(key, CITY_NAMES[key]!));
    });

    return widgets;
  }

  Widget _item(String city, List<String> subCities) {
    return ExpansionTile(
      title: Text(
        city,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 20,
        ),
      ),
      children: subCities.map((subCity) => _buildSub(subCity)).toList(),
    );
  }

  Widget _buildSub(String subCity) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        height: 50,
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(color: Colors.lightBlueAccent),
        child: Text(subCity),
      ),
    );
  }
}
```

### GridView
```dart
const CITY_NAMES = [
  '北京',
  '上海',
  '广州',
  '深圳',
  '杭州',
  '苏州',
  '成都',
  '武汉',
  '郑州',
  '洛阳',
  '厦门',
  '青岛',
  '拉萨',
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final title = '网格布局';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: _buildList(),
        ),
      ),
    );
  }

  List<Widget> _buildList() {
    return CITY_NAMES.map((city) => _item(city)).toList();
  }

  Widget _item(city) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(bottom: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.teal),
      child: Text(
        city,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
```

###  RefreshIndicator 下拉刷新
```dart
List<String> cityNames = [
  '北京',
  '上海',
  '广州',
  '深圳',
  '杭州',
  '苏州',
  '成都',
  '武汉',
  '郑州',
  '洛阳',
  '厦门',
  '青岛',
  '拉萨',
];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  final title = '高级功能列表下拉刷新与上拉加载更多功能实现';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView(
            children: _buildList(),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // 延迟 2s
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      cityNames = cityNames.reversed.toList();
    });
  }

  List<Widget> _buildList() {
    return cityNames.map((city) => _item(city)).toList();
  }

  Widget _item(city) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(bottom: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.teal),
      child: Text(
        city,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
```

### ListView 上拉加载
```dart
List<String> cityNames = [
  '北京',
  '上海',
  '广州',
  '深圳',
  '杭州',
  '苏州',
  '成都',
  '武汉',
  '郑州',
  '洛阳',
  '厦门',
  '青岛',
  '拉萨',
];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  final title = '高级功能列表下拉刷新与上拉加载更多功能实现';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _loadData() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      List<String> list = List<String>.from(cityNames);
      list.addAll(cityNames);
      cityNames = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView(
            controller: _scrollController,
            children: _buildList(),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // 延迟 2s
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      cityNames = cityNames.reversed.toList();
    });
  }

  List<Widget> _buildList() {
    return cityNames.map((city) => _item(city)).toList();
  }

  Widget _item(city) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(bottom: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.teal),
      child: Text(
        city,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
```