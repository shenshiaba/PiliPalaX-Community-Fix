import 'dart:async';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:PiliPalaX/common/constants.dart';
import 'package:PiliPalaX/common/skeleton/video_card_v.dart';
import 'package:PiliPalaX/common/widgets/http_error.dart';
import 'package:PiliPalaX/pages/home/index.dart';
import 'package:PiliPalaX/pages/main/index.dart';

import '../../utils/grid.dart';
import '../../models/live/item.dart';
import 'controller.dart';
import 'widgets/live_item.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage>
    with AutomaticKeepAliveClientMixin {
  final LiveController _liveController = Get.put(LiveController());
  late ScrollController scrollController;
  late VoidCallback scrollListener;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _liveController.queryLiveList('init');
    scrollController = _liveController.scrollController;
    final StreamController<bool> mainStream =
        Get.find<MainController>().bottomBarStream;
    final StreamController<bool> searchBarStream =
        Get.find<HomeController>().searchBarStream;
    scrollListener = () {
      if (!scrollController.hasClients) {
        return;
      }
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        EasyThrottle.throttle('liveList', const Duration(milliseconds: 300),
            () {
          _liveController.onLoad();
        });
      }

      final ScrollDirection direction =
          scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.forward) {
        mainStream.add(true);
        searchBarStream.add(true);
      } else if (direction == ScrollDirection.reverse) {
        mainStream.add(false);
        searchBarStream.add(false);
      }
    };
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(
          left: StyleString.cardSpace, right: StyleString.cardSpace),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(StyleString.imgRadius),
      ),
      child: RefreshIndicator(
        displacement: 10.0,
        edgeOffset: 10.0,
        onRefresh: _liveController.onRefresh,
        child: CustomScrollView(
          cacheExtent: 3500,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          slivers: [
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(0, StyleString.cardSpace, 0, 0),
              sliver: Obx(() {
                if (_liveController.isInitialLoading.value &&
                    _liveController.liveList.isEmpty) {
                  return contentGrid(<LiveItemModel>[]);
                }
                if (_liveController.liveList.isEmpty &&
                    _liveController.errorMessage.value.isNotEmpty) {
                  return HttpError(
                    errMsg: _liveController.errorMessage.value,
                    fn: _liveController.retry,
                  );
                }
                if (_liveController.liveList.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: Center(child: Text('暂时没有直播内容')),
                    ),
                  );
                }
                return SliverMainAxisGroup(
                  slivers: [
                    contentGrid(_liveController.liveList),
                    if (_liveController.isLoadingMore.value)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    if (!_liveController.hasMore.value)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: Text('没有更多直播了')),
                        ),
                      ),
                    if (_liveController.errorMessage.value.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                _liveController.errorMessage.value,
                                textAlign: TextAlign.center,
                              ),
                              TextButton(
                                onPressed: _liveController.retry,
                                child: const Text('点击重试'),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentGrid(List<LiveItemModel> liveList) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithExtentAndRatio(
        mainAxisSpacing: StyleString.cardSpace,
        crossAxisSpacing: StyleString.cardSpace,
        maxCrossAxisExtent: Grid.maxRowWidth,
        childAspectRatio: StyleString.aspectRatio,
        mainAxisExtent: MediaQuery.textScalerOf(context).scale(80),
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return liveList.isNotEmpty
              ? LiveCardV(liveItem: liveList[index])
              : const VideoCardVSkeleton();
        },
        childCount: liveList.isNotEmpty ? liveList.length : 10,
      ),
    );
  }
}
