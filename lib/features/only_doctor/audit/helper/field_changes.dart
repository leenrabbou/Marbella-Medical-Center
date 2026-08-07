import 'package:marbella/features/only_doctor/audit/models/audit_model.dart';

class FieldChange {
  final String key;
  final dynamic oldValue;
  final dynamic newValue;

  FieldChange({
    required this.key,
    required this.oldValue,
    required this.newValue,
  });
}

List<FieldChange> computeAuditDiff(AuditModel log) {
  if (log.event == 'created') {
    return log.newValues.entries
        .where((e) => !_excludedKeys.contains(e.key))
        .map((e) => FieldChange(key: e.key, oldValue: null, newValue: e.value))
        .toList();
  }

  final orderedKeys = [
    ...log.newValues.keys,
    ...log.oldValues.keys.where((k) => !log.newValues.containsKey(k)),
  ];

  return orderedKeys
      .where(
        (k) =>
            !_excludedKeys.contains(k) && log.oldValues[k] != log.newValues[k],
      )
      .map(
        (k) => FieldChange(
          key: k,
          oldValue: log.oldValues[k],
          newValue: log.newValues[k],
        ),
      )
      .toList();
}

const _excludedKeys = {
  'id',
  'encounter_id',
  'performed_by_id',
  'performed_by_type',
  'service_id',
  'code_id',
  'medication_id',
};
