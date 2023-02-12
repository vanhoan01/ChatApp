class TextTimeVM {
  TextTimeVM({
    required this.time,
  });

  final DateTime time;

  String getTextTime() {
    DateTime now = DateTime.now();
    String timetext = "";
    List<String> dayweek = [
      'T.2',
      'T.3',
      'T.4',
      'T.5',
      'T.6',
      'T.7',
      'CN',
    ];
    if (now.year == time.year) {
      if (now.month == time.month && now.day == time.day) {
        timetext = time.toString().substring(11, 16);
      } else {
        DateTime daysAgo = now.subtract(const Duration(days: 6));
        if (time.isAfter(daysAgo)) {
          timetext =
              '${dayweek[time.weekday]} LÚC ${time.toString().substring(11, 16)}';
        } else {
          timetext =
              '${time.day} TH${time.month} LÚC ${time.toString().substring(11, 16)}';
        }
      }
    } else {
      timetext =
          '${time.day} TH${time.month}, ${time.year} LÚC ${time.toString().substring(11, 16)}';
    }
    return timetext;
  }
}
