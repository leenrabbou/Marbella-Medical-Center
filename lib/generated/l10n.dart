// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Log In`
  String get log_in {
    return Intl.message('Log In', name: 'log_in', desc: '', args: []);
  }

  /// `Welcome Back!`
  String get welcome {
    return Intl.message('Welcome Back!', name: 'welcome', desc: '', args: []);
  }

  /// `Nice to see you again`
  String get nice_to_see_you {
    return Intl.message(
      'Nice to see you again',
      name: 'nice_to_see_you',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone_label {
    return Intl.message(
      'Phone Number',
      name: 'phone_label',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get phone_hint {
    return Intl.message(
      'Enter your phone number',
      name: 'phone_hint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password_label {
    return Intl.message('Password', name: 'password_label', desc: '', args: []);
  }

  /// `Enter your password`
  String get password_hint {
    return Intl.message(
      'Enter your password',
      name: 'password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgot_password {
    return Intl.message(
      'Forgot password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Password must be at least 6 characters long`
  String get password_too_short {
    return Intl.message(
      'Password must be at least 6 characters long',
      name: 'password_too_short',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get invalid_phone_number {
    return Intl.message(
      'Invalid phone number',
      name: 'invalid_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get field_is_required {
    return Intl.message(
      'This field is required',
      name: 'field_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Current Patients`
  String get current_patients {
    return Intl.message(
      'Current Patients',
      name: 'current_patients',
      desc: '',
      args: [],
    );
  }

  /// `Patient Profile`
  String get patient_profile {
    return Intl.message(
      'Patient Profile',
      name: 'patient_profile',
      desc: '',
      args: [],
    );
  }

  /// `General Health History`
  String get general_health_history {
    return Intl.message(
      'General Health History',
      name: 'general_health_history',
      desc: '',
      args: [],
    );
  }

  /// `Social History`
  String get social_history {
    return Intl.message(
      'Social History',
      name: 'social_history',
      desc: '',
      args: [],
    );
  }

  /// `View Dental History`
  String get view_dental_history {
    return Intl.message(
      'View Dental History',
      name: 'view_dental_history',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Dark Theme`
  String get dark_theme {
    return Intl.message('Dark Theme', name: 'dark_theme', desc: '', args: []);
  }

  /// `Medications in Use`
  String get medications_in_use {
    return Intl.message(
      'Medications in Use',
      name: 'medications_in_use',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `In Progress`
  String get in_progress {
    return Intl.message('In Progress', name: 'in_progress', desc: '', args: []);
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Dental History`
  String get dental_history {
    return Intl.message(
      'Dental History',
      name: 'dental_history',
      desc: '',
      args: [],
    );
  }

  /// `Edit Main Information`
  String get edit_main_info {
    return Intl.message(
      'Edit Main Information',
      name: 'edit_main_info',
      desc: '',
      args: [],
    );
  }

  /// `Patient Name`
  String get patient_name {
    return Intl.message(
      'Patient Name',
      name: 'patient_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter patient name`
  String get enter_patient_name {
    return Intl.message(
      'Enter patient name',
      name: 'enter_patient_name',
      desc: '',
      args: [],
    );
  }

  /// `Patient Job`
  String get patient_job {
    return Intl.message('Patient Job', name: 'patient_job', desc: '', args: []);
  }

  /// `Enter patient job`
  String get enter_patient_job {
    return Intl.message(
      'Enter patient job',
      name: 'enter_patient_job',
      desc: '',
      args: [],
    );
  }

  /// `Enter patient phone number`
  String get enter_patient_phone {
    return Intl.message(
      'Enter patient phone number',
      name: 'enter_patient_phone',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get birth_date {
    return Intl.message('Birth Date', name: 'birth_date', desc: '', args: []);
  }

  /// `Enter patient birth date`
  String get enter_patient_birthdate {
    return Intl.message(
      'Enter patient birth date',
      name: 'enter_patient_birthdate',
      desc: '',
      args: [],
    );
  }

  /// `Marital Status`
  String get marital_status {
    return Intl.message(
      'Marital Status',
      name: 'marital_status',
      desc: '',
      args: [],
    );
  }

  /// `Enter marital status`
  String get enter_patient_marital_status {
    return Intl.message(
      'Enter marital status',
      name: 'enter_patient_marital_status',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Enter address`
  String get enter_patient_address {
    return Intl.message(
      'Enter address',
      name: 'enter_patient_address',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Enter social history`
  String get enter_social_history {
    return Intl.message(
      'Enter social history',
      name: 'enter_social_history',
      desc: '',
      args: [],
    );
  }

  /// `Edit social history`
  String get edit_social_history {
    return Intl.message(
      'Edit social history',
      name: 'edit_social_history',
      desc: '',
      args: [],
    );
  }

  /// `Edit notes`
  String get edit_notes {
    return Intl.message('Edit notes', name: 'edit_notes', desc: '', args: []);
  }

  /// `Enter notes`
  String get enter_notes {
    return Intl.message('Enter notes', name: 'enter_notes', desc: '', args: []);
  }

  /// `Edit general information`
  String get edit_general_info {
    return Intl.message(
      'Edit general information',
      name: 'edit_general_info',
      desc: '',
      args: [],
    );
  }

  /// `Edit medications in use`
  String get edit_medications_in_use {
    return Intl.message(
      'Edit medications in use',
      name: 'edit_medications_in_use',
      desc: '',
      args: [],
    );
  }

  /// `Treatment Plan`
  String get treatment_plan {
    return Intl.message(
      'Treatment Plan',
      name: 'treatment_plan',
      desc: '',
      args: [],
    );
  }

  /// `Treatment Plan Name`
  String get treatment_plan_name {
    return Intl.message(
      'Treatment Plan Name',
      name: 'treatment_plan_name',
      desc: '',
      args: [],
    );
  }

  /// `Treatment Plan Type`
  String get treatment_plan_type {
    return Intl.message(
      'Treatment Plan Type',
      name: 'treatment_plan_type',
      desc: '',
      args: [],
    );
  }

  /// `Diagnosis`
  String get diagnosis {
    return Intl.message('Diagnosis', name: 'diagnosis', desc: '', args: []);
  }

  /// `Cost`
  String get cost {
    return Intl.message('Cost', name: 'cost', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Teeth`
  String get teeth {
    return Intl.message('Teeth', name: 'teeth', desc: '', args: []);
  }

  /// `SYP`
  String get syp {
    return Intl.message('SYP', name: 'syp', desc: '', args: []);
  }

  /// `Add Note`
  String get add_notes {
    return Intl.message('Add Note', name: 'add_notes', desc: '', args: []);
  }

  /// `Enter main complaint`
  String get enter_main_complaint {
    return Intl.message(
      'Enter main complaint',
      name: 'enter_main_complaint',
      desc: '',
      args: [],
    );
  }

  /// `Enter diagnosis`
  String get enter_diagnosis {
    return Intl.message(
      'Enter diagnosis',
      name: 'enter_diagnosis',
      desc: '',
      args: [],
    );
  }

  /// `Add Treatment Plan`
  String get add_treatment_plan {
    return Intl.message(
      'Add Treatment Plan',
      name: 'add_treatment_plan',
      desc: '',
      args: [],
    );
  }

  /// `Add Plan`
  String get add_plan {
    return Intl.message('Add Plan', name: 'add_plan', desc: '', args: []);
  }

  /// `Add Disease`
  String get add_disease {
    return Intl.message('Add Disease', name: 'add_disease', desc: '', args: []);
  }

  /// `Add Medication`
  String get add_medication {
    return Intl.message(
      'Add Medication',
      name: 'add_medication',
      desc: '',
      args: [],
    );
  }

  /// `Disease`
  String get disease {
    return Intl.message('Disease', name: 'disease', desc: '', args: []);
  }

  /// `Medication`
  String get medication {
    return Intl.message('Medication', name: 'medication', desc: '', args: []);
  }

  /// `Enter disease`
  String get enter_disease {
    return Intl.message(
      'Enter disease',
      name: 'enter_disease',
      desc: '',
      args: [],
    );
  }

  /// `Enter medication`
  String get enter_medication {
    return Intl.message(
      'Enter medication',
      name: 'enter_medication',
      desc: '',
      args: [],
    );
  }

  /// `Edit Disease`
  String get edit_disease {
    return Intl.message(
      'Edit Disease',
      name: 'edit_disease',
      desc: '',
      args: [],
    );
  }

  /// `Edit Medication`
  String get edit_medication {
    return Intl.message(
      'Edit Medication',
      name: 'edit_medication',
      desc: '',
      args: [],
    );
  }

  /// `Teeth Numbers`
  String get teeth_numbers {
    return Intl.message(
      'Teeth Numbers',
      name: 'teeth_numbers',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get something_wrong {
    return Intl.message(
      'Something went wrong',
      name: 'something_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Step Note`
  String get step_note {
    return Intl.message('Step Note', name: 'step_note', desc: '', args: []);
  }

  /// `Sub-step Note`
  String get substep_note {
    return Intl.message(
      'Sub-step Note',
      name: 'substep_note',
      desc: '',
      args: [],
    );
  }

  /// `Logout Confirmation`
  String get logout_confirmation {
    return Intl.message(
      'Logout Confirmation',
      name: 'logout_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logout_confirmation_msg {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logout_confirmation_msg',
      desc: '',
      args: [],
    );
  }

  /// `Yes, log out`
  String get yes_logout {
    return Intl.message('Yes, log out', name: 'yes_logout', desc: '', args: []);
  }

  /// `Check your internet connection and try again.`
  String get check_your_internet_connection_and_try_again {
    return Intl.message(
      'Check your internet connection and try again.',
      name: 'check_your_internet_connection_and_try_again',
      desc: '',
      args: [],
    );
  }

  /// `You have been logged out successfully.`
  String get logout_success {
    return Intl.message(
      'You have been logged out successfully.',
      name: 'logout_success',
      desc: '',
      args: [],
    );
  }

  /// `Verification Required`
  String get verification_required {
    return Intl.message(
      'Verification Required',
      name: 'verification_required',
      desc: '',
      args: [],
    );
  }

  /// `Your phone number is not verified.`
  String get your_phone_number_is_not_verified {
    return Intl.message(
      'Your phone number is not verified.',
      name: 'your_phone_number_is_not_verified',
      desc: '',
      args: [],
    );
  }

  /// `Please verify your account via WhatsApp.`
  String get please_verify_your_account {
    return Intl.message(
      'Please verify your account via WhatsApp.',
      name: 'please_verify_your_account',
      desc: '',
      args: [],
    );
  }

  /// `Get Verification Code`
  String get get_verification_code {
    return Intl.message(
      'Get Verification Code',
      name: 'get_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enter_phone_number {
    return Intl.message(
      'Enter phone number',
      name: 'enter_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code sent to your WhatsApp number.`
  String get enter_code_sent_to_whatsapp {
    return Intl.message(
      'Enter the code sent to your WhatsApp number.',
      name: 'enter_code_sent_to_whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resend_code {
    return Intl.message('Resend Code', name: 'resend_code', desc: '', args: []);
  }

  /// `Set New Password`
  String get set_new_password {
    return Intl.message(
      'Set New Password',
      name: 'set_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Must be at least 8 characters.`
  String get must_be_at_least_8_characters {
    return Intl.message(
      'Must be at least 8 characters.',
      name: 'must_be_at_least_8_characters',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get enter_new_password {
    return Intl.message(
      'Enter new password',
      name: 'enter_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `All Done!`
  String get all_done {
    return Intl.message('All Done!', name: 'all_done', desc: '', args: []);
  }

  /// `Go to Login Page`
  String get go_to_login_page {
    return Intl.message(
      'Go to Login Page',
      name: 'go_to_login_page',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been reset successfully.`
  String get reset_successfully {
    return Intl.message(
      'Your password has been reset successfully.',
      name: 'reset_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get add_to_cart {
    return Intl.message('Add to Cart', name: 'add_to_cart', desc: '', args: []);
  }

  /// `Verify Your Account`
  String get verify_your_account {
    return Intl.message(
      'Verify Your Account',
      name: 'verify_your_account',
      desc: '',
      args: [],
    );
  }

  /// `Verified!`
  String get verified {
    return Intl.message('Verified!', name: 'verified', desc: '', args: []);
  }

  /// `Your phone number has been successfully verified.`
  String get phone_verified_successfully {
    return Intl.message(
      'Your phone number has been successfully verified.',
      name: 'phone_verified_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Go to Home Page`
  String get go_to_home_page {
    return Intl.message(
      'Go to Home Page',
      name: 'go_to_home_page',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `We will send you reset instructions.`
  String get we_will_send_you_reset_instructions {
    return Intl.message(
      'We will send you reset instructions.',
      name: 'we_will_send_you_reset_instructions',
      desc: '',
      args: [],
    );
  }

  /// `This name is already taken.`
  String get name_already_taken {
    return Intl.message(
      'This name is already taken.',
      name: 'name_already_taken',
      desc: '',
      args: [],
    );
  }

  /// `Add New Step`
  String get add_new_step {
    return Intl.message(
      'Add New Step',
      name: 'add_new_step',
      desc: '',
      args: [],
    );
  }

  /// `Edit Plan`
  String get edit_plan {
    return Intl.message('Edit Plan', name: 'edit_plan', desc: '', args: []);
  }

  /// `Enter step order`
  String get enter_step_queue {
    return Intl.message(
      'Enter step order',
      name: 'enter_step_queue',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get queue {
    return Intl.message('Order', name: 'queue', desc: '', args: []);
  }

  /// `Enter step name`
  String get enter_step_name {
    return Intl.message(
      'Enter step name',
      name: 'enter_step_name',
      desc: '',
      args: [],
    );
  }

  /// `Edit Step`
  String get edit_step {
    return Intl.message('Edit Step', name: 'edit_step', desc: '', args: []);
  }

  /// `Enter sub-step order`
  String get enter_sub_step_queue {
    return Intl.message(
      'Enter sub-step order',
      name: 'enter_sub_step_queue',
      desc: '',
      args: [],
    );
  }

  /// `Enter sub-step name`
  String get enter_sub_step_name {
    return Intl.message(
      'Enter sub-step name',
      name: 'enter_sub_step_name',
      desc: '',
      args: [],
    );
  }

  /// `Edit Sub-step`
  String get edit_sub_step {
    return Intl.message(
      'Edit Sub-step',
      name: 'edit_sub_step',
      desc: '',
      args: [],
    );
  }

  /// `Add New Sub-step`
  String get add_new_sub_step {
    return Intl.message(
      'Add New Sub-step',
      name: 'add_new_sub_step',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `Medication Info`
  String get medication_info {
    return Intl.message(
      'Medication Info',
      name: 'medication_info',
      desc: '',
      args: [],
    );
  }

  /// `Medication Name`
  String get medication_name {
    return Intl.message(
      'Medication Name',
      name: 'medication_name',
      desc: '',
      args: [],
    );
  }

  /// `Medication Plan`
  String get medication_plan {
    return Intl.message(
      'Medication Plan',
      name: 'medication_plan',
      desc: '',
      args: [],
    );
  }

  /// `Edit Medication Plan`
  String get edit_medication_plan {
    return Intl.message(
      'Edit Medication Plan',
      name: 'edit_medication_plan',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message('Days', name: 'days', desc: '', args: []);
  }

  /// `Weeks`
  String get weeks {
    return Intl.message('Weeks', name: 'weeks', desc: '', args: []);
  }

  /// `Months`
  String get months {
    return Intl.message('Months', name: 'months', desc: '', args: []);
  }

  /// `Treatment Note`
  String get treatment_note {
    return Intl.message(
      'Treatment Note',
      name: 'treatment_note',
      desc: '',
      args: [],
    );
  }

  /// `Edit Treatment Note`
  String get edit_treatment_note {
    return Intl.message(
      'Edit Treatment Note',
      name: 'edit_treatment_note',
      desc: '',
      args: [],
    );
  }

  /// `Check your WhatsApp, we sent the code again.`
  String get check_your_whatsapp {
    return Intl.message(
      'Check your WhatsApp, we sent the code again.',
      name: 'check_your_whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `All Patients`
  String get all_patients {
    return Intl.message(
      'All Patients',
      name: 'all_patients',
      desc: '',
      args: [],
    );
  }

  /// `With Treatment Plan`
  String get with_treatment_plan {
    return Intl.message(
      'With Treatment Plan',
      name: 'with_treatment_plan',
      desc: '',
      args: [],
    );
  }

  /// `Without Treatment Plan`
  String get without_treatment_plan {
    return Intl.message(
      'Without Treatment Plan',
      name: 'without_treatment_plan',
      desc: '',
      args: [],
    );
  }

  /// `Patients`
  String get patients {
    return Intl.message('Patients', name: 'patients', desc: '', args: []);
  }

  /// `Your account has been banned.`
  String get account_banned {
    return Intl.message(
      'Your account has been banned.',
      name: 'account_banned',
      desc: '',
      args: [],
    );
  }

  /// `User not found.`
  String get user_not_found {
    return Intl.message(
      'User not found.',
      name: 'user_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Phone number or password does not match our records.`
  String get phone_password_mismatch {
    return Intl.message(
      'Phone number or password does not match our records.',
      name: 'phone_password_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Choose a Treatment Plan`
  String get choose_treatment_plan {
    return Intl.message(
      'Choose a Treatment Plan',
      name: 'choose_treatment_plan',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
  }

  /// `No Results`
  String get no_results {
    return Intl.message('No Results', name: 'no_results', desc: '', args: []);
  }

  /// `Search...`
  String get enter_search {
    return Intl.message('Search...', name: 'enter_search', desc: '', args: []);
  }

  /// `Log Out`
  String get log_out {
    return Intl.message('Log Out', name: 'log_out', desc: '', args: []);
  }

  /// `Profile Image`
  String get profile_image {
    return Intl.message(
      'Profile Image',
      name: 'profile_image',
      desc: '',
      args: [],
    );
  }

  /// `Personal Data`
  String get personal_data {
    return Intl.message(
      'Personal Data',
      name: 'personal_data',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get full_name {
    return Intl.message('Full Name', name: 'full_name', desc: '', args: []);
  }

  /// `SSN`
  String get ssn {
    return Intl.message('SSN', name: 'ssn', desc: '', args: []);
  }

  /// `Ban Expiration Date`
  String get ban_expired_at {
    return Intl.message(
      'Ban Expiration Date',
      name: 'ban_expired_at',
      desc: '',
      args: [],
    );
  }

  /// `Banned`
  String get banned {
    return Intl.message('Banned', name: 'banned', desc: '', args: []);
  }

  /// `Not Banned`
  String get not_banned {
    return Intl.message('Not Banned', name: 'not_banned', desc: '', args: []);
  }

  /// `Filling`
  String get filling {
    return Intl.message('Filling', name: 'filling', desc: '', args: []);
  }

  /// `Endodontic`
  String get endodontic {
    return Intl.message('Endodontic', name: 'endodontic', desc: '', args: []);
  }

  /// `Crown`
  String get crown {
    return Intl.message('Crown', name: 'crown', desc: '', args: []);
  }

  /// `Post`
  String get post {
    return Intl.message('Post', name: 'post', desc: '', args: []);
  }

  /// `Implant`
  String get implant {
    return Intl.message('Implant', name: 'implant', desc: '', args: []);
  }

  /// `Extraction`
  String get extraction {
    return Intl.message('Extraction', name: 'extraction', desc: '', args: []);
  }

  /// `Treated Tooth`
  String get treated {
    return Intl.message('Treated Tooth', name: 'treated', desc: '', args: []);
  }

  /// `Start At`
  String get start_at {
    return Intl.message('Start At', name: 'start_at', desc: '', args: []);
  }

  /// `Until At`
  String get until_at {
    return Intl.message('Until At', name: 'until_at', desc: '', args: []);
  }

  /// `Add Medication Plan`
  String get add_medication_plan {
    return Intl.message(
      'Add Medication Plan',
      name: 'add_medication_plan',
      desc: '',
      args: [],
    );
  }

  /// `Enter medication duration`
  String get enter_medication_duration {
    return Intl.message(
      'Enter medication duration',
      name: 'enter_medication_duration',
      desc: '',
      args: [],
    );
  }

  /// `Enter medication dose`
  String get enter_medication_dose {
    return Intl.message(
      'Enter medication dose',
      name: 'enter_medication_dose',
      desc: '',
      args: [],
    );
  }

  /// `Enter treatment duration`
  String get enter_treatment_duration {
    return Intl.message(
      'Enter treatment duration',
      name: 'enter_treatment_duration',
      desc: '',
      args: [],
    );
  }

  /// `Enter treatment text`
  String get enter_treatment_text {
    return Intl.message(
      'Enter treatment text',
      name: 'enter_treatment_text',
      desc: '',
      args: [],
    );
  }

  /// `Add Treatment Note`
  String get add_treatment_note {
    return Intl.message(
      'Add Treatment Note',
      name: 'add_treatment_note',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get doctor_name {
    return Intl.message('Doctor', name: 'doctor_name', desc: '', args: []);
  }

  /// `Passwords do not match`
  String get passwords_do_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Treatment Notes`
  String get treatment_notes {
    return Intl.message(
      'Treatment Notes',
      name: 'treatment_notes',
      desc: '',
      args: [],
    );
  }

  /// `Medication Plans`
  String get medication_plans {
    return Intl.message(
      'Medication Plans',
      name: 'medication_plans',
      desc: '',
      args: [],
    );
  }

  /// `Medication Plans & Treatment Notes`
  String get medication_plans_and_treatment_notes {
    return Intl.message(
      'Medication Plans & Treatment Notes',
      name: 'medication_plans_and_treatment_notes',
      desc: '',
      args: [],
    );
  }

  /// `Clear Dues`
  String get clear_dues {
    return Intl.message('Clear Dues', name: 'clear_dues', desc: '', args: []);
  }

  /// `Outstanding Dues`
  String get outstanding_dues {
    return Intl.message(
      'Outstanding Dues',
      name: 'outstanding_dues',
      desc: '',
      args: [],
    );
  }

  /// `View Medication Plans & Notes`
  String get view_medication_plans_and_notes {
    return Intl.message(
      'View Medication Plans & Notes',
      name: 'view_medication_plans_and_notes',
      desc: '',
      args: [],
    );
  }

  /// `Search result for`
  String get search_result_for {
    return Intl.message(
      'Search result for',
      name: 'search_result_for',
      desc: '',
      args: [],
    );
  }

  /// `You will delete`
  String get delete_warning_msg_1 {
    return Intl.message(
      'You will delete',
      name: 'delete_warning_msg_1',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get delete_warning_msg_2 {
    return Intl.message(
      'Are you sure?',
      name: 'delete_warning_msg_2',
      desc: '',
      args: [],
    );
  }

  /// `Warning!`
  String get warning {
    return Intl.message('Warning!', name: 'warning', desc: '', args: []);
  }

  /// `Appointments`
  String get appointments {
    return Intl.message(
      'Appointments',
      name: 'appointments',
      desc: '',
      args: [],
    );
  }

  /// `No appointments found`
  String get no_appointments_found {
    return Intl.message(
      'No appointments found',
      name: 'no_appointments_found',
      desc: '',
      args: [],
    );
  }

  /// `Go to date`
  String get go_to_date {
    return Intl.message('Go to date', name: 'go_to_date', desc: '', args: []);
  }

  /// `Min`
  String get min {
    return Intl.message('Min', name: 'min', desc: '', args: []);
  }

  /// `My Schedule`
  String get my_schedule {
    return Intl.message('My Schedule', name: 'my_schedule', desc: '', args: []);
  }

  /// `Add Time`
  String get add_time {
    return Intl.message('Add Time', name: 'add_time', desc: '', args: []);
  }

  /// `Delete Time`
  String get delete_time {
    return Intl.message('Delete Time', name: 'delete_time', desc: '', args: []);
  }

  /// `Edit Time`
  String get edit_time {
    return Intl.message('Edit Time', name: 'edit_time', desc: '', args: []);
  }

  /// `No working hours`
  String get no_working_hours {
    return Intl.message(
      'No working hours',
      name: 'no_working_hours',
      desc: '',
      args: [],
    );
  }

  /// `Select start time`
  String get select_start_time {
    return Intl.message(
      'Select start time',
      name: 'select_start_time',
      desc: '',
      args: [],
    );
  }

  /// `Select end time`
  String get select_end_time {
    return Intl.message(
      'Select end time',
      name: 'select_end_time',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get sunday {
    return Intl.message('Sunday', name: 'sunday', desc: '', args: []);
  }

  /// `Monday`
  String get monday {
    return Intl.message('Monday', name: 'monday', desc: '', args: []);
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message('Tuesday', name: 'tuesday', desc: '', args: []);
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message('Wednesday', name: 'wednesday', desc: '', args: []);
  }

  /// `Thursday`
  String get thursday {
    return Intl.message('Thursday', name: 'thursday', desc: '', args: []);
  }

  /// `Friday`
  String get friday {
    return Intl.message('Friday', name: 'friday', desc: '', args: []);
  }

  /// `Saturday`
  String get saturday {
    return Intl.message('Saturday', name: 'saturday', desc: '', args: []);
  }

  /// `Edit Schedule`
  String get edit_schedule {
    return Intl.message(
      'Edit Schedule',
      name: 'edit_schedule',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while saving`
  String get save_error {
    return Intl.message(
      'An error occurred while saving',
      name: 'save_error',
      desc: '',
      args: [],
    );
  }

  /// `Schedule saved successfully`
  String get save_success {
    return Intl.message(
      'Schedule saved successfully',
      name: 'save_success',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get schedule {
    return Intl.message('Schedule', name: 'schedule', desc: '', args: []);
  }

  /// `Text Size Scale`
  String get text_size_scale {
    return Intl.message(
      'Text Size Scale',
      name: 'text_size_scale',
      desc: '',
      args: [],
    );
  }

  /// `App Theme Color`
  String get app_theme_color {
    return Intl.message(
      'App Theme Color',
      name: 'app_theme_color',
      desc: '',
      args: [],
    );
  }

  /// `Professional Information`
  String get professional_info {
    return Intl.message(
      'Professional Information',
      name: 'professional_info',
      desc: '',
      args: [],
    );
  }

  /// `Specialization`
  String get specialization {
    return Intl.message(
      'Specialization',
      name: 'specialization',
      desc: '',
      args: [],
    );
  }

  /// `Experiences`
  String get experiences {
    return Intl.message('Experiences', name: 'experiences', desc: '', args: []);
  }

  /// `Social & Medical History`
  String get social_status {
    return Intl.message(
      'Social & Medical History',
      name: 'social_status',
      desc: '',
      args: [],
    );
  }

  /// `No notes available`
  String get no_notes {
    return Intl.message(
      'No notes available',
      name: 'no_notes',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Inactive`
  String get inactive {
    return Intl.message('Inactive', name: 'inactive', desc: '', args: []);
  }

  /// `Single`
  String get single {
    return Intl.message('Single', name: 'single', desc: '', args: []);
  }

  /// `Married`
  String get married {
    return Intl.message('Married', name: 'married', desc: '', args: []);
  }

  /// `Divorced`
  String get divorced {
    return Intl.message('Divorced', name: 'divorced', desc: '', args: []);
  }

  /// `Appointment Details`
  String get appointment_details {
    return Intl.message(
      'Appointment Details',
      name: 'appointment_details',
      desc: '',
      args: [],
    );
  }

  /// `Service`
  String get service {
    return Intl.message('Service', name: 'service', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Visit Reason`
  String get visit_reason {
    return Intl.message(
      'Visit Reason',
      name: 'visit_reason',
      desc: '',
      args: [],
    );
  }

  /// `years old`
  String get years_old {
    return Intl.message('years old', name: 'years_old', desc: '', args: []);
  }

  /// `min`
  String get duration_min {
    return Intl.message('min', name: 'duration_min', desc: '', args: []);
  }

  /// `Booked`
  String get booked {
    return Intl.message('Booked', name: 'booked', desc: '', args: []);
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message('Cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `No Data`
  String get no_data {
    return Intl.message('No Data', name: 'no_data', desc: '', args: []);
  }

  /// `There are no patients currently in the clinic`
  String get no_active_patients_subtitle {
    return Intl.message(
      'There are no patients currently in the clinic',
      name: 'no_active_patients_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `There are no appointments for this day`
  String get no_appointments_subtitle {
    return Intl.message(
      'There are no appointments for this day',
      name: 'no_appointments_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `No working schedule has been added yet`
  String get no_schedule_subtitle {
    return Intl.message(
      'No working schedule has been added yet',
      name: 'no_schedule_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `No patients have been added yet`
  String get no_patients_subtitle {
    return Intl.message(
      'No patients have been added yet',
      name: 'no_patients_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get current_password {
    return Intl.message(
      'Current Password',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get password_changed_success {
    return Intl.message(
      'Password changed successfully',
      name: 'password_changed_success',
      desc: '',
      args: [],
    );
  }

  /// `Not available`
  String get not_available {
    return Intl.message(
      'Not available',
      name: 'not_available',
      desc: '',
      args: [],
    );
  }

  /// `Your care is our top priority`
  String get app_slogan {
    return Intl.message(
      'Your care is our top priority',
      name: 'app_slogan',
      desc: '',
      args: [],
    );
  }

  /// `Invalid number`
  String get invalid_number {
    return Intl.message(
      'Invalid number',
      name: 'invalid_number',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `User logged in successfully`
  String get user_logged_in_success {
    return Intl.message(
      'User logged in successfully',
      name: 'user_logged_in_success',
      desc: '',
      args: [],
    );
  }

  /// `Verification successful`
  String get verification_successful {
    return Intl.message(
      'Verification successful',
      name: 'verification_successful',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `sec`
  String get sec {
    return Intl.message('sec', name: 'sec', desc: '', args: []);
  }

  /// `Code sent successfully`
  String get code_sent_successfully {
    return Intl.message(
      'Code sent successfully',
      name: 'code_sent_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been changed successfully!`
  String get your_password_changed_successfully {
    return Intl.message(
      'Your password has been changed successfully!',
      name: 'your_password_changed_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Password is the same as the old one`
  String get password_same_as_old {
    return Intl.message(
      'Password is the same as the old one',
      name: 'password_same_as_old',
      desc: '',
      args: [],
    );
  }

  /// `Change your password`
  String get change_your_password {
    return Intl.message(
      'Change your password',
      name: 'change_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter current password`
  String get enter_current_password {
    return Intl.message(
      'Enter current password',
      name: 'enter_current_password',
      desc: '',
      args: [],
    );
  }

  /// `The password reset code has been sent to your phone number`
  String get reset_code_sent_successfully {
    return Intl.message(
      'The password reset code has been sent to your phone number',
      name: 'reset_code_sent_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Efficient Patient Management`
  String get efficient_patient_management {
    return Intl.message(
      'Efficient Patient Management',
      name: 'efficient_patient_management',
      desc: '',
      args: [],
    );
  }

  /// `Instant Medical Support`
  String get instant_medical_support {
    return Intl.message(
      'Instant Medical Support',
      name: 'instant_medical_support',
      desc: '',
      args: [],
    );
  }

  /// `Manage your patient records and daily clinic schedule with ease and high security.`
  String get manage_your_patient_records_and_daily_clinic_schedule_with_ease {
    return Intl.message(
      'Manage your patient records and daily clinic schedule with ease and high security.',
      name: 'manage_your_patient_records_and_daily_clinic_schedule_with_ease',
      desc: '',
      args: [],
    );
  }

  /// `Our technical support team is always ready to assist you with any clinic operations.`
  String get our_technical_support_team_is_always_ready_to_assist_you {
    return Intl.message(
      'Our technical support team is always ready to assist you with any clinic operations.',
      name: 'our_technical_support_team_is_always_ready_to_assist_you',
      desc: '',
      args: [],
    );
  }

  /// `Prescribe Anywhere`
  String get prescribe_anywhere {
    return Intl.message(
      'Prescribe Anywhere',
      name: 'prescribe_anywhere',
      desc: '',
      args: [],
    );
  }

  /// `Issue digital prescriptions and track family history with just a few clicks from any device.`
  String get issue_digital_prescriptions_and_track_medical_history_with_just_a {
    return Intl.message(
      'Issue digital prescriptions and track family history with just a few clicks from any device.',
      name: 'issue_digital_prescriptions_and_track_medical_history_with_just_a',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get get_started {
    return Intl.message('Get Started', name: 'get_started', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Page not found`
  String get page_not_found {
    return Intl.message(
      'Page not found',
      name: 'page_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successfully`
  String get reset_password_successfully {
    return Intl.message(
      'Password reset successfully',
      name: 'reset_password_successfully',
      desc: '',
      args: [],
    );
  }

  /// `My Patients`
  String get my_patients {
    return Intl.message('My Patients', name: 'my_patients', desc: '', args: []);
  }

  /// `OTP is valid`
  String get otp_is_valid {
    return Intl.message(
      'OTP is valid',
      name: 'otp_is_valid',
      desc: '',
      args: [],
    );
  }

  /// `Results for`
  String get results_for {
    return Intl.message('Results for', name: 'results_for', desc: '', args: []);
  }

  /// `No search results`
  String get no_search_results {
    return Intl.message(
      'No search results',
      name: 'no_search_results',
      desc: '',
      args: [],
    );
  }

  /// `Slot:`
  String get slot {
    return Intl.message('Slot:', name: 'slot', desc: '', args: []);
  }

  /// `clinic`
  String get clinic {
    return Intl.message('clinic', name: 'clinic', desc: '', args: []);
  }

  /// `Arrived`
  String get arrived {
    return Intl.message('Arrived', name: 'arrived', desc: '', args: []);
  }

  /// `Fulfilled`
  String get fulfilled {
    return Intl.message('Fulfilled', name: 'fulfilled', desc: '', args: []);
  }

  /// `No Show`
  String get no_show {
    return Intl.message('No Show', name: 'no_show', desc: '', args: []);
  }

  /// `No pending appointments`
  String get no_pending_appointments {
    return Intl.message(
      'No pending appointments',
      name: 'no_pending_appointments',
      desc: '',
      args: [],
    );
  }

  /// `No booked appointments`
  String get no_booked_appointments {
    return Intl.message(
      'No booked appointments',
      name: 'no_booked_appointments',
      desc: '',
      args: [],
    );
  }

  /// `No arrived appointments`
  String get no_arrived_appointments {
    return Intl.message(
      'No arrived appointments',
      name: 'no_arrived_appointments',
      desc: '',
      args: [],
    );
  }

  /// `No fulfilled appointments`
  String get no_fulfilled_appointments {
    return Intl.message(
      'No fulfilled appointments',
      name: 'no_fulfilled_appointments',
      desc: '',
      args: [],
    );
  }

  /// `No cancelled appointments`
  String get no_cancelled_appointments {
    return Intl.message(
      'No cancelled appointments',
      name: 'no_cancelled_appointments',
      desc: '',
      args: [],
    );
  }

  /// `No no-show appointments`
  String get no_no_show_appointments {
    return Intl.message(
      'No no-show appointments',
      name: 'no_no_show_appointments',
      desc: '',
      args: [],
    );
  }

  /// `Temperature`
  String get vital_temperature {
    return Intl.message(
      'Temperature',
      name: 'vital_temperature',
      desc: '',
      args: [],
    );
  }

  /// `Blood Pressure`
  String get vital_blood_pressure {
    return Intl.message(
      'Blood Pressure',
      name: 'vital_blood_pressure',
      desc: '',
      args: [],
    );
  }

  /// `Heart Rate`
  String get vital_heart_rate {
    return Intl.message(
      'Heart Rate',
      name: 'vital_heart_rate',
      desc: '',
      args: [],
    );
  }

  /// `Respiratory Rate`
  String get vital_respiratory_rate {
    return Intl.message(
      'Respiratory Rate',
      name: 'vital_respiratory_rate',
      desc: '',
      args: [],
    );
  }

  /// `Oxygen Saturation`
  String get vital_oxygen_saturation {
    return Intl.message(
      'Oxygen Saturation',
      name: 'vital_oxygen_saturation',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight_label {
    return Intl.message('Weight', name: 'weight_label', desc: '', args: []);
  }

  /// `Height`
  String get height_label {
    return Intl.message('Height', name: 'height_label', desc: '', args: []);
  }

  /// `Blood Glucose`
  String get vital_blood_glucose {
    return Intl.message(
      'Blood Glucose',
      name: 'vital_blood_glucose',
      desc: '',
      args: [],
    );
  }

  /// `Pain Score`
  String get vital_pain_score {
    return Intl.message(
      'Pain Score',
      name: 'vital_pain_score',
      desc: '',
      args: [],
    );
  }

  /// `BMI`
  String get vital_bmi {
    return Intl.message('BMI', name: 'vital_bmi', desc: '', args: []);
  }

  /// `Overview`
  String get overview {
    return Intl.message('Overview', name: 'overview', desc: '', args: []);
  }

  /// `Observations`
  String get observations {
    return Intl.message(
      'Observations',
      name: 'observations',
      desc: '',
      args: [],
    );
  }

  /// `Medications`
  String get medications_tab {
    return Intl.message(
      'Medications',
      name: 'medications_tab',
      desc: '',
      args: [],
    );
  }

  /// `Chief Complaint`
  String get chief_complaint {
    return Intl.message(
      'Chief Complaint',
      name: 'chief_complaint',
      desc: '',
      args: [],
    );
  }

  /// `Clinical Notes`
  String get clinical_notes {
    return Intl.message(
      'Clinical Notes',
      name: 'clinical_notes',
      desc: '',
      args: [],
    );
  }

  /// `Visit Status`
  String get visit_status {
    return Intl.message(
      'Visit Status',
      name: 'visit_status',
      desc: '',
      args: [],
    );
  }

  /// `Timeline`
  String get timeline {
    return Intl.message('Timeline', name: 'timeline', desc: '', args: []);
  }

  /// `Enter visit reason...`
  String get enter_reason_hint {
    return Intl.message(
      'Enter visit reason...',
      name: 'enter_reason_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add clinical notes...`
  String get add_clinical_notes_hint {
    return Intl.message(
      'Add clinical notes...',
      name: 'add_clinical_notes_hint',
      desc: '',
      args: [],
    );
  }

  /// `Visit Started`
  String get visit_started {
    return Intl.message(
      'Visit Started',
      name: 'visit_started',
      desc: '',
      args: [],
    );
  }

  /// `Visit Finished`
  String get visit_finished {
    return Intl.message(
      'Visit Finished',
      name: 'visit_finished',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get discard {
    return Intl.message('Discard', name: 'discard', desc: '', args: []);
  }

  /// `Save Changes`
  String get save_changes {
    return Intl.message(
      'Save Changes',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `Terminate Session`
  String get terminate_session {
    return Intl.message(
      'Terminate Session',
      name: 'terminate_session',
      desc: '',
      args: [],
    );
  }

  /// `Finish Visit`
  String get finish_visit {
    return Intl.message(
      'Finish Visit',
      name: 'finish_visit',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to finish this visit?`
  String get finish_visit_confirm {
    return Intl.message(
      'Are you sure you want to finish this visit?',
      name: 'finish_visit_confirm',
      desc: '',
      args: [],
    );
  }

  /// `No medications added yet`
  String get no_medications {
    return Intl.message(
      'No medications added yet',
      name: 'no_medications',
      desc: '',
      args: [],
    );
  }

  /// `Add Vital Sign`
  String get add_vital_sign {
    return Intl.message(
      'Add Vital Sign',
      name: 'add_vital_sign',
      desc: '',
      args: [],
    );
  }

  /// `Select Vital Type`
  String get select_vital_type {
    return Intl.message(
      'Select Vital Type',
      name: 'select_vital_type',
      desc: '',
      args: [],
    );
  }

  /// `Add Vital`
  String get add_vital {
    return Intl.message('Add Vital', name: 'add_vital', desc: '', args: []);
  }

  /// `Frequency`
  String get frequency {
    return Intl.message('Frequency', name: 'frequency', desc: '', args: []);
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Enter Code`
  String get enter_code {
    return Intl.message('Enter Code', name: 'enter_code', desc: '', args: []);
  }

  /// `Code`
  String get code {
    return Intl.message('Code', name: 'code', desc: '', args: []);
  }

  /// `Enter Display`
  String get enter_display {
    return Intl.message(
      'Enter Display',
      name: 'enter_display',
      desc: '',
      args: [],
    );
  }

  /// `Display`
  String get display {
    return Intl.message('Display', name: 'display', desc: '', args: []);
  }

  /// `Effective Date`
  String get effective_date {
    return Intl.message(
      'Effective Date',
      name: 'effective_date',
      desc: '',
      args: [],
    );
  }

  /// `Choose Date`
  String get choose_date {
    return Intl.message('Choose Date', name: 'choose_date', desc: '', args: []);
  }

  /// `Issued At`
  String get issued_at {
    return Intl.message('Issued At', name: 'issued_at', desc: '', args: []);
  }

  /// `Value`
  String get value {
    return Intl.message('Value', name: 'value', desc: '', args: []);
  }

  /// `Enter Value`
  String get enter_value {
    return Intl.message('Enter Value', name: 'enter_value', desc: '', args: []);
  }

  /// `Unit`
  String get unit {
    return Intl.message('Unit', name: 'unit', desc: '', args: []);
  }

  /// `Enter Unit`
  String get enter_unit {
    return Intl.message('Enter Unit', name: 'enter_unit', desc: '', args: []);
  }

  /// `Enter Notes ...`
  String get enter_notes_hint {
    return Intl.message(
      'Enter Notes ...',
      name: 'enter_notes_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please select an observation type.`
  String get select_observation_type {
    return Intl.message(
      'Please select an observation type.',
      name: 'select_observation_type',
      desc: '',
      args: [],
    );
  }

  /// `Observation updated successfully.`
  String get observation_updated {
    return Intl.message(
      'Observation updated successfully.',
      name: 'observation_updated',
      desc: '',
      args: [],
    );
  }

  /// `Observation added successfully.`
  String get observation_added {
    return Intl.message(
      'Observation added successfully.',
      name: 'observation_added',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Delete Observation`
  String get delete_observation {
    return Intl.message(
      'Delete Observation',
      name: 'delete_observation',
      desc: '',
      args: [],
    );
  }

  /// `This observation will be permanently deleted.`
  String get observation_delete_warning {
    return Intl.message(
      'This observation will be permanently deleted.',
      name: 'observation_delete_warning',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to continue?`
  String get are_you_sure_continue {
    return Intl.message(
      'Are you sure you want to continue?',
      name: 'are_you_sure_continue',
      desc: '',
      args: [],
    );
  }

  /// `Observation deleted successfully.`
  String get observation_deleted {
    return Intl.message(
      'Observation deleted successfully.',
      name: 'observation_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Token is missing.`
  String get token_missing {
    return Intl.message(
      'Token is missing.',
      name: 'token_missing',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection. Please check your network.`
  String get no_internet_message {
    return Intl.message(
      'No internet connection. Please check your network.',
      name: 'no_internet_message',
      desc: '',
      args: [],
    );
  }

  /// `Last Encounter`
  String get last_encounter {
    return Intl.message(
      'Last Encounter',
      name: 'last_encounter',
      desc: '',
      args: [],
    );
  }

  /// `Next Appointment`
  String get next_appointment {
    return Intl.message(
      'Next Appointment',
      name: 'next_appointment',
      desc: '',
      args: [],
    );
  }

  /// `No records yet`
  String get no_records_yet {
    return Intl.message(
      'No records yet',
      name: 'no_records_yet',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get view_details {
    return Intl.message(
      'View Details',
      name: 'view_details',
      desc: '',
      args: [],
    );
  }

  /// `Patient Info`
  String get patient_info {
    return Intl.message(
      'Patient Info',
      name: 'patient_info',
      desc: '',
      args: [],
    );
  }

  /// `Summary`
  String get summary {
    return Intl.message('Summary', name: 'summary', desc: '', args: []);
  }

  /// `Total Encounters`
  String get total_encounters {
    return Intl.message(
      'Total Encounters',
      name: 'total_encounters',
      desc: '',
      args: [],
    );
  }

  /// `Allergies`
  String get allergies {
    return Intl.message('Allergies', name: 'allergies', desc: '', args: []);
  }

  /// `Active Medications`
  String get active_medications {
    return Intl.message(
      'Active Medications',
      name: 'active_medications',
      desc: '',
      args: [],
    );
  }

  /// `No encounters found`
  String get no_encounters_found {
    return Intl.message(
      'No encounters found',
      name: 'no_encounters_found',
      desc: '',
      args: [],
    );
  }

  /// `No Date`
  String get no_date {
    return Intl.message('No Date', name: 'no_date', desc: '', args: []);
  }

  /// `General Consultation`
  String get general_consultation {
    return Intl.message(
      'General Consultation',
      name: 'general_consultation',
      desc: '',
      args: [],
    );
  }

  /// `No additional notes provided for this encounter.`
  String get no_additional_notes {
    return Intl.message(
      'No additional notes provided for this encounter.',
      name: 'no_additional_notes',
      desc: '',
      args: [],
    );
  }

  /// `Encounters`
  String get encounters {
    return Intl.message('Encounters', name: 'encounters', desc: '', args: []);
  }

  /// `Documents`
  String get documents {
    return Intl.message('Documents', name: 'documents', desc: '', args: []);
  }

  /// `— coming soon`
  String get coming_soon {
    return Intl.message(
      '— coming soon',
      name: 'coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknown_error {
    return Intl.message(
      'Unknown error',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `No time`
  String get no_time {
    return Intl.message('No time', name: 'no_time', desc: '', args: []);
  }

  /// `Invalid time`
  String get invalid_time {
    return Intl.message(
      'Invalid time',
      name: 'invalid_time',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch file`
  String get failed_to_fetch {
    return Intl.message(
      'Failed to fetch file',
      name: 'failed_to_fetch',
      desc: '',
      args: [],
    );
  }

  /// `View Appointment`
  String get view_appointment {
    return Intl.message(
      'View Appointment',
      name: 'view_appointment',
      desc: '',
      args: [],
    );
  }

  /// `characters`
  String get characters {
    return Intl.message('characters', name: 'characters', desc: '', args: []);
  }

  /// `Dosage`
  String get medication_dosage {
    return Intl.message(
      'Dosage',
      name: 'medication_dosage',
      desc: '',
      args: [],
    );
  }

  /// `No vital signs added yet`
  String get no_vitals {
    return Intl.message(
      'No vital signs added yet',
      name: 'no_vitals',
      desc: '',
      args: [],
    );
  }

  /// `Saved successfully`
  String get saved_successfully {
    return Intl.message(
      'Saved successfully',
      name: 'saved_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Encounter Details`
  String get encounter_details {
    return Intl.message(
      'Encounter Details',
      name: 'encounter_details',
      desc: '',
      args: [],
    );
  }

  /// `No encounter data found`
  String get no_encounter_data {
    return Intl.message(
      'No encounter data found',
      name: 'no_encounter_data',
      desc: '',
      args: [],
    );
  }

  /// `Vital Signs`
  String get vital_signs {
    return Intl.message('Vital Signs', name: 'vital_signs', desc: '', args: []);
  }

  /// `Finish`
  String get finish_button {
    return Intl.message('Finish', name: 'finish_button', desc: '', args: []);
  }

  /// `Changes saved successfully.`
  String get save_changes_success {
    return Intl.message(
      'Changes saved successfully.',
      name: 'save_changes_success',
      desc: '',
      args: [],
    );
  }

  /// `Add Code`
  String get add_code {
    return Intl.message('Add Code', name: 'add_code', desc: '', args: []);
  }

  /// `Code Created Successfully.`
  String get code_created_success {
    return Intl.message(
      'Code Created Successfully.',
      name: 'code_created_success',
      desc: '',
      args: [],
    );
  }

  /// `Edit Observation`
  String get edit_observation {
    return Intl.message(
      'Edit Observation',
      name: 'edit_observation',
      desc: '',
      args: [],
    );
  }

  /// `Add Observation`
  String get add_observation {
    return Intl.message(
      'Add Observation',
      name: 'add_observation',
      desc: '',
      args: [],
    );
  }

  /// `Observation Type`
  String get observation_type {
    return Intl.message(
      'Observation Type',
      name: 'observation_type',
      desc: '',
      args: [],
    );
  }

  /// `Blood Type`
  String get blood_type {
    return Intl.message('Blood Type', name: 'blood_type', desc: '', args: []);
  }

  /// `ID`
  String get id_label {
    return Intl.message('ID', name: 'id_label', desc: '', args: []);
  }

  /// `No cached login data found.`
  String get no_cached_login_data {
    return Intl.message(
      'No cached login data found.',
      name: 'no_cached_login_data',
      desc: '',
      args: [],
    );
  }

  /// `Edit Condition`
  String get condition_edit {
    return Intl.message(
      'Edit Condition',
      name: 'condition_edit',
      desc: '',
      args: [],
    );
  }

  /// `Add Condition`
  String get condition_add {
    return Intl.message(
      'Add Condition',
      name: 'condition_add',
      desc: '',
      args: [],
    );
  }

  /// `Condition Type`
  String get condition_type {
    return Intl.message(
      'Condition Type',
      name: 'condition_type',
      desc: '',
      args: [],
    );
  }

  /// `Clinical Status`
  String get clinical_status {
    return Intl.message(
      'Clinical Status',
      name: 'clinical_status',
      desc: '',
      args: [],
    );
  }

  /// `Verification Status`
  String get verification_status {
    return Intl.message(
      'Verification Status',
      name: 'verification_status',
      desc: '',
      args: [],
    );
  }

  /// `Onset Date`
  String get onset_date {
    return Intl.message('Onset Date', name: 'onset_date', desc: '', args: []);
  }

  /// `Abatement Date (optional)`
  String get abatement_date {
    return Intl.message(
      'Abatement Date (optional)',
      name: 'abatement_date',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Please select a condition type.`
  String get select_condition_type {
    return Intl.message(
      'Please select a condition type.',
      name: 'select_condition_type',
      desc: '',
      args: [],
    );
  }

  /// `Please select an onset date.`
  String get select_onset_date {
    return Intl.message(
      'Please select an onset date.',
      name: 'select_onset_date',
      desc: '',
      args: [],
    );
  }

  /// `Condition updated successfully.`
  String get condition_updated {
    return Intl.message(
      'Condition updated successfully.',
      name: 'condition_updated',
      desc: '',
      args: [],
    );
  }

  /// `Condition added successfully.`
  String get condition_added {
    return Intl.message(
      'Condition added successfully.',
      name: 'condition_added',
      desc: '',
      args: [],
    );
  }

  /// `Delete Condition`
  String get delete_condition {
    return Intl.message(
      'Delete Condition',
      name: 'delete_condition',
      desc: '',
      args: [],
    );
  }

  /// `This condition will be permanently deleted.`
  String get condition_delete_warning {
    return Intl.message(
      'This condition will be permanently deleted.',
      name: 'condition_delete_warning',
      desc: '',
      args: [],
    );
  }

  /// `Condition deleted successfully.`
  String get condition_deleted {
    return Intl.message(
      'Condition deleted successfully.',
      name: 'condition_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Onset`
  String get onset_label {
    return Intl.message('Onset', name: 'onset_label', desc: '', args: []);
  }

  /// `Resolved`
  String get resolved_label {
    return Intl.message('Resolved', name: 'resolved_label', desc: '', args: []);
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Note`
  String get note {
    return Intl.message('Note', name: 'note', desc: '', args: []);
  }

  /// `Enter title ...`
  String get enter_title_hint {
    return Intl.message(
      'Enter title ...',
      name: 'enter_title_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter Note ...`
  String get enter_note_hint {
    return Intl.message(
      'Enter Note ...',
      name: 'enter_note_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter Duration ...`
  String get enter_duration_hint {
    return Intl.message(
      'Enter Duration ...',
      name: 'enter_duration_hint',
      desc: '',
      args: [],
    );
  }

  /// `Years`
  String get years {
    return Intl.message('Years', name: 'years', desc: '', args: []);
  }

  /// `Edit Note`
  String get edit_note {
    return Intl.message('Edit Note', name: 'edit_note', desc: '', args: []);
  }

  /// `Note updated successfully.`
  String get note_updated_successfully {
    return Intl.message(
      'Note updated successfully.',
      name: 'note_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Note added successfully.`
  String get note_added_successfully {
    return Intl.message(
      'Note added successfully.',
      name: 'note_added_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Delete Note`
  String get delete_note {
    return Intl.message('Delete Note', name: 'delete_note', desc: '', args: []);
  }

  /// `This note will be permanently deleted.`
  String get note_delete_warning {
    return Intl.message(
      'This note will be permanently deleted.',
      name: 'note_delete_warning',
      desc: '',
      args: [],
    );
  }

  /// `Note deleted successfully.`
  String get note_deleted_successfully {
    return Intl.message(
      'Note deleted successfully.',
      name: 'note_deleted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Update Service Status`
  String get update_service_status {
    return Intl.message(
      'Update Service Status',
      name: 'update_service_status',
      desc: '',
      args: [],
    );
  }

  /// `Optional note ...`
  String get optional_note_hint {
    return Intl.message(
      'Optional note ...',
      name: 'optional_note_hint',
      desc: '',
      args: [],
    );
  }

  /// `Service updated successfully.`
  String get service_updated_successfully {
    return Intl.message(
      'Service updated successfully.',
      name: 'service_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Delete Service`
  String get delete_service {
    return Intl.message(
      'Delete Service',
      name: 'delete_service',
      desc: '',
      args: [],
    );
  }

  /// `This service will be permanently deleted.`
  String get service_delete_warning {
    return Intl.message(
      'This service will be permanently deleted.',
      name: 'service_delete_warning',
      desc: '',
      args: [],
    );
  }

  /// `Service deleted successfully.`
  String get service_deleted_successfully {
    return Intl.message(
      'Service deleted successfully.',
      name: 'service_deleted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Form`
  String get form {
    return Intl.message('Form', name: 'form', desc: '', args: []);
  }

  /// `Add Medication ...`
  String get add_medication_hint {
    return Intl.message(
      'Add Medication ...',
      name: 'add_medication_hint',
      desc: '',
      args: [],
    );
  }

  /// `Strength`
  String get strength {
    return Intl.message('Strength', name: 'strength', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Medication updated successfully.`
  String get medication_updated_successfully {
    return Intl.message(
      'Medication updated successfully.',
      name: 'medication_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Medication added successfully.`
  String get medication_added_successfully {
    return Intl.message(
      'Medication added successfully.',
      name: 'medication_added_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Delete Medication`
  String get delete_medication {
    return Intl.message(
      'Delete Medication',
      name: 'delete_medication',
      desc: '',
      args: [],
    );
  }

  /// `This medication will be permanently deleted.`
  String get medication_delete_warning {
    return Intl.message(
      'This medication will be permanently deleted.',
      name: 'medication_delete_warning',
      desc: '',
      args: [],
    );
  }

  /// `Medication deleted successfully.`
  String get medication_deleted_successfully {
    return Intl.message(
      'Medication deleted successfully.',
      name: 'medication_deleted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Edit Patient Medication`
  String get edit_patient_medication {
    return Intl.message(
      'Edit Patient Medication',
      name: 'edit_patient_medication',
      desc: '',
      args: [],
    );
  }

  /// `Add Patient Medication`
  String get add_patient_medication {
    return Intl.message(
      'Add Patient Medication',
      name: 'add_patient_medication',
      desc: '',
      args: [],
    );
  }

  /// `e.g. once daily`
  String get dosage_hint {
    return Intl.message(
      'e.g. once daily',
      name: 'dosage_hint',
      desc: '',
      args: [],
    );
  }

  /// `Route`
  String get route {
    return Intl.message('Route', name: 'route', desc: '', args: []);
  }

  /// `e.g. tablet`
  String get route_hint {
    return Intl.message('e.g. tablet', name: 'route_hint', desc: '', args: []);
  }

  /// `e.g. 4`
  String get duration_hint {
    return Intl.message('e.g. 4', name: 'duration_hint', desc: '', args: []);
  }

  /// `e.g. take after food`
  String get notes_hint {
    return Intl.message(
      'e.g. take after food',
      name: 'notes_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please select a medication.`
  String get select_medication {
    return Intl.message(
      'Please select a medication.',
      name: 'select_medication',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid duration.`
  String get valid_duration {
    return Intl.message(
      'Please enter a valid duration.',
      name: 'valid_duration',
      desc: '',
      args: [],
    );
  }

  /// `Medication Details`
  String get medication_details {
    return Intl.message(
      'Medication Details',
      name: 'medication_details',
      desc: '',
      args: [],
    );
  }

  /// `Ended`
  String get ended {
    return Intl.message('Ended', name: 'ended', desc: '', args: []);
  }

  /// `Prescription Details`
  String get prescription_details {
    return Intl.message(
      'Prescription Details',
      name: 'prescription_details',
      desc: '',
      args: [],
    );
  }

  /// `Until Date`
  String get until_date {
    return Intl.message('Until Date', name: 'until_date', desc: '', args: []);
  }

  /// `Medication Description`
  String get medication_description {
    return Intl.message(
      'Medication Description',
      name: 'medication_description',
      desc: '',
      args: [],
    );
  }

  /// `See all`
  String get see_all {
    return Intl.message('See all', name: 'see_all', desc: '', args: []);
  }

  /// `No active medications`
  String get no_active_medications {
    return Intl.message(
      'No active medications',
      name: 'no_active_medications',
      desc: '',
      args: [],
    );
  }

  /// `Active Conditions`
  String get active_conditions {
    return Intl.message(
      'Active Conditions',
      name: 'active_conditions',
      desc: '',
      args: [],
    );
  }

  /// `No active conditions`
  String get no_active_conditions {
    return Intl.message(
      'No active conditions',
      name: 'no_active_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Conditions`
  String get conditions {
    return Intl.message('Conditions', name: 'conditions', desc: '', args: []);
  }

  /// `Services`
  String get services {
    return Intl.message('Services', name: 'services', desc: '', args: []);
  }

  /// `Recurrence`
  String get condition_status_recurrence {
    return Intl.message(
      'Recurrence',
      name: 'condition_status_recurrence',
      desc: '',
      args: [],
    );
  }

  /// `Relapse`
  String get condition_status_relapse {
    return Intl.message(
      'Relapse',
      name: 'condition_status_relapse',
      desc: '',
      args: [],
    );
  }

  /// `Remission`
  String get condition_status_remission {
    return Intl.message(
      'Remission',
      name: 'condition_status_remission',
      desc: '',
      args: [],
    );
  }

  /// `Unconfirmed`
  String get verification_status_unconfirmed {
    return Intl.message(
      'Unconfirmed',
      name: 'verification_status_unconfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Provisional`
  String get verification_status_provisional {
    return Intl.message(
      'Provisional',
      name: 'verification_status_provisional',
      desc: '',
      args: [],
    );
  }

  /// `Differential`
  String get verification_status_differential {
    return Intl.message(
      'Differential',
      name: 'verification_status_differential',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed`
  String get verification_status_confirmed {
    return Intl.message(
      'Confirmed',
      name: 'verification_status_confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Refuted`
  String get verification_status_refuted {
    return Intl.message(
      'Refuted',
      name: 'verification_status_refuted',
      desc: '',
      args: [],
    );
  }

  /// `Entered-in-error`
  String get verification_status_entered_in_error {
    return Intl.message(
      'Entered-in-error',
      name: 'verification_status_entered_in_error',
      desc: '',
      args: [],
    );
  }

  /// `Registered`
  String get observation_status_registered {
    return Intl.message(
      'Registered',
      name: 'observation_status_registered',
      desc: '',
      args: [],
    );
  }

  /// `Preliminary`
  String get observation_status_preliminary {
    return Intl.message(
      'Preliminary',
      name: 'observation_status_preliminary',
      desc: '',
      args: [],
    );
  }

  /// `Final`
  String get observation_status_final {
    return Intl.message(
      'Final',
      name: 'observation_status_final',
      desc: '',
      args: [],
    );
  }

  /// `Amended`
  String get observation_status_amended {
    return Intl.message(
      'Amended',
      name: 'observation_status_amended',
      desc: '',
      args: [],
    );
  }

  /// `minute`
  String get duration_minute {
    return Intl.message('minute', name: 'duration_minute', desc: '', args: []);
  }

  /// `minutes`
  String get duration_minutes {
    return Intl.message(
      'minutes',
      name: 'duration_minutes',
      desc: '',
      args: [],
    );
  }

  /// `hour`
  String get duration_hour {
    return Intl.message('hour', name: 'duration_hour', desc: '', args: []);
  }

  /// `hours`
  String get duration_hours {
    return Intl.message('hours', name: 'duration_hours', desc: '', args: []);
  }

  /// `day`
  String get duration_day {
    return Intl.message('day', name: 'duration_day', desc: '', args: []);
  }

  /// `days`
  String get duration_days {
    return Intl.message('days', name: 'duration_days', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Add Lab Test`
  String get add_lab_test {
    return Intl.message(
      'Add Lab Test',
      name: 'add_lab_test',
      desc: '',
      args: [],
    );
  }

  /// `Add Nurse`
  String get add_nurse {
    return Intl.message('Add Nurse', name: 'add_nurse', desc: '', args: []);
  }

  /// `Cancel Lab Test`
  String get cancel_lab_test {
    return Intl.message(
      'Cancel Lab Test',
      name: 'cancel_lab_test',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Completed At`
  String get lab_completed_at {
    return Intl.message(
      'Completed At',
      name: 'lab_completed_at',
      desc: '',
      args: [],
    );
  }

  /// `Ordered At`
  String get lab_ordered_at {
    return Intl.message(
      'Ordered At',
      name: 'lab_ordered_at',
      desc: '',
      args: [],
    );
  }

  /// `Results`
  String get lab_results {
    return Intl.message('Results', name: 'lab_results', desc: '', args: []);
  }

  /// `Sample Collected At`
  String get lab_sample_collected_at {
    return Intl.message(
      'Sample Collected At',
      name: 'lab_sample_collected_at',
      desc: '',
      args: [],
    );
  }

  /// `Lab test added successfully.`
  String get lab_test_added {
    return Intl.message(
      'Lab test added successfully.',
      name: 'lab_test_added',
      desc: '',
      args: [],
    );
  }

  /// `This lab test will be cancelled.`
  String get lab_test_cancel_warning {
    return Intl.message(
      'This lab test will be cancelled.',
      name: 'lab_test_cancel_warning',
      desc: '',
      args: [],
    );
  }

  /// `Lab test deleted successfully.`
  String get lab_test_deleted {
    return Intl.message(
      'Lab test deleted successfully.',
      name: 'lab_test_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Loading medications...`
  String get loading_medications {
    return Intl.message(
      'Loading medications...',
      name: 'loading_medications',
      desc: '',
      args: [],
    );
  }

  /// `Loading nurses...`
  String get loading_nurses {
    return Intl.message(
      'Loading nurses...',
      name: 'loading_nurses',
      desc: '',
      args: [],
    );
  }

  /// `Loading observations...`
  String get loading_observations {
    return Intl.message(
      'Loading observations...',
      name: 'loading_observations',
      desc: '',
      args: [],
    );
  }

  /// `Loading services...`
  String get loading_services {
    return Intl.message(
      'Loading services...',
      name: 'loading_services',
      desc: '',
      args: [],
    );
  }

  /// `Medical Test`
  String get medical_test {
    return Intl.message(
      'Medical Test',
      name: 'medical_test',
      desc: '',
      args: [],
    );
  }

  /// `Nurse added successfully.`
  String get nurse_added_successfully {
    return Intl.message(
      'Nurse added successfully.',
      name: 'nurse_added_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Nurse removed successfully.`
  String get nurse_removed_successfully {
    return Intl.message(
      'Nurse removed successfully.',
      name: 'nurse_removed_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personal_information {
    return Intl.message(
      'Personal Information',
      name: 'personal_information',
      desc: '',
      args: [],
    );
  }

  /// `Please select a nurse.`
  String get please_select_nurse {
    return Intl.message(
      'Please select a nurse.',
      name: 'please_select_nurse',
      desc: '',
      args: [],
    );
  }

  /// `Reference Range`
  String get reference_range {
    return Intl.message(
      'Reference Range',
      name: 'reference_range',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `Remove Nurse`
  String get remove_nurse {
    return Intl.message(
      'Remove Nurse',
      name: 'remove_nurse',
      desc: '',
      args: [],
    );
  }

  /// `This nurse will be removed from the encounter.`
  String get remove_nurse_warning {
    return Intl.message(
      'This nurse will be removed from the encounter.',
      name: 'remove_nurse_warning',
      desc: '',
      args: [],
    );
  }

  /// `Please select a medical test.`
  String get select_medical_test {
    return Intl.message(
      'Please select a medical test.',
      name: 'select_medical_test',
      desc: '',
      args: [],
    );
  }

  /// `Select Nurse`
  String get select_nurse {
    return Intl.message(
      'Select Nurse',
      name: 'select_nurse',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_button {
    return Intl.message(
      'Continue',
      name: 'continue_button',
      desc: '',
      args: [],
    );
  }

  /// `Add Description ...`
  String get add_description_hint {
    return Intl.message(
      'Add Description ...',
      name: 'add_description_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add Medication Form ...`
  String get add_medication_form_hint {
    return Intl.message(
      'Add Medication Form ...',
      name: 'add_medication_form_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add Medication Strength ...`
  String get add_medication_strength_hint {
    return Intl.message(
      'Add Medication Strength ...',
      name: 'add_medication_strength_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add Service`
  String get add_service {
    return Intl.message('Add Service', name: 'add_service', desc: '', args: []);
  }

  /// `AM`
  String get am {
    return Intl.message('AM', name: 'am', desc: '', args: []);
  }

  /// `Chats`
  String get chats {
    return Intl.message('Chats', name: 'chats', desc: '', args: []);
  }

  /// `Choose a chat from the list to start messaging`
  String get choose_a_chat_from_the_list_to_start_messaging {
    return Intl.message(
      'Choose a chat from the list to start messaging',
      name: 'choose_a_chat_from_the_list_to_start_messaging',
      desc: '',
      args: [],
    );
  }

  /// `cm`
  String get cm {
    return Intl.message('cm', name: 'cm', desc: '', args: []);
  }

  /// `Contact Information`
  String get contact_information {
    return Intl.message(
      'Contact Information',
      name: 'contact_information',
      desc: '',
      args: [],
    );
  }

  /// `Enter Dosage ...`
  String get enter_dosage_hint {
    return Intl.message(
      'Enter Dosage ...',
      name: 'enter_dosage_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter Route ...`
  String get enter_route_hint {
    return Intl.message(
      'Enter Route ...',
      name: 'enter_route_hint',
      desc: '',
      args: [],
    );
  }

  /// `kg`
  String get kg {
    return Intl.message('kg', name: 'kg', desc: '', args: []);
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Please select a service.`
  String get please_select_service {
    return Intl.message(
      'Please select a service.',
      name: 'please_select_service',
      desc: '',
      args: [],
    );
  }

  /// `PM`
  String get pm {
    return Intl.message('PM', name: 'pm', desc: '', args: []);
  }

  /// `Search message...`
  String get search_message_hint {
    return Intl.message(
      'Search message...',
      name: 'search_message_hint',
      desc: '',
      args: [],
    );
  }

  /// `Select a conversation`
  String get select_a_conversation {
    return Intl.message(
      'Select a conversation',
      name: 'select_a_conversation',
      desc: '',
      args: [],
    );
  }

  /// `Service added successfully.`
  String get service_added_successfully {
    return Intl.message(
      'Service added successfully.',
      name: 'service_added_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Finished`
  String get status_finished {
    return Intl.message(
      'Finished',
      name: 'status_finished',
      desc: '',
      args: [],
    );
  }

  /// `On Hold`
  String get status_on_hold {
    return Intl.message('On Hold', name: 'status_on_hold', desc: '', args: []);
  }

  /// `On Leave`
  String get status_on_leave {
    return Intl.message(
      'On Leave',
      name: 'status_on_leave',
      desc: '',
      args: [],
    );
  }

  /// `Ordered`
  String get status_ordered {
    return Intl.message('Ordered', name: 'status_ordered', desc: '', args: []);
  }

  /// `Partial`
  String get status_partial {
    return Intl.message('Partial', name: 'status_partial', desc: '', args: []);
  }

  /// `Planned`
  String get status_planned {
    return Intl.message('Planned', name: 'status_planned', desc: '', args: []);
  }

  /// `Stopped`
  String get status_stopped {
    return Intl.message('Stopped', name: 'status_stopped', desc: '', args: []);
  }

  /// `Triaged`
  String get status_triaged {
    return Intl.message('Triaged', name: 'status_triaged', desc: '', args: []);
  }

  /// `Type a message...`
  String get type_a_message_hint {
    return Intl.message(
      'Type a message...',
      name: 'type_a_message_hint',
      desc: '',
      args: [],
    );
  }

  /// `Lab Tests`
  String get labs_tests {
    return Intl.message('Lab Tests', name: 'labs_tests', desc: '', args: []);
  }

  /// `My Encounters`
  String get my_encounters {
    return Intl.message(
      'My Encounters',
      name: 'my_encounters',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get doctor {
    return Intl.message('Doctor', name: 'doctor', desc: '', args: []);
  }

  /// `Dr.`
  String get drPrefix {
    return Intl.message('Dr.', name: 'drPrefix', desc: '', args: []);
  }

  /// `Started`
  String get started {
    return Intl.message('Started', name: 'started', desc: '', args: []);
  }

  /// `No file available`
  String get no_file_available {
    return Intl.message(
      'No file available',
      name: 'no_file_available',
      desc: '',
      args: [],
    );
  }

  /// `Nurses`
  String get nurses {
    return Intl.message('Nurses', name: 'nurses', desc: '', args: []);
  }

  /// `Resolved`
  String get resolved {
    return Intl.message('Resolved', name: 'resolved', desc: '', args: []);
  }

  /// `Differential`
  String get differential {
    return Intl.message(
      'Differential',
      name: 'differential',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load image`
  String get failed_to_load_image {
    return Intl.message(
      'Failed to load image',
      name: 'failed_to_load_image',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
