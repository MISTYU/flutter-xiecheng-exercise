import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:xiecheng_app/dao/home_dao.dart';
import 'package:xiecheng_app/model/common_model.dart';
import 'package:xiecheng_app/model/grid_nav_model.dart';
import 'package:xiecheng_app/model/hoem_model.dart';
import 'package:xiecheng_app/model/sales_box_model.dart';
import 'package:xiecheng_app/widgets/grid_nav.dart';
import 'package:xiecheng_app/widgets/loading_container.dart';
import 'package:xiecheng_app/widgets/local_nav..dart';
import 'package:xiecheng_app/widgets/sales_box.dart';
import 'package:xiecheng_app/widgets/sub_nav.dart';
import 'package:xiecheng_app/widgets/webview.dart';

const APPBAR_SCROLL_OFFSET = 100;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final List _imageUrls = [
  //   'https://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
  //   'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
  //   'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg',
  // ];
  double appBarAlpha = 0;
  String resultString = '';
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  List<CommonModel> subNavList = [];
  GridNavModel? gridNavModel;
  SalesBoxModel? salesBoxModel;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<void> _handleRefresh() async {
    print('objectssss');
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        bannerList = model.bannerList;
        _loading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

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
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: NotificationListener(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification &&
                          scrollNotification.depth == 0) {
                        // 滚动且是列表滚动的时候
                        _onScroll(scrollNotification.metrics.pixels);
                      }
                      return true;
                    },
                    child: _listView),
              ),
            ),
            Positioned(
              // top: 10,
              width: MediaQuery.of(context).size.width,
              child: _appBar,
            )
          ],
        ),
      ),
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        Container(
              height: 160,
              child: Swiper(
                itemCount: bannerList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          CommonModel model = bannerList[index];
                          return HiWebView(
                            url: model.url,
                            statusBarColor: model.statusBarColor ?? 'ffffff',
                            title: model.title ?? 'mistyu-title',
                            hideAppBar: model.hideAppBar ?? true,
                          );
                        }),
                      );
                    },
                    child: Image.network(
                      bannerList[index].icon!,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                pagination: SwiperPagination(),
                autoplay: true,
              ),
            ) ??
            Text('loading'),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: LocalNav(
            localNavList: localNavList,
          ),
        ),
        if (gridNavModel != null)
          Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: GridNav(gridNavModel: gridNavModel!),
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        if (salesBoxModel != null)
          Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SalesBox(salesBox: salesBoxModel!),
          ),
        // Container(
        //   height: 800,
        //   child: Padding(
        //     padding: EdgeInsets.only(top: 5),
        //     child: ListTile(
        //       title: Text('resultString'),
        //     ),
        //   ),
        // )
      ],
    );
  }

  Widget get _appBar {
    return Opacity(
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
    );
  }
}
