
class Message {
  final String userId;
  final String userName;
  final String roomId;
  final String message;
  final int messageType;
  final DateTime createdAt;

  const Message({
    required this.userId,
    required this.userName,
    required this.roomId,
    required this.message,
    required this.messageType,
    required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        userId: json['userId'],
        userName: json['userName'],
        roomId: json['roomId'],
        message: json['message'],
        messageType: json['messageType'],
        createdAt: json['createdAt']?.toDate(),
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'roomId': roomId,
        'message': message,
        'messageType': messageType,
        'createdAt': createdAt.toUtc(),
      };
}