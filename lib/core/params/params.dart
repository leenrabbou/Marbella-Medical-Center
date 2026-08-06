class LoginParams {
  final String phoneNumber;
  final String password;
  LoginParams({required this.phoneNumber, required this.password});
}

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;
  ChangePasswordParams({required this.oldPassword, required this.newPassword});
}

class CheckOtpParams {
  final String phoneNumber;
  final String otp;
  CheckOtpParams({required this.phoneNumber, required this.otp});
}

class ResetPasswordParams {
  final String phoneNumber;
  final String otp;
  final String password;
  ResetPasswordParams({
    required this.phoneNumber,
    required this.otp,
    required this.password,
  });
}

class PatientsParams {
  String? search;
  PatientsParams({required this.search});
  void setSearch(String? search) {
    this.search = search;
  }
}

class EncounterParams {
  String? search;
  String? status;
  int? patientId;
  EncounterParams({
    required this.search,
    required this.status,
    required this.patientId,
  });
  void setPatientId(int? patientId) {
    this.patientId = patientId;
  }

  void setStatus(String? status) {
    this.status = status;
  }

  void setSearch(String? search) {
    this.search = search;
  }
}

class ObservationParams {
  int? encounterId;
  String? status;
  int? patientId;

  ObservationParams({
    required this.encounterId,
    required this.status,
    required this.patientId,
  });
  void setPatientId(int? patientId) {
    this.patientId = patientId;
  }

  void setStatus(String? status) {
    this.status = status;
  }

  void setSearch(int? encounterId) {
    this.encounterId = encounterId;
  }
}

class UpdateObservationParams {
  int? codeId;
  String? status;
  String? effectiveDatetime;
  String? issuedAt;
  String? value;
  String? unit;
  String? note;

  UpdateObservationParams({
    required this.codeId,
    required this.status,
    required this.effectiveDatetime,
    required this.issuedAt,
    required this.note,
    required this.unit,
    required this.value,
  });
}

class AddObservationParams {
  int encounterId;
  int? codeId;
  String? status;
  String? effectiveDatetime;
  String? issuedAt;
  String? value;
  String? unit;
  String? note;

  AddObservationParams({
    required this.encounterId,
    required this.codeId,
    required this.status,
    required this.effectiveDatetime,
    required this.issuedAt,
    required this.note,
    required this.unit,
    required this.value,
  });
}

class UpdateEncounterParams {
  String? reason;
  String? notes;
  String? status;

  UpdateEncounterParams({
    required this.reason,
    required this.status,
    required this.notes,
  });
  void setReason(String? reason) {
    this.reason = reason;
  }

  void setStatus(String? status) {
    this.status = status;
  }

  void setNotes(String? notes) {
    this.notes = notes;
  }
}

class AppointmentsParams {
  String? search;
  String? status;
  int? patientId;
  String? dateRangeFrom;
  String? dateRangeTo;
  AppointmentsParams({
    required this.search,
    required this.status,
    required this.patientId,
    required this.dateRangeFrom,
    required this.dateRangeTo,
  });
  void setOrganizationId(int? organizationId) {}

  void setStatus(String? status) {
    this.status = status;
  }

  void setSearch(String? search) {
    this.search = search;
  }

  void setPatientId(int? patientId) {
    this.patientId = patientId;
  }

  void setdateRangeFrom(String? dateRangeFrom) {
    this.dateRangeFrom = dateRangeFrom;
  }

  void setdateRangeTo(String? dateRangeTo) {
    this.dateRangeTo = dateRangeTo;
  }
}

class CodeParams {
  String category;
  int? active;
  CodeParams({required this.category, required this.active});

  void setCategory(String category) {
    this.category = category;
  }

  void setActive(int? active) {
    this.active = active;
  }
}

class AddCodeParams {
  String? system;
  String? code;
  String? display;
  String category;
  AddCodeParams({
    required this.system,
    required this.code,
    required this.category,
    required this.display,
  });

  void setSystem(String? system) {
    this.system = system;
  }

  void setCode(String? code) {
    this.code = code;
  }

  void setCategory(String category) {
    this.category = category;
  }

  void setDisplay(String? display) {
    this.display = display;
  }
}

class ConditionParams {
  int? encounterId;
  String? clinicalStatus;
  String? verificationStatus;
  int? patientId;
  ConditionParams({
    required this.encounterId,
    required this.clinicalStatus,
    required this.verificationStatus,
    required this.patientId,
  });
}

class UpdateConditionParams {
  int? codeId;
  String? clinicalStatus;
  String? verificationStatus;
  String? onsetDate;
  String? abatementDate;
  String? note;

  UpdateConditionParams({
    required this.codeId,
    required this.clinicalStatus,
    required this.verificationStatus,
    required this.onsetDate,
    required this.note,
    required this.abatementDate,
  });
}

class AddConditionParams {
  int encounterId;
  int patientId;
  int? codeId;
  String? clinicalStatus;
  String? verificationStatus;
  String? onsetDate;
  String? abatementDate;
  String? note;

  AddConditionParams({
    required this.patientId,
    required this.encounterId,
    required this.codeId,
    required this.clinicalStatus,
    required this.verificationStatus,
    required this.onsetDate,
    required this.note,
    required this.abatementDate,
  });
}

class UpdateMedicationParams {
  String? image;
  String? system;
  String? code;
  String? display;
  String? description;
  String? form;
  String? strength;

  UpdateMedicationParams({
    required this.image,
    required this.system,
    required this.code,
    required this.description,
    required this.display,
    required this.form,
    required this.strength,
  });
}

class PatientMedicationsParams {
  int? patientId;
  int? doctorId;
  int? encounterId;
  String? status;
  PatientMedicationsParams({
    required this.patientId,
    required this.doctorId,
    required this.encounterId,
    required this.status,
  });
}

class UpdatePatientMedicationParams {
  int? medicationId;
  String? dosage;
  String? route;
  int? durationValue;
  String? durationUnit;
  String? notes;
  UpdatePatientMedicationParams({
    required this.medicationId,
    required this.dosage,
    required this.route,
    required this.durationUnit,
    required this.durationValue,
    required this.notes,
  });
}

class AddPatientMedicationParams {
  int? encounterId;
  int? medicationId;
  String? dosage;
  String? route;
  int? durationValue;
  String? durationUnit;
  String? notes;
  int override;
  AddPatientMedicationParams({
    required this.encounterId,
    required this.medicationId,
    required this.dosage,
    required this.route,
    required this.durationUnit,
    required this.durationValue,
    required this.notes,
    required this.override,
  });
}

class EncounterNoteParams {
  int? patientId;
  int? encounterId;
  String? status;
  EncounterNoteParams({
    required this.patientId,
    required this.encounterId,
    required this.status,
  });
}

class UpdateEncounterNoteParams {
  int? durationValue;
  String? note;
  String? title;
  String? durationUnit;

  UpdateEncounterNoteParams({
    required this.durationUnit,
    required this.durationValue,
    required this.title,
    required this.note,
  });
}

class AddEncounterNoteParams {
  int encounterId;
  int? durationValue;
  String? note;
  String? title;
  String? durationUnit;

  AddEncounterNoteParams({
    required this.encounterId,
    required this.durationUnit,
    required this.durationValue,
    required this.title,
    required this.note,
  });
}

class EncounterServiceParams {
  int? encounterId;
  String? status;

  EncounterServiceParams({required this.encounterId, required this.status});
}

class UpdateEncounterServiceParams {
  String? note;
  String? status;

  UpdateEncounterServiceParams({required this.note, required this.status});
}

class AddEncounterServiceParams {
  int? encounterId;
  int? serviceId;

  AddEncounterServiceParams({
    required this.encounterId,
    required this.serviceId,
  });
}

class LabTestParams {
  final int? patientId;
  final String? status;

  LabTestParams({required this.patientId, required this.status});
}

class AddPatientLabTestParams {
  final int patientId;
  final int medicalTestId;

  AddPatientLabTestParams({
    required this.patientId,
    required this.medicalTestId,
  });
}

class InteractionParams {
  final int medicationId;
  final String interactableType;
  InteractionParams({
    required this.medicationId,
    required this.interactableType,
  });
}

class AddInteractionParams {
  final int medicationId;
  final String interactableType;
  final int interactableId;
  final String severity;
  final String? description;

  AddInteractionParams({
    required this.interactableId,
    required this.severity,
    required this.description,
    required this.medicationId,
    required this.interactableType,
  });
}
