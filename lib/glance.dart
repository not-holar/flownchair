import 'package:flownchair/ordinal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Updates once per day only
final dailyDateProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  ).distinct(
    (prev, event) => prev.day == event.day,
  ),
);

final todayString = Provider(
  (ref) => formatDate(
    ref.watch(dailyDateProvider).data?.value ?? DateTime.now(),
  ),
);

String formatDate(DateTime date) {
  print("Formatted date");
  final f = '${DateFormat.WEEKDAY}, ${DateFormat.ABBR_STANDALONE_MONTH}';
  return '${DateFormat(f).format(date)} ${ordinal[date.day]}';
}

class HomeGlance extends StatelessWidget {
  const HomeGlance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Consumer(builder: (context, watch, child) {
            return Text(
              watch(todayString),
              style: GoogleFonts.megrim(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w700,
                shadows: kElevationToShadow[24],
              ),
            );
          }),
        ),
      ),
    );
  }
}
