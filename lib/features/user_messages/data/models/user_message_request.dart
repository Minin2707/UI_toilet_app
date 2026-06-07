import 'user_message_type.dart';

class UserMessageRequest {
  final UserMessageType type;
  final String message;

  const UserMessageRequest({
    required this.type,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': switch (type) {
        UserMessageType.suggestion => 'SUGGESTION',
        UserMessageType.complaint => 'COMPLAINT',
        UserMessageType.bug => 'BUG',
        UserMessageType.other => 'OTHER',
      },
      'message': message,
    };
  }
}