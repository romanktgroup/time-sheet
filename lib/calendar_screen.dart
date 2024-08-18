import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_sheet/core/const/app_icon.dart';
import 'package:time_sheet/core/theme/app_color.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime firstDay = DateTime(1990);
  DateTime lastDay = DateTime(2100);

  late PageController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          const SizedBox(height: 22),
          Row(
            children: [
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
            ],
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TableCalendar(
              focusedDay: focusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              headerVisible: false,
              locale: 'en_US',
              onCalendarCreated: (c) {
                controller = c;
              },
            ),
          ),
          const Spacer(),
          Container(
            color: AppColor.backgroundPurple,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
