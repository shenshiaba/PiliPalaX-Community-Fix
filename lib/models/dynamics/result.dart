import 'dart:convert';

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

double? _parseDouble(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

String? _parseString(dynamic value) {
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

class DynamicsDataModel {
  DynamicsDataModel({this.hasMore, this.items, this.offset});
  bool? hasMore;
  List<DynamicItemModel>? items;
  String? offset;

  DynamicsDataModel.fromJson(Map<String, dynamic> json) {
    hasMore = _parseBool(json['has_more']);
    items = json['items']
        .map<DynamicItemModel>((e) => DynamicItemModel.fromJson(e))
        .toList();
    offset = _parseString(json['offset']);
  }
}

// 单个动态
class DynamicItemModel {
  DynamicItemModel({
    this.basic,
    this.idStr,
    this.modules,
    this.orig,
    this.type,
    this.visible,
  });

  Map? basic;
  String? idStr;
  ItemModulesModel? modules;
  ItemOrigModel? orig;
  String? type;
  bool? visible;

  DynamicItemModel.fromJson(Map<String, dynamic> json) {
    basic = json['basic'];
    idStr = _parseString(json['id_str']);
    modules = ItemModulesModel.fromJson(json['modules']);
    orig = json['orig'] != null ? ItemOrigModel.fromJson(json['orig']) : null;
    type = _parseString(json['type']);
    visible = _parseBool(json['visible']);
  }
}

class ItemOrigModel {
  ItemOrigModel({
    this.basic,
    this.isStr,
    this.modules,
    this.type,
    this.visible,
  });

  Map? basic;
  String? isStr;
  ItemModulesModel? modules;
  String? type;
  bool? visible;

  ItemOrigModel.fromJson(Map<String, dynamic> json) {
    basic = json['basic'];
    isStr = _parseString(json['is_str']);
    modules = ItemModulesModel.fromJson(json['modules']);
    type = _parseString(json['type']);
    visible = _parseBool(json['visible']);
  }
}

// 单个动态详情
class ItemModulesModel {
  ItemModulesModel({
    this.moduleAuthor,
    this.moduleDynamic,
    // this.moduleInter,
    this.moduleStat,
    this.moduleTag,
  });

  ModuleAuthorModel? moduleAuthor;
  ModuleDynamicModel? moduleDynamic;
  // ModuleInterModel? moduleInter;
  ModuleStatModel? moduleStat;
  Map? moduleTag;

  ItemModulesModel.fromJson(Map<String, dynamic> json) {
    moduleAuthor = json['module_author'] != null
        ? ModuleAuthorModel.fromJson(json['module_author'])
        : null;
    moduleDynamic = json['module_dynamic'] != null
        ? ModuleDynamicModel.fromJson(json['module_dynamic'])
        : null;
    // moduleInter = ModuleInterModel.fromJson(json['module_interaction']);
    moduleStat = json['module_stat'] != null
        ? ModuleStatModel.fromJson(json['module_stat'])
        : null;
    moduleTag = json['module_tag'];
  }
}

// 单个动态详情 - 作者信息
class ModuleAuthorModel {
  ModuleAuthorModel({
    // this.avatar,
    // this.decorate,
    this.face,
    this.following,
    this.jumpUrl,
    this.label,
    this.mid,
    this.name,
    // this.officialVerify,
    // this.pandant,
    this.pubAction,
    // this.pubLocationText,
    this.pubTime,
    this.pubTs,
    this.type,
    this.vip,
  });

  String? face;
  bool? following;
  String? jumpUrl;
  String? label;
  int? mid;
  String? name;
  String? pubAction;
  String? pubTime;
  int? pubTs;
  String? type;
  Map? vip;

  ModuleAuthorModel.fromJson(Map<String, dynamic> json) {
    face = _parseString(json['face']);
    following = _parseBool(json['following']);
    jumpUrl = _parseString(json['jump_url']);
    label = _parseString(json['label']);
    mid = _parseInt(json['mid']);
    name = _parseString(json['name']);
    pubAction = _parseString(json['pub_action']);
    pubTime = _parseString(json['pub_time']);
    final int? parsedPubTs = _parseInt(json['pub_ts']);
    pubTs = parsedPubTs == 0 ? null : parsedPubTs;
    type = _parseString(json['type']);
    vip = json['vip'];
  }
}

// 单个动态详情 - 动态信息
class ModuleDynamicModel {
  ModuleDynamicModel({this.additional, this.desc, this.major, this.topic});

  DynamicAddModel? additional;
  DynamicDescModel? desc;
  DynamicMajorModel? major;
  DynamicTopicModel? topic;

  ModuleDynamicModel.fromJson(Map<String, dynamic> json) {
    additional = json['additional'] != null
        ? DynamicAddModel.fromJson(json['additional'])
        : null;
    desc =
        json['desc'] != null ? DynamicDescModel.fromJson(json['desc']) : null;
    if (json['major'] != null) {
      major = DynamicMajorModel.fromJson(json['major']);
    }
    topic = json['topic'] != null
        ? DynamicTopicModel.fromJson(json['topic'])
        : null;
  }
}

// 单个动态详情 - 评论？信息
// class ModuleInterModel {
//   ModuleInterModel({

//   });

//   ModuleInterModel.fromJson(Map<String, dynamic> json) {

//   }
// }
class DynamicAddModel {
  DynamicAddModel({this.type, this.vote, this.ugc, this.reserve, this.goods});

  String? type;
  Vote? vote;
  Ugc? ugc;
  Reserve? reserve;
  Good? goods;

  /// TODO 比赛vs
  String? match;

  /// TODO 游戏信息
  String? common;

  DynamicAddModel.fromJson(Map<String, dynamic> json) {
    type = _parseString(json['type']);
    vote = json['vote'] != null ? Vote.fromJson(json['vote']) : null;
    ugc = json['ugc'] != null ? Ugc.fromJson(json['ugc']) : null;
    reserve =
        json['reserve'] != null ? Reserve.fromJson(json['reserve']) : null;
    goods = json['goods'] != null ? Good.fromJson(json['goods']) : null;
  }
}

class Vote {
  Vote({
    this.choiceCnt,
    this.defaultShare,
    this.share,
    this.endTime,
    this.joinNum,
    this.status,
    this.type,
    this.uid,
    this.voteId,
  });

  int? choiceCnt;
  String? share;
  int? defaultShare;
  int? endTime;
  int? joinNum;
  int? status;
  int? type;
  int? uid;
  int? voteId;

  Vote.fromJson(Map<String, dynamic> json) {
    choiceCnt = _parseInt(json['choice_cnt']);
    share = _parseString(json['share']);
    defaultShare = _parseInt(json['default_share']);
    endTime = _parseInt(json['end_time']);
    joinNum = _parseInt(json['join_num']);
    status = _parseInt(json['status']);
    type = _parseInt(json['type']);
    uid = _parseInt(json['uid']);
    voteId = _parseInt(json['vote_id']);
  }
}

class Ugc {
  Ugc({
    this.cover,
    this.descSecond,
    this.duration,
    this.headText,
    this.idStr,
    this.jumpUrl,
    this.multiLine,
    this.title,
  });

  String? cover;
  String? descSecond;
  String? duration;
  String? headText;
  String? idStr;
  String? jumpUrl;
  bool? multiLine;
  String? title;

  Ugc.fromJson(Map<String, dynamic> json) {
    cover = _parseString(json['cover']);
    descSecond = _parseString(json['desc_second']);
    duration = _parseString(json['duration']);
    headText = _parseString(json['head_text']);
    idStr = _parseString(json['id_str']);
    jumpUrl = _parseString(json['jump_url']);
    multiLine = _parseBool(json['multi_line']);
    title = _parseString(json['title']);
  }
}

class Reserve {
  Reserve({
    this.button,
    this.desc1,
    this.desc2,
    this.jumpUrl,
    this.reserveTotal,
    this.rid,
    this.state,
    this.stype,
    this.title,
    this.upMid,
  });

  Map? button;
  Map? desc1;
  Map? desc2;
  String? jumpUrl;
  int? reserveTotal;
  int? rid;
  int? state;
  int? stype;
  String? title;
  int? upMid;

  Reserve.fromJson(Map<String, dynamic> json) {
    button = json['button'];
    desc1 = json['desc1'];
    desc2 = json['desc2'];
    jumpUrl = _parseString(json['jump_url']);
    reserveTotal = _parseInt(json['reserve_total']);
    rid = _parseInt(json['rid']);
    state = _parseInt(json['state']);
    stype = _parseInt(json['stype']);
    title = _parseString(json['title']);
    upMid = _parseInt(json['up_mid']);
  }
}

class Good {
  Good({this.headIcon, this.headText, this.items, this.jumpUrl});

  String? headIcon;
  String? headText;
  List<GoodItem>? items;
  String? jumpUrl;

  Good.fromJson(Map<String, dynamic> json) {
    headIcon = _parseString(json['head_icon']);
    headText = _parseString(json['head_text']);
    items = json['items'].map<GoodItem>((e) => GoodItem.fromJson(e)).toList();
    jumpUrl = _parseString(json['jump_url']);
  }
}

class GoodItem {
  GoodItem({
    this.brief,
    this.cover,
    this.id,
    this.jumpDesc,
    this.jumpUrl,
    this.name,
    this.price,
  });

  String? brief;
  String? cover;
  dynamic id;
  String? jumpDesc;
  String? jumpUrl;
  String? name;
  String? price;

  GoodItem.fromJson(Map<String, dynamic> json) {
    brief = _parseString(json['brief']);
    cover = _parseString(json['cover']);
    id = json['id'];
    jumpDesc = _parseString(json['jump_desc']);
    jumpUrl = _parseString(json['jump_url']);
    name = _parseString(json['name']);
    price = _parseString(json['price']);
  }
}

class DynamicDescModel {
  DynamicDescModel({this.richTextNodes, this.text});

  List<RichTextNodeItem>? richTextNodes;
  String? text;

  DynamicDescModel.fromJson(Map<String, dynamic> json) {
    richTextNodes = json['rich_text_nodes'] != null
        ? json['rich_text_nodes']
            .map<RichTextNodeItem>((e) => RichTextNodeItem.fromJson(e))
            .toList()
        : [];
    text = _parseString(json['text']);
  }
}

//
class DynamicMajorModel {
  DynamicMajorModel({
    this.archive,
    this.draw,
    this.ugcSeason,
    this.opus,
    this.pgc,
    this.liveRcmd,
    this.live,
    this.none,
    this.type,
    this.courses,
  });

  DynamicArchiveModel? archive;
  DynamicDrawModel? draw;
  DynamicArchiveModel? ugcSeason;
  DynamicOpusModel? opus;
  DynamicArchiveModel? pgc;
  DynamicLiveModel? liveRcmd;
  DynamicLive2Model? live;
  DynamicNoneModel? none;
  DynamicCommonModel? common;
  // MAJOR_TYPE_DRAW 图片
  // MAJOR_TYPE_ARCHIVE 视频
  // MAJOR_TYPE_OPUS 图文/文章
  String? type;
  Map? courses;

  DynamicMajorModel.fromJson(Map<String, dynamic> json) {
    archive = json['archive'] != null
        ? DynamicArchiveModel.fromJson(json['archive'])
        : null;
    draw =
        json['draw'] != null ? DynamicDrawModel.fromJson(json['draw']) : null;
    ugcSeason = json['ugc_season'] != null
        ? DynamicArchiveModel.fromJson(json['ugc_season'])
        : null;
    opus =
        json['opus'] != null ? DynamicOpusModel.fromJson(json['opus']) : null;
    pgc =
        json['pgc'] != null ? DynamicArchiveModel.fromJson(json['pgc']) : null;
    liveRcmd = json['live_rcmd'] != null
        ? DynamicLiveModel.fromJson(json['live_rcmd'])
        : null;
    live =
        json['live'] != null ? DynamicLive2Model.fromJson(json['live']) : null;
    common = json['common'] != null
        ? DynamicCommonModel.fromJson(json['common'])
        : null;
    none =
        json['none'] != null ? DynamicNoneModel.fromJson(json['none']) : null;
    type = _parseString(json['type']);
    courses = json['courses'] ?? {};
  }
}

class DynamicTopicModel {
  DynamicTopicModel({this.id, this.jumpUrl, this.name});

  int? id;
  String? jumpUrl;
  String? name;

  DynamicTopicModel.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    jumpUrl = _parseString(json['jump_url']);
    name = _parseString(json['name']);
  }
}

class DynamicArchiveModel {
  DynamicArchiveModel({
    this.aid,
    this.badge,
    this.bvid,
    this.cover,
    this.desc,
    this.disablePreview,
    this.durationText,
    this.jumpUrl,
    this.stat,
    this.title,
    this.type,
    this.epid,
    this.seasonId,
  });

  int? aid;
  Map? badge;
  String? bvid;
  String? cover;
  String? desc;
  int? disablePreview;
  String? durationText;
  String? jumpUrl;
  Stat? stat;
  String? title;
  int? type;
  int? epid;
  int? seasonId;

  DynamicArchiveModel.fromJson(Map<String, dynamic> json) {
    aid = _parseInt(json['aid']);
    badge = json['badge'];
    bvid = _parseString(json['bvid']) ?? _parseString(json['epid']) ?? ' ';
    cover = _parseString(json['cover']);
    disablePreview = _parseInt(json['disable_preview']);
    durationText = _parseString(json['duration_text']);
    jumpUrl = _parseString(json['jump_url']);
    stat = json['stat'] != null ? Stat.fromJson(json['stat']) : null;
    title = _parseString(json['title']);
    type = _parseInt(json['type']);
    epid = _parseInt(json['epid']);
    seasonId = _parseInt(json['season_id']);
  }
}

class DynamicDrawModel {
  DynamicDrawModel({this.id, this.items});

  int? id;
  List<DynamicDrawItemModel>? items;

  DynamicDrawModel.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    // ignore: prefer_null_aware_operators
    items = json['items'] != null
        ? json['items']
            .map<DynamicDrawItemModel>(
              (e) => DynamicDrawItemModel.fromJson(e),
            )
            .toList()
        : null;
  }
}

class DynamicOpusModel {
  DynamicOpusModel({this.jumpUrl, this.pics, this.summary, this.title});

  String? jumpUrl;
  List<OpusPicsModel>? pics;
  SummaryModel? summary;
  String? title;
  DynamicOpusModel.fromJson(Map<String, dynamic> json) {
    jumpUrl = _parseString(json['jump_url']);
    pics = json['pics'] != null
        ? json['pics']
            .map<OpusPicsModel>((e) => OpusPicsModel.fromJson(e))
            .toList()
        : [];
    summary =
        json['summary'] != null ? SummaryModel.fromJson(json['summary']) : null;
    title = _parseString(json['title']);
  }
}

class DynamicCommonModel {
  DynamicCommonModel({
    this.badge,
    this.jumpUrl,
    this.cover,
    this.label,
    this.desc,
    this.id,
    this.sketchId,
    this.style,
    this.title,
  });

  Map? badge;
  String? jumpUrl;
  String? cover;
  String? label;
  String? desc;
  String? id;
  String? sketchId;
  int? style;
  String? title;

  DynamicCommonModel.fromJson(Map<String, dynamic> json) {
    badge = json['badge'];
    jumpUrl = _parseString(json['jump_url']);
    cover = _parseString(json['cover']);
    label = _parseString(json['label']);
    desc = _parseString(json['desc']);
    id = _parseString(json['id']);
    sketchId = _parseString(json['sketch_id']);
    style = _parseInt(json['style']);
    title = _parseString(json['title']);
  }
}

class SummaryModel {
  SummaryModel({this.richTextNodes, this.text});

  List<RichTextNodeItem>? richTextNodes;
  String? text;

  SummaryModel.fromJson(Map<String, dynamic> json) {
    richTextNodes = json['rich_text_nodes']
        .map<RichTextNodeItem>((e) => RichTextNodeItem.fromJson(e))
        .toList();
    text = _parseString(json['text']);
  }
}

class RichTextNodeItem {
  RichTextNodeItem({this.emoji, this.origText, this.text, this.type, this.rid});
  Emoji? emoji;
  String? origText;
  String? text;
  String? type;
  String? rid;

  RichTextNodeItem.fromJson(Map<String, dynamic> json) {
    emoji = json['emoji'] != null ? Emoji.fromJson(json['emoji']) : null;
    origText = _parseString(json['orig_text']);
    text = _parseString(json['text']);
    type = _parseString(json['type']);
    rid = _parseString(json['rid']);
  }
}

class Emoji {
  Emoji({this.iconUrl, this.size, this.text, this.type});

  String? iconUrl;
  double? size;
  String? text;
  int? type;
  Emoji.fromJson(Map<String, dynamic> json) {
    iconUrl = _parseString(json['icon_url']);
    size = _parseDouble(json['size']);
    text = _parseString(json['text']);
    type = _parseInt(json['type']);
  }
}

class DynamicNoneModel {
  DynamicNoneModel({this.tips});
  String? tips;
  DynamicNoneModel.fromJson(Map<String, dynamic> json) {
    tips = _parseString(json['tips']);
  }
}

class OpusPicsModel {
  OpusPicsModel({this.width, this.height, this.size, this.src, this.url});

  int? width;
  int? height;
  int? size;
  String? src;
  String? url;

  OpusPicsModel.fromJson(Map<String, dynamic> json) {
    width = _parseInt(json['width']);
    height = _parseInt(json['height']);
    size = _parseInt(json['size']) ?? 0;
    src = _parseString(json['src']);
    url = _parseString(json['url']);
  }
}

class DynamicDrawItemModel {
  DynamicDrawItemModel({
    this.height,
    this.size,
    this.src,
    this.tags,
    this.width,
  });
  int? height;
  int? size;
  String? src;
  List? tags;
  int? width;
  DynamicDrawItemModel.fromJson(Map<String, dynamic> json) {
    height = _parseInt(json['height']);
    size = _parseInt(json['size']);
    src = _parseString(json['src']);
    tags = json['tags'];
    width = _parseInt(json['width']);
  }
}

class DynamicLiveModel {
  DynamicLiveModel({this.content});

  String? content;
  int? type;
  Map? livePlayInfo;
  int? uid;
  String? parentAreaName;
  int? roomId;
  String? liveId;
  int? liveStatus;
  String? cover;
  int? online;
  String? areaName;
  String? title;
  int? liveStartTime;
  Map? watchedShow;

  DynamicLiveModel.fromJson(Map<String, dynamic> json) {
    content = _parseString(json['content']);
    if (content != null) {
      Map<String, dynamic> data = jsonDecode(content!);

      type = _parseInt(data['type']);
      Map livePlayInfo = data['live_play_info'];
      uid = _parseInt(livePlayInfo['uid']);
      parentAreaName = _parseString(livePlayInfo['parent_area_name']);
      roomId = _parseInt(livePlayInfo['room_id']);
      liveId = _parseString(livePlayInfo['live_id']);
      liveStatus = _parseInt(livePlayInfo['live_status']);
      cover = _parseString(livePlayInfo['cover']);
      online = _parseInt(livePlayInfo['online']);
      areaName = _parseString(livePlayInfo['area_name']);
      title = _parseString(livePlayInfo['title']);
      liveStartTime = _parseInt(livePlayInfo['live_start_time']);
      watchedShow = livePlayInfo['watched_show'];
    }
  }
}

class DynamicLive2Model {
  DynamicLive2Model({
    this.badge,
    this.cover,
    this.descFirst,
    this.descSecond,
    this.id,
    this.jumpUrl,
    this.liveState,
    this.reserveType,
    this.title,
  });

  Map? badge;
  String? cover;
  String? descFirst;
  String? descSecond;
  int? id;
  String? jumpUrl;
  int? liveState;
  int? reserveType;
  String? title;

  DynamicLive2Model.fromJson(Map<String, dynamic> json) {
    badge = json['badge'];
    cover = _parseString(json['cover']);
    descFirst = _parseString(json['desc_first']);
    descSecond = _parseString(json['desc_second']);
    id = _parseInt(json['id']);
    jumpUrl = _parseString(json['jump_url']);
    liveState = _parseInt(json['liv_state']);
    reserveType = _parseInt(json['reserve_type']);
    title = _parseString(json['title']);
  }
}

// 动态状态 转发、评论、点赞
class ModuleStatModel {
  ModuleStatModel({this.comment, this.forward, this.like});

  Comment? comment;
  ForWard? forward;
  Like? like;

  ModuleStatModel.fromJson(Map<String, dynamic> json) {
    comment = Comment.fromJson(json['comment']);
    forward = ForWard.fromJson(json['forward']);
    like = Like.fromJson(json['like']);
  }
}

// 动态状态 评论
class Comment {
  Comment({this.count, this.forbidden});

  String? count;
  bool? forbidden;

  Comment.fromJson(Map<String, dynamic> json) {
    count = json['count'] == 0 ? null : json['count'].toString();
    forbidden = _parseBool(json['forbidden']);
  }
}

class ForWard {
  ForWard({this.count, this.forbidden});
  String? count;
  bool? forbidden;

  ForWard.fromJson(Map<String, dynamic> json) {
    count = json['count'] == 0 ? null : json['count'].toString();
    forbidden = _parseBool(json['forbidden']);
  }
}

// 动态状态 点赞
class Like {
  Like({this.count, this.forbidden, this.status});

  String? count;
  bool? forbidden;
  bool? status;

  Like.fromJson(Map<String, dynamic> json) {
    count = json['count'] == 0 ? null : json['count'].toString();
    forbidden = _parseBool(json['forbidden']);
    status = _parseBool(json['status']);
  }
}

class Stat {
  Stat({this.danmu, this.play});

  String? danmu;
  String? play;

  Stat.fromJson(Map<String, dynamic> json) {
    danmu = _parseString(json['danmaku']);
    play = _parseString(json['play']);
  }
}
