import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Fungsi utama untuk memanggil widget kalender haid.
/// Panggil dengan: kalenderHaid(lastPeriodStart: DateTime(2025, 10, 20))
Widget kalenderHaid({
  required DateTime lastPeriodStart,
  int cycleLength = 28,
  int periodLength = 5,
  void Function(DateTime)? onDayTap,
}) {
  return MenstrualCalendarCard(
    lastPeriodStart: lastPeriodStart,
    cycleLength: cycleLength,
    periodLength: periodLength,
    onDayTap: onDayTap,
  );
}

class MenstrualCalendarCard extends StatefulWidget {
  final DateTime lastPeriodStart;
  final int cycleLength;
  final int periodLength;
  final void Function(DateTime)? onDayTap;

  const MenstrualCalendarCard({
    Key? key,
    required this.lastPeriodStart,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.onDayTap,
  }) : super(key: key);

  @override
  _MenstrualCalendarCardState createState() => _MenstrualCalendarCardState();
}

class _MenstrualCalendarCardState extends State<MenstrualCalendarCard> {
  DateTime _visibleMonth = DateTime.now();

  void _prevMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  List<DateTime> _predictedPeriodStarts() {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final diff = firstOfMonth.difference(widget.lastPeriodStart).inDays;
    final cycles = (diff / widget.cycleLength).floor();

    final starts = <DateTime>[];
    for (int i = cycles - 2; i <= cycles + 3; i++) {
      final d =
          widget.lastPeriodStart.add(Duration(days: i * widget.cycleLength));
      starts.add(DateTime(d.year, d.month, d.day));
    }
    return starts;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat.yMMMM().format(_visibleMonth);
    final firstDayOfMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final startWeekday = firstDayOfMonth.weekday;
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;

    final predictedStarts = _predictedPeriodStarts();

    final periodDays = <DateTime>{};
    for (final start in predictedStarts) {
      for (int i = 0; i < widget.periodLength; i++) {
        final d = start.add(Duration(days: i));
        periodDays.add(DateTime(d.year, d.month, d.day));
      }
    }

    final ovulationDays = <DateTime>{};
    for (final start in predictedStarts) {
      final ov = start.add(Duration(days: widget.cycleLength - 14));
      ovulationDays.add(DateTime(ov.year, ov.month, ov.day));
    }

    final weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: _prevMonth,
                        icon: const Icon(Icons.chevron_left)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(monthLabel,
                        //     style: Theme.of(context).textTheme.),
                        // const SizedBox(height: 2),
                        // Text(
                        //     'Perkiraan siklus ${widget.cycleLength} hari · haid ${widget.periodLength} hari',
                        //     style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                    IconButton(
                        onPressed: _nextMonth,
                        icon: const Icon(Icons.chevron_right)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Perkiraan berikutnya',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      _nextPredictedStartLabel(predictedStarts),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: weekdayNames
                  .map((w) => Expanded(
                        child: Center(
                            child: Text(w,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12))),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ((startWeekday - 1) + daysInMonth) +
                  ((7 - ((startWeekday - 1 + daysInMonth) % 7)) % 7),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final dayIndex = index - (startWeekday - 1) + 1;
                if (dayIndex < 1 || dayIndex > daysInMonth) {
                  return const SizedBox.shrink();
                }
                final dayDate =
                    DateTime(_visibleMonth.year, _visibleMonth.month, dayIndex);
                final isToday = _isSameDay(dayDate, DateTime.now());
                final isInPeriod =
                    periodDays.any((d) => _isSameDay(d, dayDate));
                final isOvulation =
                    ovulationDays.any((d) => _isSameDay(d, dayDate));

                Color? bg;
                if (isInPeriod) bg = Colors.pink[100];
                if (isOvulation) bg = Colors.orange[100];

                return GestureDetector(
                  onTap: () {
                    if (widget.onDayTap != null) widget.onDayTap!(dayDate);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.6)
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            '$dayIndex',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isInPeriod
                                    ? Colors.red[700]
                                    : Colors.black87),
                          ),
                        ),
                        if (isOvulation)
                          Positioned(
                            bottom: 4,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.orange[200]),
                              child: const Text('Ov',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _legendItem(Colors.pink[100]!, 'Haid'),
                const SizedBox(width: 12),
                _legendItem(Colors.orange[100]!, 'Ovulasi'),
                const SizedBox(width: 12),
                _legendItem(Colors.blueGrey.shade50, 'Hari lainnya'),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _nextPredictedStartLabel(List<DateTime> starts) {
    final now = DateTime.now();
    for (final s in starts) {
      if (!s.isBefore(now)) {
        return DateFormat('d MMM yyyy').format(s);
      }
    }
    final last = starts.last;
    return DateFormat('d MMM yyyy').format(last);
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
