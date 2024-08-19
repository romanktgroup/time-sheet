import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_sheet/core/const/app_icon.dart';
import 'package:time_sheet/core/theme/app_color.dart';
import 'package:time_sheet/core/theme/app_style.dart';
import 'package:time_sheet/widget/bottom_row.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  DateTime firstDay = DateTime(1990);
  DateTime lastDay = DateTime(2100);

  String format(DateTime date) => DateFormat('MMMM yyyy').format(date);

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
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          const SizedBox(height: 22),
          // MonthRow
          Row(
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
                  format(focusedDay),
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
          ),
          const SizedBox(height: 35),
          // DaysOfWeek
          SizedBox(
            height: 24,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: List.generate(
                  daysOfWeek.length,
                  (index) => Expanded(
                    child: Container(
                      height: 24,
                      // margin: (index == (daysOfWeek.length - 1)) ? null : const EdgeInsets.only(right: 5),
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
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TableCalendar(
              currentDay: selectedDay,
              focusedDay: focusedDay,

              firstDay: firstDay,
              lastDay: lastDay,
              headerVisible: false,
              locale: 'en_US',
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                  if (!isSameMonth(selectedDay, this.focusedDay)) {
                    this.focusedDay = selectedDay;
                  }
                });
              },

              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              onCalendarCreated: (c) {
                controller = c;
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  this.focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                defaultDecoration: boxDecoration,
                weekendDecoration: boxDecoration,
                todayDecoration: boxDecoration,
                selectedDecoration: boxDecoration.copyWith(
                  border: Border.all(color: AppColor.blue, width: 2),
                ),
                rangeStartDecoration: boxDecoration,
                rangeEndDecoration: boxDecoration,
                outsideDecoration: boxDecoration,
                cellMargin: const EdgeInsets.all(5 / 2),
                defaultTextStyle: AppStyle.inter14w500.copyWith(color: AppColor.black),
                todayTextStyle: AppStyle.inter14w500.copyWith(color: AppColor.black),
                selectedTextStyle: AppStyle.inter14w500.copyWith(color: AppColor.black),
                outsideTextStyle: AppStyle.inter14w400.copyWith(color: AppColor.titleDayOther),
              ),
              // daysOfWeekStyle: DaysOfWeekStyle(
              //   decoration: boxDecoration,
              //   weekdayStyle: AppStyle.inter16w500.copyWith(color: AppColor.titleDay),
              //   weekendStyle: AppStyle.inter16w500.copyWith(color: AppColor.titleDay),
              // ),
              // daysOfWeekHeight: 24,
              daysOfWeekVisible: false,
            ),
          ),
          const Spacer(),
          Container(
            color: AppColor.backgroundPurple,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              children: [
                const BottomRow(
                  title: 'Days worked',
                  text: '0',
                ),
                const SizedBox(height: 10),
                const BottomRow(
                  title: 'Hours per month',
                  text: '0',
                ),
                const SizedBox(height: 10),
                const BottomRow(
                  title: 'Income per month',
                  text: '0',
                ),
                const SizedBox(height: 10),
                const BottomRow(
                  title: 'Income for the year',
                  text: '0',
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
