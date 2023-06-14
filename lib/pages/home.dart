import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

const APPBAR_SCROLL_OFFSET = 100;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List _imageUrls = [
    'https://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg',
  ];
  double appBarAlpha = 0;
  _onScroll(offset) {
    print(offset);
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification &&
                      scrollNotification.depth == 0) {
                    // 滚动且是列表滚动的时候
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                  return true;
                },
                child: ListView(
                  children: <Widget>[
                    Container(
                          height: 160,
                          child: Swiper(
                            itemCount: _imageUrls.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Image.network(
                                _imageUrls[index],
                                fit: BoxFit.cover,
                              );
                            },
                            pagination: SwiperPagination(),
                            autoplay: true,
                          ),
                        ) ??
                        Text('loading'),
                    Container(
                      height: 800,
                      child: ListTile(
                        title: Text('测试滚动'),
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
            // top: 10,
            width: MediaQuery.of(context).size.width,
            child: Opacity(
              opacity: appBarAlpha,
              child: Container(
                height: 100,
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('首页'),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
