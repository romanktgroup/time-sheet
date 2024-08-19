
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_sheet/bloc/calendar_cubit.dart';
import 'package:time_sheet/core/const/app_icon.dart';
import 'package:time_sheet/core/helpers/extension/date_time_extension.dart';
import 'package:time_sheet/core/helpers/extension/iterable_extension.dart';
import 'package:time_sheet/core/theme/app_color.dart';
import 'package:time_sheet/core/theme/app_style.dart';
import 'package:time_sheet/model/work_day_model.dart';
import 'package:time_sheet/widget/app_button.dart';
import 'package:time_sheet/widget/app_text_field.dart';
import 'package:time_sheet/widget/bottom_row.dart';
import 'package:time_sheet/widget/squeezed_box.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay = DateTime.now();
  DateTime firstDay = DateTime(1990);
  DateTime lastDay = DateTime(2100);

  String formatMonthYear(DateTime date) => DateFormat('MMMM yyyy').format(date);
  String formatDate(DateTime date) => DateFormat('MM/dd/yyyy').format(date);
  String formatDateFile(DateTime date) => DateFormat('MM-dd-yyyy').format(date);

  late PageController controller;

  final boxDecoration = BoxDecoration(
    color: AppColor.white,
    borderRadius: BorderRadius.circular(10),
    shape: BoxShape.rectangle,
  );

  final daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              const SqueezedBox(maxHeight: 22),
              _buildMonthRow(),
              const SqueezedBox(maxHeight: 35),
              _buildDaysOfWeek(),
              const SqueezedBox(maxHeight: 15),
              _buildCalendar(),
              const Spacer(),
              _buildBottomSummary(),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthRow() {
    return Row(
      children: [
        const SizedBox(width: 24),
        GestureDetector(
          onTap: () {
            controller.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          behavior: HitTestBehavior.opaque,
          child: SvgPicture.asset(AppIcon.left),
        ),
        Expanded(
          child: Text(
            formatMonthYear(focusedDay),
            style: AppStyle.inter20w400.copyWith(color: AppColor.titleDay),
            textAlign: TextAlign.center,
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          behavior: HitTestBehavior.opaque,
          child: SvgPicture.asset(AppIcon.right),
        ),
        const SizedBox(width: 24),
      ],
    );
  }

  Widget _buildDaysOfWeek() {
    return Container(
      height: 24,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: List.generate(
          daysOfWeek.length,
          (index) => Expanded(
            child: Container(
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 5 / 2),
              decoration: boxDecoration,
              alignment: Alignment.center,
              child: Text(
                daysOfWeek[index],
                style: AppStyle.inter16w500.copyWith(color: AppColor.titleDay),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return BlocBuilder<CalendarCubit, List<WorkDay>>(
      builder: (context, workDays) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TableCalendar(
            currentDay: selectedDay,
            focusedDay: focusedDay,
            firstDay: firstDay,
            lastDay: lastDay,
            headerVisible: false,
            daysOfWeekVisible: false,
            locale: 'en_US',
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                if (!isSameMonth(selectedDay, this.focusedDay)) {
                  this.focusedDay = selectedDay;
                }
              });
            },
            onCalendarCreated: (c) {
              controller = c;
            },
            onPageChanged: (focusedDay) {
              setState(() {
                this.focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) => cellBuilder(
                day,
                workDays,
                AppStyle.inter14w500.copyWith(color: AppColor.black),
                boxDecoration,
              ),
              todayBuilder: (context, day, focusedDay) => cellBuilder(
                day,
                workDays,
                AppStyle.inter14w500.copyWith(color: AppColor.black),
                boxDecoration,
              ),
              selectedBuilder: (context, day, focusedDay) => cellBuilder(
                day,
                workDays,
                AppStyle.inter14w500.copyWith(color: AppColor.black),
                boxDecoration.copyWith(
                  border: Border.all(color: AppColor.blue, width: 2),
                ),
              ),
              outsideBuilder: (context, day, focusedDay) => cellBuilder(
                day,
                workDays,
                AppStyle.inter14w400.copyWith(color: AppColor.titleDayOther),
                boxDecoration,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget cellBuilder(DateTime day, List<WorkDay> workDays, TextStyle style, BoxDecoration boxDecoration) {
    final workDay = workDays.firstWhereOrNull((wd) => wd.date.isSameDay(day));

    return Container(
      height: 42,
      margin: const EdgeInsets.all(5 / 2),
      alignment: Alignment.center,
      decoration: boxDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day.day.toString(),
            style: style,
          ),
          if (workDay != null) ...[
            const SizedBox(height: 4),
            Text(
              (workDay.hoursWorked * workDay.ratePerHour).toStringAsFixed(0),
              style: AppStyle.inter12w600.copyWith(color: AppColor.green),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomSummary() {
    return BlocBuilder<CalendarCubit, List<WorkDay>>(
      builder: (context, workDays) {
        final daysWorked = workDays.length;

        final focusedYear = focusedDay.year;
        final focusedMonth = focusedDay.month;

        // MONTH
        final monthWorkDays = workDays.where((wd) => wd.date.year == focusedYear && wd.date.month == focusedMonth);

        final hoursPerMonth = monthWorkDays.fold(0.0, (sum, wd) => sum + wd.hoursWorked);

        final incomePerMonth = monthWorkDays.fold(0.0, (sum, wd) => sum + (wd.hoursWorked * wd.ratePerHour));

        // YEAR
        final yearWorkDays = workDays.where((wd) => wd.date.year == focusedYear);

        final incomeForYear = yearWorkDays.fold<double>(0.0, (sum, wd) => sum + (wd.hoursWorked * wd.ratePerHour));

        return Container(
          color: AppColor.backgroundPurple,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            children: [
              BottomRow(title: 'Days worked', text: '$daysWorked'),
              const SizedBox(height: 10),
              BottomRow(title: 'Hours per month', text: '$hoursPerMonth'),
              const SizedBox(height: 10),
              BottomRow(title: 'Income per month', text: '\$${incomePerMonth.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              BottomRow(title: 'Income for the year', text: '\$${incomeForYear.toStringAsFixed(2)}'),
              if (selectedDay == null) SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomButtons() {
    return BlocBuilder<CalendarCubit, List<WorkDay>>(
      builder: (context, workDays) {
        final WorkDay? workDay = workDays.firstWhereOrNull((wd) => wd.date.isSameDay(selectedDay!));

        return Container(
          color: AppColor.white,
          padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
          child: Column(
            children: [
              AppButton(
                title: 'Open report',
                onTap: () {
                  showCustomDialog(context, selectedDay!);
                },
              ),
              if (workDay != null) ...[
                const SizedBox(height: 10),
                AppButton(
                  title: 'Send report',
                  onTap: () {
                    shareReport(workDay);
                  },
                ),
                const SizedBox(height: 10),
                AppButton(
                  title: 'Delete report',
                  onTap: () {
                    context.read<CalendarCubit>().deleteWorkDay(selectedDay!);
                  },
                ),
              ],
              if (selectedDay == null) SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  void showCustomDialog(BuildContext context, DateTime selectedDay) {
    final workDayCubit = context.read<CalendarCubit>();
    WorkDay workDay = workDayCubit.state.firstWhereOrNull((wd) => wd.date.isSameDay(selectedDay)) ??
        WorkDay(
          date: selectedDay,
          hoursWorked: 0.0,
          ratePerHour: 0.0,
          comment: '',
        );

    showDialog(
      barrierColor: AppColor.black.withOpacity(.7),
      context: context,
      builder: (context) {
        return Dialog(
          child: Stack(
            children: [
              Container(
                color: AppColor.background,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatDate(selectedDay),
                      style: AppStyle.inter18w500.copyWith(color: AppColor.black),
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      initialValue: workDay.hoursWorked == 0 ? '' : workDay.hoursWorked.toString(),
                      hintText: 'Opening hours',
                      keyboardType: TextInputType.number,
                      max: 24,
                      onChanged: (value) {
                        workDay = workDay.copyWith(hoursWorked: double.tryParse(value));
                      },
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      initialValue: workDay.ratePerHour == 0 ? '' : workDay.ratePerHour.toString(),
                      hintText: 'Rate per Hour',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        workDay = workDay.copyWith(ratePerHour: double.tryParse(value));
                      },
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      initialValue: workDay.comment,
                      hintText: 'Comment...',
                      minLines: 3,
                      maxLines: 5,
                      onChanged: (value) {
                        workDay = workDay.copyWith(comment: value);
                      },
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      title: 'OK',
                      onTap: () {
                        context.read<CalendarCubit>().addWorkDay(workDay);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 14,
                top: 14,
                child: GestureDetector(
                  onTap: Navigator.of(context).pop,
                  behavior: HitTestBehavior.opaque,
                  child: SvgPicture.asset(AppIcon.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void shareReport(WorkDay workDay) {
    final String message = '''
Workday Report:
Date: ${formatDate(workDay.date)}
Hours Worked: ${workDay.hoursWorked}
Rate Per Hour: ${workDay.ratePerHour}
Comment: ${workDay.comment}
  '''
        .trim();

    Share.share(message);
  }
}
