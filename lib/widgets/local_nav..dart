import 'package:flutter/material.dart';
import 'package:xiecheng_app/model/common_model.dart';
import 'package:xiecheng_app/widgets/test_web_view.dart';
import 'package:xiecheng_app/widgets/webview.dart';

class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  const LocalNav({
    Key? key,
    required this.localNavList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (localNavList == null) return null;
    List<Widget> items = [];
    localNavList.forEach((model) {
      items.add(_item(context, model));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HiWebView(
              url: model.url,
              statusBarColor: model.statusBarColor ?? 'ffffff',
              title: model.title ?? 'mistyu-title',
              hideAppBar: model.hideAppBar ?? true,
            ),
          ),
        );
      },
      child: Column(children: <Widget>[
        Image.network(
          model.icon!,
          width: 32,
          height: 32,
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            model.title!,
            style: TextStyle(fontSize: 12),
          ),
        )
      ]),
    );
  }
}
