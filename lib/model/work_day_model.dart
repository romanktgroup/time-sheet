class WorkDay {
  final int? id;
  final DateTime date;
  final double hoursWorked;
  final double ratePerHour;
  final String comment;

  WorkDay({
    this.id,
    required this.date,
    required this.hoursWorked,
    required this.ratePerHour,
    required this.comment,
  });

  // Конвертация объекта в Map для сохранения в базу данных
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'hoursWorked': hoursWorked,
      'ratePerHour': ratePerHour,
      'comment': comment,
    };
  }

  // Конвертация Map в объект WorkDay
  factory WorkDay.fromMap(Map<String, dynamic> map) {
    return WorkDay(
      id: map['id'],
      date: DateTime.parse(map['date']),
      hoursWorked: map['hoursWorked'],
      ratePerHour: map['ratePerHour'],
      comment: map['comment'],
    );
  }

  // Метод copyWith для создания копий объекта с изменением отдельных полей
  WorkDay copyWith({
    int? id,
    DateTime? date,
    double? hoursWorked,
    double? ratePerHour,
    String? comment,
  }) {
    return WorkDay(
      id: id ?? this.id,
      date: date ?? this.date,
      hoursWorked: hoursWorked ?? this.hoursWorked,
      ratePerHour: ratePerHour ?? this.ratePerHour,
      comment: comment ?? this.comment,
    );
  }
}
