class MediaModel {
  int? mediaId;
  String? content;
  String? mediaUrl;
  String? updatedAt;
  String? mediaKey;
  String? fileName;
  String? mediaPass;

  MediaModel(
      {this.mediaId,
      this.content,
      this.mediaUrl,
      this.updatedAt,
      this.mediaKey,
      this.fileName,
      this.mediaPass});

  MediaModel.fromJson(Map<String, dynamic> json) {
    mediaId = json['media_id'] ?? "";
    content = json['content'] ?? "";
    mediaUrl = json['media_url'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    mediaKey = json['media_key'] ?? "";
    fileName = json['file_name'] ?? "";
    mediaPass = json['media_pass'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['media_id'] = mediaId ?? "";
    data['content'] = content ?? "";
    data['media_url'] = mediaUrl ?? "";
    data['updated_at'] = updatedAt ?? "";
    data['media_key'] = mediaKey ?? "";
    data['file_name'] = fileName ?? "";
    data['media_pass'] = mediaPass ?? "";
    return data;
  }
}
