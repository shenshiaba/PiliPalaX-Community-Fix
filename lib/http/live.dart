import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../models/live/item.dart';
import '../models/live/room_info.dart';
import '../models/live/room_info_h5.dart';
import '../utils/wbi_sign.dart';
import 'api.dart';
import 'init.dart';

class LiveHttp {
  static const int _pageSize = 30;

  static String _errorMsg(Map data) {
    const errMap = {
      -352: '风控校验失败，请检查登录状态或稍后重试',
    };
    final dynamic message = data['message'];
    return errMap[data['code']] ??
        (message is String && message.isNotEmpty
            ? message
            : '请求数据发生错误，请刷新或稍后重试');
  }

  static bool _isRiskControl(Map<String, dynamic> data) => data['code'] == -352;

  static bool _isNetworkFailure(dynamic message) {
    if (message is! String) {
      return false;
    }
    return message.contains('HandshakeException') ||
        message.contains('网络') ||
        message.contains('连接') ||
        message.contains('超时');
  }

  static Future<Response<dynamic>> _requestLiveList({
    bool retry = false,
  }) async {
    final Map<String, dynamic> params = {
      'platform': 'web',
      'web_location': '444.7',
    };
    final Map<String, dynamic> signedParams = await WbiSign().makSign(params);
    final Response<dynamic> response = await Request().get(
      Api.liveList,
      data: signedParams,
      options: Options(headers: {
        'accept': 'application/json, text/plain, */*',
        'origin': 'https://www.bilibili.com',
        'referer': 'https://www.bilibili.com/',
        if (retry)
          'user-agent': 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 '
              '(KHTML, like Gecko) Chrome/120.0 Mobile Safari/537.36',
      }),
    );
    developer.log(
      'live list response code=${response.data is Map ? response.data['code'] : 'invalid'}',
      name: 'LiveHttp',
    );
    return response;
  }

  static Future<Map<String, dynamic>> liveList(
      {int? vmid, int? pn, int? ps, String? orderType}) async {
    final int page = pn == null || pn < 1 ? 1 : pn;
    Response<dynamic> res;
    try {
      res = await _requestLiveList();
      if (res.data is Map<String, dynamic> && _isRiskControl(res.data)) {
        res = await _requestLiveList(retry: true);
      }
    } catch (error, stackTrace) {
      developer.log('live list request failed page=$page',
          name: 'LiveHttp', error: error, stackTrace: stackTrace);
      return {
        'status': false,
        'data': <LiveItemModel>[],
        'hasMore': false,
        'errorType': 'network',
        'msg': error.toString(),
      };
    }

    final dynamic body = res.data;
    if (body is Map<String, dynamic> && body['code'] == 0) {
      final dynamic data = body['data'];
      if (data is! Map) {
        developer.log('live list response has invalid list type',
            name: 'LiveHttp');
        return {
          'status': false,
          'data': <LiveItemModel>[],
          'hasMore': false,
          'errorType': 'data',
          'msg': '直播推荐数据格式异常，请点击重试',
        };
      }
      final List<dynamic> rawList = <dynamic>[];
      final dynamic recommend = data['recommend_room_list'];
      if (recommend is List) {
        rawList.addAll(recommend);
      }
      final dynamic modules = data['room_list'];
      if (modules is List) {
        for (final dynamic module in modules) {
          if (module is Map && module['list'] is List) {
            rawList.addAll(module['list'] as List);
          }
        }
      }
      if (rawList.isEmpty) {
        developer.log('live list response has no room items', name: 'LiveHttp');
      }
      final List<LiveItemModel> items = <LiveItemModel>[];
      final Set<int> roomIds = <int>{};
      for (final dynamic item in rawList) {
        if (item is Map) {
          final LiveItemModel parsed =
              LiveItemModel.fromJson(Map<String, dynamic>.from(item));
          if (parsed.roomId != null &&
              parsed.cover != null &&
              roomIds.add(parsed.roomId!)) {
            items.add(parsed);
          } else {
            developer.log('skip live item without roomId or cover',
                name: 'LiveHttp');
          }
        }
      }
      return {
        'status': true,
        'data': items,
        'hasMore': false,
        'errorType': null,
      };
    }

    if (body is Map<String, dynamic>) {
      final int? code = body['code'] is int ? body['code'] as int : null;
      final dynamic message = body['message'];
      final bool networkFailure = _isNetworkFailure(message);
      developer.log('live list failed page=$page code=$code', name: 'LiveHttp');
      return {
        'status': false,
        'data': <LiveItemModel>[],
        'hasMore': false,
        'errorType': code == -352
            ? 'riskControl'
            : networkFailure
                ? 'network'
                : 'server',
        'code': code,
        'msg': _errorMsg(body),
      };
    }
    return {
      'status': false,
      'data': <LiveItemModel>[],
      'hasMore': false,
      'errorType': 'data',
      'msg': '直播推荐响应异常，请点击重试',
    };
  }

  static Future liveRoomInfo({roomId, qn}) async {
    var res = await Request().get(Api.liveRoomInfo, data: {
      'room_id': roomId,
      'protocol': '0, 1',
      'format': '0, 1, 2',
      'codec': '0, 1',
      'qn': qn,
      'platform': 'web',
      'ptype': 8,
      'dolby': 5,
      'panorama': 1,
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': RoomInfoModel.fromJson(res.data['data'])};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': _errorMsg(res.data),
      };
    }
  }

  static Future liveRoomInfoH5({roomId, qn}) async {
    var res = await Request().get(Api.liveRoomInfoH5, data: {
      'room_id': roomId,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': RoomInfoH5Model.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': _errorMsg(res.data),
      };
    }
  }
}
