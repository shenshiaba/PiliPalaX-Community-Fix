bool? _parseBool(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    final String normalized = value.toLowerCase();
    if (normalized == 'true' || normalized == '1') {
      return true;
    }
    if (normalized == 'false' || normalized == '0') {
      return false;
    }
  }
  return null;
}

int? _parseInt(dynamic value) {
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

class FollowUpModel {
  FollowUpModel({
    this.liveUsers,
    this.upList,
  });

  LiveUsers? liveUsers;
  List<UpItem>? upList;

  FollowUpModel.fromJson(Map<String, dynamic> json) {
    liveUsers = json['live_users'] != null
        ? LiveUsers.fromJson(json['live_users'])
        : null;
    upList = json['up_list'] != null
        ? json['up_list'].map<UpItem>((e) => UpItem.fromJson(e)).toList()
        : [];
  }
}

class LiveUsers {
  LiveUsers({
    this.count,
    this.group,
    this.items,
  });

  int? count;
  String? group;
  List<LiveUserItem>? items;

  LiveUsers.fromJson(Map<String, dynamic> json) {
    count = _parseInt(json['count']);
    group = json['group'];
    items = json['items']
        .map<LiveUserItem>((e) => LiveUserItem.fromJson(e))
        .toList();
  }
}

class LiveUserItem {
  LiveUserItem({
    this.face,
    this.isReserveRecall,
    this.jumpUrl,
    this.mid,
    this.roomId,
    this.title,
    this.uname,
  });

  String? face;
  bool? isReserveRecall;
  String? jumpUrl;
  int? mid;
  int? roomId;
  String? title;
  String? uname;
  bool hasUpdate = false;
  String type = 'live';

  LiveUserItem.fromJson(Map<String, dynamic> json) {
    face = json['face'];
    isReserveRecall = _parseBool(json['is_reserve_recall']);
    jumpUrl = json['jump_url'];
    mid = _parseInt(json['mid']);
    roomId = _parseInt(json['room_id']);
    title = json['title'];
    uname = json['uname'];
  }
}

class UpItem {
  UpItem({
    this.face,
    this.hasUpdate,
    // this.isReserveRecall,
    this.mid,
    this.uname,
  });

  String? face;
  bool? hasUpdate;
  // bool? isReserveRecall;
  int? mid;
  String? uname;
  String type = 'up';

  UpItem.fromJson(Map<String, dynamic> json) {
    face = json['face'];
    hasUpdate = _parseBool(json['has_update']);
    // isReserveRecall = json['is_reserve_recall'];
    mid = _parseInt(json['mid']);
    uname = json['uname'];
  }
}
