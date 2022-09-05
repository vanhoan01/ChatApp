class MessageModel {
  late String type;
  late String message;
  late String time;
  late String path;
  MessageModel(
      {required this.message,
      required this.type,
      required this.time,
      required this.path});
}
