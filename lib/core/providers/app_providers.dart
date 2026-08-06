import 'package:marbella/app/app_role.dart';
import 'package:marbella/core/databases/cache/secure_storage_service.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/service/certificates_services.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/viewmodel/certificates_viewmodel.dart';
import 'package:marbella/features/only_doctor/medications/services/interaction_service.dart';
import 'package:marbella/features/only_doctor/medications/viewmodels/interaction_viewmodel.dart';
import 'package:marbella/features/shared/encounter_services/services/encounter_services_service.dart';
import 'package:marbella/features/shared/encounter_services/viewmodel/encounter_service_viewmodel.dart';
import 'package:marbella/features/shared/encounters/services/encounter_note_service.dart';
import 'package:marbella/features/shared/encounters/viewmodels/encounter_note_viewmodel.dart';
import 'package:marbella/features/only_doctor/lab_tests/services/lab_test_service.dart';
import 'package:marbella/features/only_doctor/lab_tests/services/medical_test_service.dart';
import 'package:marbella/features/only_doctor/lab_tests/viewmodel/lab_test_viewmodel.dart';
import 'package:marbella/features/only_doctor/lab_tests/viewmodel/medical_test_viewmodel.dart';
import 'package:marbella/features/only_doctor/medications/services/medication_service.dart';
import 'package:marbella/features/only_doctor/medications/viewmodels/medication_viewmodel.dart';
import 'package:marbella/features/only_doctor/nurses/services/encounter_nurses_services.dart';
import 'package:marbella/features/only_doctor/nurses/viewmodels/encounter_nurses_viewmodel.dart';
import 'package:marbella/features/shared/patient_medications/services/patient_medications_service.dart';
import 'package:marbella/features/shared/patient_medications/viewmodel/patient_medication_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/cache/cache_service.dart';
import 'package:marbella/features/only_doctor/appointments/services/appointments_service.dart';
import 'package:marbella/features/only_doctor/appointments/viewmodels/appointments_viewmodel.dart';
import 'package:marbella/features/shared/auth/services/auth_service.dart';
import 'package:marbella/features/shared/auth/services/verification_service.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/auth/viewmodels/verification_viewmodel.dart';
import 'package:marbella/features/shared/codes/services/code_service.dart';
import 'package:marbella/features/shared/codes/viewmodels/code_viewmodel.dart';
import 'package:marbella/features/shared/conditions/service/condition_service.dart';
import 'package:marbella/features/shared/conditions/viewmodels/condition_viewmodel.dart';
import 'package:marbella/features/shared/encounters/services/encounters_service.dart';
import 'package:marbella/features/shared/encounters/viewmodels/encounter_viewmodel.dart';
import 'package:marbella/features/shared/observations/services/observation_service.dart';
import 'package:marbella/features/shared/observations/viewmodels/observation_viewmodel.dart';
import 'package:marbella/features/shared/password/services/password_service.dart';
import 'package:marbella/features/shared/password/viewmodels/password_viewmodel.dart';
import 'package:marbella/features/only_doctor/patients/services/patients_service.dart';
import 'package:marbella/features/only_doctor/patients/viewmodels/patients_viewmodel.dart';
import 'package:marbella/features/shared/profile/services/profile_service.dart';
import 'package:marbella/features/shared/profile/viewmodels/profile_viewmodel.dart';
import 'package:marbella/features/shared/schedule/services/schedule_service.dart';
import 'package:marbella/features/shared/schedule/viewmodels/schedule_viewmodel.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/features/shared/settings/viewmodels/theme_viewmodel.dart';
import 'package:provider/provider.dart';

appProviders({
  required AppRole role,
  required ApiServices apiService,
  required NetworkInfo networkInfo,
  required CacheService cache,
  required SecureStorageService secureStorage,
}) {
  return [
    Provider<AppRole>.value(value: role),
    ChangeNotifierProvider(
      create: (BuildContext context) => LocalizationViewmodel(),
    ),
    ChangeNotifierProvider(create: (BuildContext context) => ThemeViewmodel()),
    ChangeNotifierProvider(
      create: (BuildContext context) => AuthViewmodel(
        authRepository: AuthService(
          apiService: apiService,
          secureStorage: secureStorage,
        ),
        networkInfo: networkInfo,
      )..loadUser(),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => ProfileViewmodel(
        profileServices: ProfileService(
          apiService: apiService,
          cacheService: cache,
        ),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => ScheduleViewmodel(
        scheduleServices: ScheduleService(
          apiService: apiService,
          cacheService: cache,
        ),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => PatientsViewmodel(
        patientsServices: PatientsService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => AppointmentsViewmodel(
        appointmentsServices: AppointmentsService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => PasswordViewmodel(
        passwordRepository: PasswordService(
          apiService: apiService,
          cacheService: cache,
        ),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => VerificationViewmodel(
        verificationRepository: VerificationService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => EncounterViewmodel(
        encountersService: EncountersService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => ObservationViewmodel(
        observationServices: ObservationService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => CodeViewmodel(
        codeService: CodeService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => ConditionViewmodel(
        conditionService: ConditionService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => MedicationViewmodel(
        medicationService: MedicationService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => PatientMedicationViewmodel(
        patientMedicationsService: PatientMedicationsService(
          apiService: apiService,
        ),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => EncounterNoteViewmodel(
        encounterNotesService: EncounterNoteService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => EncounterServiceViewmodel(
        encounterServicesService: EncounterServicesService(
          apiService: apiService,
        ),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => EncounterNursesViewmodel(
        encounterNursesServices: EncounterNursesServices(
          apiService: apiService,
        ),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => LabTestViewmodel(
        labTestService: LabTestService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => MedicalTestViewmodel(
        medicalTestService: MedicalTestService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => CertificatesViewmodel(
        certificatesServices: CertificatesServices(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => InteractionViewmodel(
        interactionService: InteractionService(apiService: apiService),
        networkInfo: networkInfo,
      ),
    ),
  ];
}
