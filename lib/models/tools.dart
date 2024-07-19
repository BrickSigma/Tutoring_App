final List<String> weekNamesShort = [
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun",
];

/// Used to store the time. Similar to FLutter's TimeOfDay class.
class Time {
  int _hour = 0;
  int _minute = 0;
  int _seconds = 0;

  Time({
    int hour = 0,
    int minute = 0,
    int seconds = 0,
  }) {
    this.hour = hour;
    this.minute = minute;
    this.seconds = seconds;
  }

  Time copy() {
    return Time(hour: _hour, minute: _minute, seconds: _seconds);
  }

  set hour(int hour) {
    if (hour >= 24 || hour < 0) {
      throw RangeError("Hour must be between 0 and 23 inclusive!");
    }
    _hour = hour;
  }

  int get hour => _hour;

  set minute(int minute) {
    if (minute >= 60 || minute < 0) {
      throw RangeError("Minute must be between 0 and 59 inclusive!");
    }
    _minute = minute;
  }

  int get minute => _minute;

  set seconds(int seconds) {
    if (seconds >= 60 || seconds < 0) {
      throw RangeError("Minute must be between 0 and 59 inclusive!");
    }
    _seconds = seconds;
  }

  int get seconds => _seconds;

  /// Convert the time into only minutes.
  int get minutes => _hour * 60 + _minute;

  int get totalSeconds => _hour * 3600 + _minute * 60 + _seconds;

  /// Convert the time object to a Dart Duration object.
  Duration getDuration() =>
      Duration(hours: _hour, minutes: _minute, seconds: _seconds);

  @override
  String toString() =>
      "${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}";

  String toStringSeconds() =>
      "${toString()}:${_seconds.toString().padLeft(2, '0')}";

  /// Create a new time class from a string.
  ///
  /// The format of the string should be `HH:MM:SS`.
  static Time parse(String source) {
    List<String> timeString = source.split(":");

    if (timeString.length != 3) {
      throw const FormatException(
          "Format of time is incorrect! Make sure it is \"HH:MM:SS\".");
    }

    Time t = Time(
      hour: int.parse(timeString[0]),
      minute: int.parse(timeString[1]),
      seconds: int.parse(timeString[2]),
    );

    return t;
  }

  static Time fromSeconds(int seconds) {
    int hour = (seconds / 3600).floor();
    int minute = ((seconds - (hour * 3600)) / 60).floor();
    int second = (seconds - ((hour * 3600) + minute * 60));
    Time t = Time(hour: hour % 24, minute: minute, seconds: second);

    return t;
  }

  /// Compares another Time value with this one.
  ///
  /// Returns:
  /// - 0 if `a == b`
  /// - -1 if `a < b`
  /// - 1 if `a > b`
  int compareTime(Time time) {
    if (totalSeconds == time.totalSeconds) {
      return 0;
    } else if (totalSeconds < time.totalSeconds) {
      return -1;
    } else {
      return 1;
    }
  }

  /// Add a time value to this.
  Time add(Time time) {
    Time t = Time.fromSeconds(totalSeconds + time.totalSeconds);

    return t;
  }

  /// Subtract a time value from this.
  Time subtract(Time time) {
    Time t = Time.fromSeconds(totalSeconds - time.totalSeconds);

    return t;
  }
}
