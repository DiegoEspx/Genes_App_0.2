class ChatRequestModel {
  final String message;
  final String? context;
  final String? topic;
  final int? minYear;
  final List<String>? types;
  final String? lang;

  ChatRequestModel({
    required this.message,
    this.context,
    this.topic,
    this.minYear,
    this.types,
    this.lang,
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        if (context != null) 'context': context,
        if (topic != null) 'topic': topic,
        if (minYear != null) 'min_year': minYear,
        if (types != null) 'types': types,
        if (lang != null) 'lang': lang,
      };
}

class ChatResponseModel {
  final String reply;

  ChatResponseModel({required this.reply});

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) =>
      ChatResponseModel(reply: (json['reply'] ?? '').toString());
}
