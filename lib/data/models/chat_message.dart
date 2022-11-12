class ChatMessage {
  String? sId;
  String? chatID;
  String? userID;
  String? message;
  List<String>? urlImageMessage;
  String? urlRecordMessage;
  String? stampTimeMessage;
  String? typeMessage;
  String? messageStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ChatMessage(
      {this.sId,
      this.chatID,
      this.userID,
      this.message,
      this.urlImageMessage,
      this.urlRecordMessage,
      this.stampTimeMessage,
      this.typeMessage,
      this.messageStatus,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    chatID = json['chatID'];
    userID = json['userID'];
    message = json['message'];
    if (json['urlImageMessage'] != null) {
      urlImageMessage = <String>[];
      json['urlImageMessage'].forEach((v) {
        urlImageMessage!.add(v);
      });
    }
    urlRecordMessage = json['urlRecordMessage'];
    stampTimeMessage = json['stampTimeMessage'];
    typeMessage = json['typeMessage'];
    messageStatus = json['messageStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['chatID'] = chatID;
    data['userID'] = userID;
    data['message'] = message;
    if (urlImageMessage != null) {
      data['urlImageMessage'] =
          urlImageMessage!.map((v) => v).toList();
    }
    data['urlRecordMessage'] = urlRecordMessage;
    data['stampTimeMessage'] = stampTimeMessage;
    data['typeMessage'] = typeMessage;
    data['messageStatus'] = messageStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
