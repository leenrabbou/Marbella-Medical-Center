import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constant {
  static List<Color> listColors = [
    Color(0xff089bab),
    Color(0xffE57373),
    Color(0xffF06292),
    Color(0xffF79EB0),
    Color(0xffBA68C8),
    Color(0xff9575CD),
    Color(0xff7986CB),
    Color(0xff2549A1),
    Color(0xff64B5F6),
    Color(0xff4DB6AC),
    Color(0xff81C784),
    Color(0xffFF8A65),
  ];

  static final systemOptions = <String>[
    "http://loinc.org",
    "http://snomed.info",
    "http://hl7.org/fhir",
  ];

  static int calculateAge(String birthDate) {
    try {
      final dob = DateTime.parse(birthDate);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }

  static Color statusColor(String status) {
    switch (status) {
      case 'pending':
      case 'registered':
      case 'inactive':
      case 'remission':
      case 'low':
        return const Color(0xFF3B82F6);

      case 'booked':
      case 'final':
      case 'resolved':
      case 'completed':
      case 'active':
        return const Color(0xFF22C55E);

      case 'arrived':
      case 'amended':
      case 'differential':
        return const Color(0xFF8B5CF6);

      case 'fulfilled':
      case 'finished':
      case 'confirmed':
        return const Color(0xFF14B8A6);

      case 'cancelled':
      case 'refuted':
      case 'severe':
      case 'high':
        return const Color(0xFFEF4444);
      case 'moderate':
        return const Color.fromARGB(255, 249, 151, 22);
      case 'no_show':
      case 'unknown':
        return const Color(0xFF9E9E9E);
      case 'recurrence':
      case 'relapse':
      case 'entered-in-error':
      case 'provisional':
      default:
        return const Color.fromARGB(255, 249, 22, 241);
    }
  }

  static String statusLabel(String status) {
    switch (status) {
      case 'pending':
        return S().pending;
      case 'booked':
        return S().booked;
      case 'arrived':
        return S().arrived;
      case 'fulfilled':
        return S().fulfilled;
      case 'cancelled':
        return S().cancelled;
      case 'canceled':
        return S().cancelled;
      case 'no_show':
        return S().no_show;
      case 'all':
        return S().all;
      case 'in-progress':
        return S().in_progress;
      case 'planned':
        return S().status_planned;
      case 'finished':
        return S().status_finished;
      case 'triaged':
        return S().status_triaged;
      case 'onleave':
      case 'on-leave':
        return S().status_on_leave;
      case 'active':
        return S().active;
      case 'inactive':
        return S().inactive;
      case 'resolved':
        return S().resolved_label;
      case 'recurrence':
        return S().condition_status_recurrence;
      case 'relapse':
        return S().condition_status_relapse;
      case 'remission':
        return S().condition_status_remission;
      case 'unconfirmed':
        return S().verification_status_unconfirmed;
      case 'provisional':
        return S().verification_status_provisional;
      case 'differential':
        return S().verification_status_differential;
      case 'confirmed':
        return S().verification_status_confirmed;
      case 'refuted':
        return S().verification_status_refuted;
      case 'entered-in-error':
        return S().verification_status_entered_in_error;
      case 'ordered':
        return S().status_ordered;
      case 'partial':
        return S().status_partial;
      case 'registered':
        return S().observation_status_registered;
      case 'preliminary':
        return S().observation_status_preliminary;
      case 'final':
        return S().observation_status_final;
      case 'amended':
        return S().observation_status_amended;
      case 'completed':
        return S().completed;
      case 'stopped':
        return S().status_stopped;
      case 'on-hold':
      case 'onhold':
        return S().status_on_hold;
      default:
        return status;
    }
  }

  static String unitLabel(String unit) {
    switch (unit) {
      case 'days':
        return S().days;
      case 'weeks':
        return S().weeks;
      case 'months':
        return S().months;
      case 'years':
        return S().years;
      default:
        return unit;
    }
  }

  static String formatDate(BuildContext context, String date) {
    try {
      DateTime? d = DateTime.tryParse(date);
      d ??= DateFormat('d/M/yyyy').parseStrict(date);

      final locale = Localizations.localeOf(context).languageCode;
      return DateFormat('EEEE, d MMMM yyyy', locale).format(d);
    } catch (_) {
      return date;
    }
  }

  static String calDuration(String start, String end) {
    try {
      final difference = DateTime.parse(end).difference(DateTime.parse(start));

      if (difference.isNegative) {
        return "0 ${S().duration_minutes}";
      }

      if (difference.inHours < 1) {
        final minutes = difference.inMinutes;

        return "$minutes ${minutes == 1 ? S().duration_minute : S().duration_minutes}";
      }

      if (difference.inDays < 1) {
        final hours = difference.inHours;

        return "$hours ${hours == 1 ? S().duration_hour : S().duration_hours}";
      }

      final days = difference.inDays;

      return "$days ${days == 1 ? S().duration_day : S().duration_days}";
    } catch (_) {
      return "-";
    }
  }

  static String parseMaritalStatus(String status) {
    switch (status.toUpperCase()) {
      case 'S':
        return S().single;
      case 'M':
        return S().married;
      case 'D':
        return S().divorced;
      default:
        return status;
    }
  }

  static String formatTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return S().no_time;

    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return S().invalid_time;
    }
  }

  static String getDay(String dateStr) =>
      DateTime.parse(dateStr).day.toString();
  static String getMonthName(String dateStr) {
    return DateFormat('MMM').format(DateTime.parse(dateStr));
  }

  static String getYear(String dateStr) =>
      DateTime.parse(dateStr).year.toString();

  static Color observationColor(String code) {
    switch (code) {
      case "8480-6":
      case "8462-4":
      case "85354-9":
        return Colors.red;

      case "8867-4":
        return Colors.pink;

      case "9279-1":
        return Colors.teal;

      case "59408-5":
      case "2708-6":
        return Colors.blue;

      case "8310-5":
        return Colors.deepOrange;

      case "8302-2":
        return Colors.teal;

      case "29463-7":
        return Colors.deepPurple;

      case "39156-5":
        return Colors.indigo;

      case "883-9":
      case "882-1":
        return Colors.red.shade700;

      case "718-7":
        return Colors.redAccent;

      case "789-8":
        return Colors.red;

      case "6690-2":
        return Colors.green;

      case "777-3":
        return Colors.amber.shade700;

      case "2339-0":
      case "2345-7":
        return Colors.orange;

      case "2160-0":
      case "3094-0":
        return Colors.lightBlue;

      case "1742-6":
      case "1920-8":
        return Colors.green;

      case "2093-3":
      case "2085-9":
      case "13457-7":
        return Colors.amber;

      default:
        return const Color(0xff089bab);
    }
  }

  static IconData observationIcon(String code) {
    switch (code) {
      case "8480-6":
      case "8462-4":
      case "85354-9":
        return Icons.favorite_outline;

      case "8867-4":
        return Icons.monitor_heart_outlined;

      case "9279-1":
        return Icons.air;

      case "59408-5":
      case "2708-6":
        return Icons.air_outlined;

      case "8310-5":
        return Icons.thermostat_outlined;

      case "8302-2":
        return Icons.height;

      case "29463-7":
        return Icons.monitor_weight_outlined;

      case "39156-5":
        return Icons.accessibility_new_outlined;

      case "883-9":
        return Icons.bloodtype_outlined;

      case "882-1":
        return Icons.bloodtype;

      case "718-7":
        return Icons.water_drop_outlined;

      case "789-8":
        return Icons.opacity_outlined;

      case "6690-2":
        return Icons.biotech_outlined;

      case "777-3":
        return Icons.grain;

      case "2339-0":
      case "2345-7":
        return Icons.monitor;

      case "2160-0":
        return Icons.water;

      case "3094-0":
        return Icons.science_outlined;

      case "1742-6":
      case "1920-8":
        return Icons.medical_services_outlined;

      case "2093-3":
      case "2085-9":
      case "13457-7":
        return Icons.favorite_border;

      default:
        return Icons.science_outlined;
    }
  }

  static String formatPrice(num price) {
    final str = price.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i != 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
