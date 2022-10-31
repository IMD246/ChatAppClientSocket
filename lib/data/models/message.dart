class Message {
  String? userID;
  String? message;
  String? urlImageMessage;
  String? urlRecordMessage;
  int? stampTimeMessage;
  String? typeMessage;
  String? messageStatus;

  Message(
      {this.userID,
      this.message,
      this.urlImageMessage,
      this.urlRecordMessage,
      this.stampTimeMessage,
      this.typeMessage,
      this.messageStatus});

  Message.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    message = json['message'];
    urlImageMessage = json['urlImageMessage'];
    urlRecordMessage = json['urlRecordMessage'];
    stampTimeMessage = json['stampTimeMessage'];
    typeMessage = json['typeMessage'];
    messageStatus = json['messageStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['message'] = message;
    data['urlImageMessage'] = urlImageMessage;
    data['urlRecordMessage'] = urlRecordMessage;
    data['stampTimeMessage'] = stampTimeMessage;
    data['typeMessage'] = typeMessage;
    data['messageStatus'] = messageStatus;
    return data;
  }
}