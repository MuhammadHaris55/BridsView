class GetBookmarksModel {
  final int? status;
  final String? message;
  final List<Data>? data;
  const GetBookmarksModel({this.status, this.message, this.data});
  GetBookmarksModel copyWith({int? status, String? message, List<Data>? data}) {
    return GetBookmarksModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data);
  }

  Map<String, Object?> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  static GetBookmarksModel fromJson(Map<String, Object?> json) {
    return GetBookmarksModel(
        status: json['status'] == null ? null : json['status'] as int,
        message: json['message'] == null ? null : json['message'] as String,
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                .map<Data>(
                    (data) => Data.fromJson(data as Map<String, Object?>))
                .toList());
  }

  @override
  String toString() {
    return '''GetBookmarksModel(
                status:$status,
message:$message,
data:${data.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is GetBookmarksModel &&
        other.runtimeType == runtimeType &&
        other.status == status &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, status, message, data);
  }
}

class Data {
  final int? id;
  final int? userId;
  final String? barPlaceId;
  final String? createdAt;
  final String? updatedAt;
  const Data(
      {this.id, this.userId, this.barPlaceId, this.createdAt, this.updatedAt});
  Data copyWith(
      {int? id,
      int? userId,
      String? barPlaceId,
      String? createdAt,
      String? updatedAt}) {
    return Data(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        barPlaceId: barPlaceId ?? this.barPlaceId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bar_place_id': barPlaceId,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }

  static Data fromJson(Map<String, Object?> json) {
    return Data(
        id: json['id'] == null ? null : json['id'] as int,
        userId: json['user_id'] == null ? null : json['user_id'] as int,
        barPlaceId: json['bar_place_id'] == null
            ? null
            : json['bar_place_id'] as String,
        createdAt:
            json['created_at'] == null ? null : json['created_at'] as String,
        updatedAt:
            json['updated_at'] == null ? null : json['updated_at'] as String);
  }

  @override
  String toString() {
    return '''Data(
                id:$id,
userId:$userId,
barPlaceId:$barPlaceId,
createdAt:$createdAt,
updatedAt:$updatedAt
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Data &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.userId == userId &&
        other.barPlaceId == barPlaceId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, id, userId, barPlaceId, createdAt, updatedAt);
  }
}
