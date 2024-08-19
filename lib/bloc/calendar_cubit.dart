import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_sheet/database/database_helper.dart';
import 'package:time_sheet/model/work_day_model.dart';

class CalendarCubit extends Cubit<List<WorkDay>> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  CalendarCubit() : super([]) {
    loadWorkDays();
  }

  Future<void> loadWorkDays() async {
    final workDays = await _dbHelper.getAllWorkDays();
    emit(workDays);
  }

  Future<void> addWorkDay(WorkDay workDay) async {
    await _dbHelper.insertWorkDay(workDay);
    loadWorkDays();
  }

  Future<void> deleteWorkDay(int id) async {
    await _dbHelper.deleteWorkDay(id);
    loadWorkDays();
  }

  // Дополнительные методы для управления событиями
}
