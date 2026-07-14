class LiveItemModel {
  LiveItemModel({
    this.roomId,
    this.uid,
    this.title,
    this.uname,
    this.online,
    this.userCover,
    this.userCoverFlag,
    this.systemCover,
    this.cover,
    this.pic,
    this.link,
    this.face,
    this.parentId,
    this.parentName,
    this.areaId,
    this.areaName,
    this.sessionId,
    this.groupId,
    this.pkId,
    this.verify,
    this.headBox,
    this.headBoxType,
    this.watchedShow,
  });

  int? roomId;
  int? uid;
  String? title;
  String? uname;
  int? online;
  String? userCover;
  int? userCoverFlag;
  String? systemCover;
  String? cover;
  String? pic;
  String? link;
  String? face;
  int? parentId;
  String? parentName;
  int? areaId;
  String? areaName;
  String? sessionId;
  int? groupId;
  int? pkId;
  Map? verify;
  Map? headBox;
  int? headBoxType;
  Map? watchedShow;

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? double.tryParse(value)?.toInt();
    }
    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }
    if (value is num || value is bool) {
      return value.toString();
    }
    return null;
  }

  static Map? _parseMap(dynamic value) {
    return value is Map ? value : null;
  }

  LiveItemModel.fromJson(Map<String, dynamic> json) {
    roomId = _parseInt(json['roomid']);
    uid = _parseInt(json['uid']);
    title = _parseString(json['title']);
    uname = _parseString(json['uname']);
    online = _parseInt(json['online']);
    userCover = _parseString(json['user_cover']);
    userCoverFlag = _parseInt(json['user_cover_flag']);
    systemCover = _parseString(json['system_cover']);
    cover = _parseString(json['cover']);
    pic = cover;
    link = _parseString(json['link']);
    face = _parseString(json['face']);
    parentId = _parseInt(json['parent_id'] ?? json['parent_area_id']);
    parentName = _parseString(json['parent_name'] ?? json['parent_area_name']);
    areaId = _parseInt(json['area_id'] ?? json['area_v2_id']);
    areaName = _parseString(json['area_name'] ?? json['area_v2_name']);
    sessionId = _parseString(json['session_id']);
    groupId = _parseInt(json['group_id']);
    pkId = _parseInt(json['pk_id']);
    verify = _parseMap(json['verify']);
    headBox = _parseMap(json['head_box']);
    headBoxType = _parseInt(json['head_box_type']);
    watchedShow = _parseMap(json['watched_show']);
  }
}
