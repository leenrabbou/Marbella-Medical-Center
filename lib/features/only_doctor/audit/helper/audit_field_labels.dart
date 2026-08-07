import 'package:marbella/generated/l10n.dart';

class AuditFieldLabels {
  static final Map<String, String Function()> _labels = {
    'onset_date': () => S().onset_date,
    'abatement_date': () => S().abatement_date,
    'clinical_status': () => S().clinical_status,
    'verification_status': () => S().verification_status,
    'code_id': () => S().code,

    'status': () => S().status,
    'issued_at': () => S().issued_at,
    'value': () => S().value,
    'unit': () => S().unit,
    'effective_datetime': () => S().effective_date,

    'medication_id': () => S().medication,
    'dosage': () => S().medication_dosage,
    'route': () => S().route,
    'duration_value': () => S().duration,
    'duration_unit': () => S().unit,
    'until_date': () => S().until_date,

    'service_id': () => S().service,
    'performed_at': () => S().performed_at,
    'price': () => S().price,

    'title': () => S().title,

    'note': () => S().notes,
    'notes': () => S().notes,
    'reason': () => S().reason,
    'patient_id': () => S().patient,
    'encounter_id': () => S().encounter,
  };

  static String labelFor(String key) {
    return _labels[key]?.call() ?? key;
  }
}
