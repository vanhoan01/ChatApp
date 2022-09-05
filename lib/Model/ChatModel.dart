class ChatModel {
  late int id;
  late String name;
  late String icon;
  late bool isGroup;
  late String time;
  late String currentMessage;
  late String status;
  late bool select = false;

  ChatModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.isGroup,
    required this.time,
    required this.currentMessage,
  });
  ChatModel.ChatModelContact(this.name, this.status);
  ChatModel.ChatModelGroup(
      {required this.name, required this.status, this.select = false});
}
