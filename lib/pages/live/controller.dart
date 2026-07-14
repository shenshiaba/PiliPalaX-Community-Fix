import 'dart:developer' as developer;

import 'package:PiliPalaX/http/live.dart';
import 'package:PiliPalaX/models/live/item.dart';
import 'package:PiliPalaX/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:PiliPalaX/utils/storage.dart';

class LiveController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final int pageSize = 30;
  int _currentPage = 1;
  bool _hasMore = true;
  Future<Map<String, dynamic>>? _requestFuture;

  final RxInt crossAxisCount = 2.obs;
  final RxList<LiveItemModel> liveList = <LiveItemModel>[].obs;
  final RxBool isInitialLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString errorMessage = ''.obs;

  Box setting = GStorage.setting;

  Future<Map<String, dynamic>> queryLiveList(String type) async {
    final bool isLoadMore = type == 'onLoad';
    final bool isRefresh = type == 'onRefresh';

    if ((type == 'init' || isRefresh) && _requestFuture != null) {
      if (isRefresh && isRefreshing.value) {
        return _requestFuture!;
      }
      if (type == 'init') {
        return _requestFuture!;
      }
    }

    if (isLoadMore) {
      if (!_hasMore || isLoadingMore.value || isRefreshing.value) {
        return <String, dynamic>{'status': true, 'skipped': true};
      }
      if (_requestFuture != null) {
        return _requestFuture!;
      }
    }

    if (isRefresh && _requestFuture != null) {
      await _requestFuture;
    }

    final bool isInitial = type == 'init' ||
        (type == 'onRefresh' && liveList.isEmpty && _currentPage == 1);
    if (isRefresh || type == 'init') {
      _currentPage = 1;
      _hasMore = true;
      hasMore.value = true;
      errorMessage.value = '';
    }

    if (isInitial) {
      isInitialLoading.value = true;
    }
    if (isRefresh) {
      isRefreshing.value = true;
    }
    if (isLoadMore) {
      isLoadingMore.value = true;
    }

    final int requestedPage = _currentPage;
    final Future<Map<String, dynamic>> request = _fetchPage(requestedPage);
    _requestFuture = request;
    try {
      final Map<String, dynamic> res = await request;
      if (res['status'] == true) {
        final List<LiveItemModel> items =
            (res['data'] as List<LiveItemModel>?) ?? <LiveItemModel>[];
        if (isLoadMore) {
          liveList.addAll(items);
        } else {
          liveList.assignAll(items);
        }
        _currentPage = requestedPage + 1;
        _hasMore = res['hasMore'] == true && items.isNotEmpty;
        hasMore.value = _hasMore;
        errorMessage.value = '';
      } else {
        errorMessage.value = res['msg']?.toString() ?? '直播主页加载失败，请点击重试';
        developer.log(
          'live page request failed page=$requestedPage type=$type '
          'errorType=${res['errorType']} code=${res['code']}',
          name: 'LiveController',
        );
      }
      return res;
    } finally {
      if (identical(_requestFuture, request)) {
        _requestFuture = null;
      }
      if (isInitial) {
        isInitialLoading.value = false;
      }
      if (isRefresh) {
        isRefreshing.value = false;
      }
      if (isLoadMore) {
        isLoadingMore.value = false;
      }
    }
  }

  Future<Map<String, dynamic>> _fetchPage(int page) {
    return LiveHttp.liveList(pn: page, ps: pageSize);
  }

  Future<void> onRefresh() async {
    await queryLiveList('onRefresh');
  }

  Future<void> onLoad() async {
    await queryLiveList('onLoad');
  }

  Future<void> retry() async {
    await queryLiveList(liveList.isEmpty ? 'init' : 'onRefresh');
  }

  void animateToTop() {
    scrollController.animToTop();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
