import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Smart Digital Gramin Vikas System'**
  String get appName;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'Gujarati'**
  String get gujarati;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @documentLocker.
  ///
  /// In en, this message translates to:
  /// **'Document Locker'**
  String get documentLocker;

  /// No description provided for @complaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get complaints;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @villageNameFallback.
  ///
  /// In en, this message translates to:
  /// **'Village Name'**
  String get villageNameFallback;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get unknownUser;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @villageServices.
  ///
  /// In en, this message translates to:
  /// **'Village Services'**
  String get villageServices;

  /// No description provided for @registerComplaint.
  ///
  /// In en, this message translates to:
  /// **'Register Complaint'**
  String get registerComplaint;

  /// No description provided for @govSchemes.
  ///
  /// In en, this message translates to:
  /// **'Government Schemes'**
  String get govSchemes;

  /// No description provided for @complaintStatus.
  ///
  /// In en, this message translates to:
  /// **'Complaint Status'**
  String get complaintStatus;

  /// No description provided for @farmerAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Farmer Advisory'**
  String get farmerAdvisory;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @enterMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to get started'**
  String get enterMobile;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @invalidMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit number'**
  String get invalidMobile;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Code has been sent to'**
  String get codeSentTo;

  /// No description provided for @enter6DigitOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter 6-digit OTP'**
  String get enter6DigitOtp;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? Resend'**
  String get didntReceiveCode;

  /// No description provided for @completeProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get completeProfile;

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there! Just a few more details'**
  String get almostThere;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @villageName.
  ///
  /// In en, this message translates to:
  /// **'Village Name'**
  String get villageName;

  /// No description provided for @wardNumber.
  ///
  /// In en, this message translates to:
  /// **'Ward Number'**
  String get wardNumber;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout? All local data will remain safe.'**
  String get logoutConfirm;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheCleared;

  /// No description provided for @latestVersion.
  ///
  /// In en, this message translates to:
  /// **'You are using the latest version'**
  String get latestVersion;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'uploaded successfully!'**
  String get uploadSuccess;

  /// No description provided for @documentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Document deleted'**
  String get documentDeleted;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploaded;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @downloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Download started...'**
  String get downloadStarted;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @documentsSaved.
  ///
  /// In en, this message translates to:
  /// **'Documents Saved'**
  String get documentsSaved;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @noDocumentsFound.
  ///
  /// In en, this message translates to:
  /// **'No documents found'**
  String get noDocumentsFound;

  /// No description provided for @uploadedOn.
  ///
  /// In en, this message translates to:
  /// **'Uploaded on'**
  String get uploadedOn;

  /// No description provided for @selectDocumentType.
  ///
  /// In en, this message translates to:
  /// **'Select document type'**
  String get selectDocumentType;

  /// No description provided for @documentTitle.
  ///
  /// In en, this message translates to:
  /// **'Document Title'**
  String get documentTitle;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @giveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Give Feedback'**
  String get giveFeedback;

  /// No description provided for @thankYouVoting.
  ///
  /// In en, this message translates to:
  /// **'Thank you for voting!'**
  String get thankYouVoting;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @villageNoticeBoard.
  ///
  /// In en, this message translates to:
  /// **'Village Notice Board'**
  String get villageNoticeBoard;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @emergencyServices.
  ///
  /// In en, this message translates to:
  /// **'Emergency Services'**
  String get emergencyServices;

  /// No description provided for @noticeDetails.
  ///
  /// In en, this message translates to:
  /// **'Notice Details'**
  String get noticeDetails;

  /// No description provided for @acknowledge.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get acknowledge;

  /// No description provided for @schemeDetails.
  ///
  /// In en, this message translates to:
  /// **'Scheme Details'**
  String get schemeDetails;

  /// No description provided for @pollsSurveys.
  ///
  /// In en, this message translates to:
  /// **'Polls & Surveys'**
  String get pollsSurveys;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @setupProfile.
  ///
  /// In en, this message translates to:
  /// **'Setup Profile'**
  String get setupProfile;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about yourself'**
  String get tellUsAboutYourself;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterVillageName.
  ///
  /// In en, this message translates to:
  /// **'Enter your village name'**
  String get enterVillageName;

  /// No description provided for @completeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Complete Registration'**
  String get completeRegistration;

  /// No description provided for @exploreCategories.
  ///
  /// In en, this message translates to:
  /// **'Explore Categories'**
  String get exploreCategories;

  /// No description provided for @browseSchemesByClick.
  ///
  /// In en, this message translates to:
  /// **'Browse schemes by clicking on any category below'**
  String get browseSchemesByClick;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @farming.
  ///
  /// In en, this message translates to:
  /// **'Farming'**
  String get farming;

  /// No description provided for @pension.
  ///
  /// In en, this message translates to:
  /// **'Pension'**
  String get pension;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @womenWelfare.
  ///
  /// In en, this message translates to:
  /// **'Women Welfare'**
  String get womenWelfare;

  /// No description provided for @objectives.
  ///
  /// In en, this message translates to:
  /// **'Objectives'**
  String get objectives;

  /// No description provided for @eligibility.
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get eligibility;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @docsRequired.
  ///
  /// In en, this message translates to:
  /// **'Documents Required'**
  String get docsRequired;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNow;

  /// No description provided for @ambulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get ambulance;

  /// No description provided for @police.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get police;

  /// No description provided for @fireBrigade.
  ///
  /// In en, this message translates to:
  /// **'Fire Brigade'**
  String get fireBrigade;

  /// No description provided for @villageHelpline.
  ///
  /// In en, this message translates to:
  /// **'Village Helpline'**
  String get villageHelpline;

  /// No description provided for @medicalEmergencies.
  ///
  /// In en, this message translates to:
  /// **'Medical Emergencies'**
  String get medicalEmergencies;

  /// No description provided for @safetySecurity.
  ///
  /// In en, this message translates to:
  /// **'Safety & Security'**
  String get safetySecurity;

  /// No description provided for @fireEmergencies.
  ///
  /// In en, this message translates to:
  /// **'Fire Emergencies'**
  String get fireEmergencies;

  /// No description provided for @panchayatSupport.
  ///
  /// In en, this message translates to:
  /// **'Gram Panchayat Support'**
  String get panchayatSupport;

  /// No description provided for @quickHelp.
  ///
  /// In en, this message translates to:
  /// **'Quick Help'**
  String get quickHelp;

  /// No description provided for @tapCallButton.
  ///
  /// In en, this message translates to:
  /// **'Tap call button for immediate assistance'**
  String get tapCallButton;

  /// No description provided for @stayCalm.
  ///
  /// In en, this message translates to:
  /// **'Stay Calm. Help is on the way.'**
  String get stayCalm;

  /// No description provided for @underConstruction.
  ///
  /// In en, this message translates to:
  /// **'Under Construction'**
  String get underConstruction;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'The {title} feature is coming soon!'**
  String featureComingSoon(Object title);

  /// No description provided for @issueAbout.
  ///
  /// In en, this message translates to:
  /// **'What is the issue about?'**
  String get issueAbout;

  /// No description provided for @chooseCategoryRoute.
  ///
  /// In en, this message translates to:
  /// **'Choose a category to help us route your complaint correctly'**
  String get chooseCategoryRoute;

  /// No description provided for @road.
  ///
  /// In en, this message translates to:
  /// **'Road'**
  String get road;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @electricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get electricity;

  /// No description provided for @sanitation.
  ///
  /// In en, this message translates to:
  /// **'Sanitation'**
  String get sanitation;

  /// No description provided for @agriculture.
  ///
  /// In en, this message translates to:
  /// **'Agriculture'**
  String get agriculture;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @latestNotices.
  ///
  /// In en, this message translates to:
  /// **'Latest Notices'**
  String get latestNotices;

  /// No description provided for @powerOutageNotice.
  ///
  /// In en, this message translates to:
  /// **'Power Outage scheduled for Saturday'**
  String get powerOutageNotice;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @gramSabhaNotice.
  ///
  /// In en, this message translates to:
  /// **'Gram Sabha Meeting this Sunday'**
  String get gramSabhaNotice;

  /// No description provided for @important.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// No description provided for @communityVoice.
  ///
  /// In en, this message translates to:
  /// **'Community Voice'**
  String get communityVoice;

  /// No description provided for @morePolls.
  ///
  /// In en, this message translates to:
  /// **'More Polls'**
  String get morePolls;

  /// No description provided for @pollQuestion.
  ///
  /// In en, this message translates to:
  /// **'Should the new park be built near the bus stand?'**
  String get pollQuestion;

  /// No description provided for @totalVotes.
  ///
  /// In en, this message translates to:
  /// **'Total 248 Votes'**
  String get totalVotes;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @waterCutNotice.
  ///
  /// In en, this message translates to:
  /// **'Water Cut tomorrow 10 AM - 4 PM'**
  String get waterCutNotice;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @activePoll.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE POLL'**
  String get activePoll;

  /// No description provided for @thankYouForVoting.
  ///
  /// In en, this message translates to:
  /// **'Thank you for voting!'**
  String get thankYouForVoting;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'CLOSED'**
  String get closed;

  /// No description provided for @votesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} votes'**
  String votesCount(int count);

  /// No description provided for @complaintDetails.
  ///
  /// In en, this message translates to:
  /// **'Complaint Details'**
  String get complaintDetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @provideDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Provide details about the issue...'**
  String get provideDetailsHint;

  /// No description provided for @addAttachments.
  ///
  /// In en, this message translates to:
  /// **'Add Attachments (Optional)'**
  String get addAttachments;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @submitComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get submitComplaint;

  /// No description provided for @pleaseEnterDetails.
  ///
  /// In en, this message translates to:
  /// **'Please enter complaint details'**
  String get pleaseEnterDetails;

  /// No description provided for @categoryPrefix.
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String categoryPrefix(Object category);

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @noComplaintsFound.
  ///
  /// In en, this message translates to:
  /// **'No complaints found'**
  String get noComplaintsFound;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @adminRemarks.
  ///
  /// In en, this message translates to:
  /// **'Admin Remarks'**
  String get adminRemarks;

  /// No description provided for @complaintSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Complaint Submitted!'**
  String get complaintSubmitted;

  /// No description provided for @complaintRegisteredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your complaint has been registered successfully.'**
  String get complaintRegisteredSuccess;

  /// No description provided for @complaintIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Complaint ID'**
  String get complaintIdLabel;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to Dashboard'**
  String get backToDashboard;

  /// No description provided for @freeScheme.
  ///
  /// In en, this message translates to:
  /// **'Free Scheme'**
  String get freeScheme;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @farmerAdvisoryBoard.
  ///
  /// In en, this message translates to:
  /// **'Farmer Advisory Board'**
  String get farmerAdvisoryBoard;

  /// No description provided for @downloadingAdvisoryData.
  ///
  /// In en, this message translates to:
  /// **'Downloading advisory data for offline access...'**
  String get downloadingAdvisoryData;

  /// No description provided for @cropCalendarMonsoon.
  ///
  /// In en, this message translates to:
  /// **'Crop Calendar - Monsoon Season'**
  String get cropCalendarMonsoon;

  /// No description provided for @marketMandiPrices.
  ///
  /// In en, this message translates to:
  /// **'Market (Mandi) Prices'**
  String get marketMandiPrices;

  /// No description provided for @resourcesAvailability.
  ///
  /// In en, this message translates to:
  /// **'Resources & Availability'**
  String get resourcesAvailability;

  /// No description provided for @departmentalNotices.
  ///
  /// In en, this message translates to:
  /// **'Departmental Notices'**
  String get departmentalNotices;

  /// No description provided for @irrigationAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Advisory'**
  String get irrigationAdvisory;

  /// No description provided for @heavyRainfallExpected.
  ///
  /// In en, this message translates to:
  /// **'Heavy rainfall expected in next 48 hours. Postpone irrigation and fertilizer application.'**
  String get heavyRainfallExpected;

  /// No description provided for @cropNameCotton.
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get cropNameCotton;

  /// No description provided for @cropNameGroundnut.
  ///
  /// In en, this message translates to:
  /// **'Groundnut'**
  String get cropNameGroundnut;

  /// No description provided for @cropNameSoybean.
  ///
  /// In en, this message translates to:
  /// **'Soybean'**
  String get cropNameSoybean;

  /// No description provided for @cropNameWheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get cropNameWheat;

  /// No description provided for @cropNameCumin.
  ///
  /// In en, this message translates to:
  /// **'Cumin'**
  String get cropNameCumin;

  /// No description provided for @stageSowing.
  ///
  /// In en, this message translates to:
  /// **'Sowing'**
  String get stageSowing;

  /// No description provided for @recommendedDates.
  ///
  /// In en, this message translates to:
  /// **'Recommended: {dates}'**
  String recommendedDates(String dates);

  /// No description provided for @ideal.
  ///
  /// In en, this message translates to:
  /// **'Ideal'**
  String get ideal;

  /// No description provided for @planning.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get planning;

  /// No description provided for @mandiTaluka.
  ///
  /// In en, this message translates to:
  /// **'Taluka Mandi'**
  String get mandiTaluka;

  /// No description provided for @mandiDistrict.
  ///
  /// In en, this message translates to:
  /// **'District Mandi'**
  String get mandiDistrict;

  /// No description provided for @mandiMain.
  ///
  /// In en, this message translates to:
  /// **'Main Mandi'**
  String get mandiMain;

  /// No description provided for @mandiRegional.
  ///
  /// In en, this message translates to:
  /// **'Regional Mandi'**
  String get mandiRegional;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @seedsSoybeanCotton.
  ///
  /// In en, this message translates to:
  /// **'Seeds (Soybean/Cotton)'**
  String get seedsSoybeanCotton;

  /// No description provided for @ureaFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Urea Fertilizer'**
  String get ureaFertilizer;

  /// No description provided for @organicPesticides.
  ///
  /// In en, this message translates to:
  /// **'Organic Pesticides'**
  String get organicPesticides;

  /// No description provided for @pestAlertNotif.
  ///
  /// In en, this message translates to:
  /// **'Pest Alert: Fall Armyworm detected in nearby district.'**
  String get pestAlertNotif;

  /// No description provided for @solarPumpSubsidy.
  ///
  /// In en, this message translates to:
  /// **'New subsidy on solar water pumps under PM-KUSUM.'**
  String get solarPumpSubsidy;

  /// No description provided for @cropCalendarDetails.
  ///
  /// In en, this message translates to:
  /// **'Crop Calendar Details'**
  String get cropCalendarDetails;

  /// No description provided for @monsoonKharif.
  ///
  /// In en, this message translates to:
  /// **'Monsoon (Kharif)'**
  String get monsoonKharif;

  /// No description provided for @winterRabi.
  ///
  /// In en, this message translates to:
  /// **'Winter (Rabi)'**
  String get winterRabi;

  /// No description provided for @summerZaid.
  ///
  /// In en, this message translates to:
  /// **'Summer (Zaid)'**
  String get summerZaid;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @harvesting.
  ///
  /// In en, this message translates to:
  /// **'Harvesting'**
  String get harvesting;

  /// No description provided for @bestSoil.
  ///
  /// In en, this message translates to:
  /// **'Best Soil'**
  String get bestSoil;

  /// No description provided for @waterNeed.
  ///
  /// In en, this message translates to:
  /// **'Water Need'**
  String get waterNeed;

  /// No description provided for @advisoryNotes.
  ///
  /// In en, this message translates to:
  /// **'Advisory Notes:'**
  String get advisoryNotes;

  /// No description provided for @marketPricesDetails.
  ///
  /// In en, this message translates to:
  /// **'Market Prices Details'**
  String get marketPricesDetails;

  /// No description provided for @searchCropMarket.
  ///
  /// In en, this message translates to:
  /// **'Search crop or market...'**
  String get searchCropMarket;

  /// No description provided for @avgPrefix.
  ///
  /// In en, this message translates to:
  /// **'Avg: '**
  String get avgPrefix;

  /// No description provided for @minPrice.
  ///
  /// In en, this message translates to:
  /// **'MIN PRICE'**
  String get minPrice;

  /// No description provided for @maxPrice.
  ///
  /// In en, this message translates to:
  /// **'MAX PRICE'**
  String get maxPrice;

  /// No description provided for @varietyLokwan.
  ///
  /// In en, this message translates to:
  /// **'Lokwan'**
  String get varietyLokwan;

  /// No description provided for @varietyBT.
  ///
  /// In en, this message translates to:
  /// **'BT Cotton'**
  String get varietyBT;

  /// No description provided for @varietySpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get varietySpanish;

  /// No description provided for @varietyYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get varietyYellow;

  /// No description provided for @varietyPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get varietyPremium;

  /// No description provided for @howWasExperience.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get howWasExperience;

  /// No description provided for @feedbackImproveServices.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve government services for everyone.'**
  String get feedbackImproveServices;

  /// No description provided for @addComments.
  ///
  /// In en, this message translates to:
  /// **'Add Comments'**
  String get addComments;

  /// No description provided for @tellUsMoreHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us more about the service...'**
  String get tellUsMoreHint;

  /// No description provided for @submitFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank You!'**
  String get thankYou;

  /// No description provided for @feedbackSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your feedback has been submitted successfully.'**
  String get feedbackSubmittedSuccess;

  /// No description provided for @backToStatus.
  ///
  /// In en, this message translates to:
  /// **'Back to Status'**
  String get backToStatus;

  /// No description provided for @complaintIdPrefix.
  ///
  /// In en, this message translates to:
  /// **'Complaint ID: {id}'**
  String complaintIdPrefix(Object id);

  /// No description provided for @announcement.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get announcement;

  /// No description provided for @noticeContactInfo.
  ///
  /// In en, this message translates to:
  /// **'For further queries, please contact the Panchayat Bhavan or your Ward Member.'**
  String get noticeContactInfo;

  /// No description provided for @noticeTypeWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get noticeTypeWater;

  /// No description provided for @noticeTypePower.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get noticeTypePower;

  /// No description provided for @noticeTypeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get noticeTypeGeneral;

  /// No description provided for @urgentCaps.
  ///
  /// In en, this message translates to:
  /// **'URGENT'**
  String get urgentCaps;

  /// No description provided for @announcementWaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Urgent: Water Pipe Repair'**
  String get announcementWaterTitle;

  /// No description provided for @announcementWaterMsg.
  ///
  /// In en, this message translates to:
  /// **'Water supply will be suspended in Area A and B tomorrow from 10 AM to 4 PM due to main pipe repair works. The repair is necessary for resolving the leakage near the Water Tank 3. Residents are advised to store sufficient water in advance. We apologize for the inconvenience caused.'**
  String get announcementWaterMsg;

  /// No description provided for @announcementPowerTitle.
  ///
  /// In en, this message translates to:
  /// **'Power Outage Schedule'**
  String get announcementPowerTitle;

  /// No description provided for @announcementPowerMsg.
  ///
  /// In en, this message translates to:
  /// **'Scheduled maintenance by GEB. Power cut expected on Saturday from 9 AM to 1 PM across the village. This maintenance is part of the annual grid upgrading process to ensure stable power supply during the upcoming monsoon season. Please complete your electrically dependent tasks accordingly.'**
  String get announcementPowerMsg;

  /// No description provided for @announcementGramSabhaTitle.
  ///
  /// In en, this message translates to:
  /// **'Gram Sabha Meeting'**
  String get announcementGramSabhaTitle;

  /// No description provided for @announcementGramSabhaMsg.
  ///
  /// In en, this message translates to:
  /// **'All residents are invited to the Gram Sabha meeting at Panchayat Bhavan this Sunday to discuss the new monsoon road projects.'**
  String get announcementGramSabhaMsg;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @yourDocuments.
  ///
  /// In en, this message translates to:
  /// **'Your Documents'**
  String get yourDocuments;

  /// No description provided for @searchDocuments.
  ///
  /// In en, this message translates to:
  /// **'Search documents...'**
  String get searchDocuments;

  /// No description provided for @itemsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsFound(Object count);

  /// No description provided for @aadhaarCard.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Card'**
  String get aadhaarCard;

  /// No description provided for @rationCard.
  ///
  /// In en, this message translates to:
  /// **'Ration Card'**
  String get rationCard;

  /// No description provided for @incomeCertificate.
  ///
  /// In en, this message translates to:
  /// **'Income Certificate'**
  String get incomeCertificate;

  /// No description provided for @landDocuments.
  ///
  /// In en, this message translates to:
  /// **'Land Documents'**
  String get landDocuments;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(Object count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(Object count);

  /// No description provided for @notifComplaintTitle.
  ///
  /// In en, this message translates to:
  /// **'Complaint Update'**
  String get notifComplaintTitle;

  /// No description provided for @notifComplaintMsg.
  ///
  /// In en, this message translates to:
  /// **'Your complaint regarding road pothole has been moved to \"In Progress\".'**
  String get notifComplaintMsg;

  /// No description provided for @notifSchemeTitle.
  ///
  /// In en, this message translates to:
  /// **'New Scheme Alert'**
  String get notifSchemeTitle;

  /// No description provided for @notifSchemeMsg.
  ///
  /// In en, this message translates to:
  /// **'New farming subsidy scheme \"Mukhyaministri Kisan Sahay\" is now available.'**
  String get notifSchemeMsg;

  /// No description provided for @notifAnnouncementTitle.
  ///
  /// In en, this message translates to:
  /// **'Village Announcement'**
  String get notifAnnouncementTitle;

  /// No description provided for @notifAnnouncementMsg.
  ///
  /// In en, this message translates to:
  /// **'Gram Sabha meeting scheduled for Sunday at 10:00 AM in Panchayat Bhavan.'**
  String get notifAnnouncementMsg;

  /// No description provided for @documentTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My {type}'**
  String documentTitleHint(Object type);

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @dataAndStorage.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get dataAndStorage;

  /// No description provided for @clearOfflineCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Offline Cache'**
  String get clearOfflineCache;

  /// No description provided for @offlineCacheSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current size: {size}'**
  String offlineCacheSubtitle(Object size);

  /// No description provided for @syncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get syncStatus;

  /// No description provided for @lastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced: {time}'**
  String lastSynced(Object time);

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// No description provided for @waitingVerification.
  ///
  /// In en, this message translates to:
  /// **'Account Verification Pending'**
  String get waitingVerification;

  /// No description provided for @verificationPendingDescription.
  ///
  /// In en, this message translates to:
  /// **'Your mobile number has been registered. Please visit the Gram Panchayat for physical verification with your documents.'**
  String get verificationPendingDescription;

  /// No description provided for @panchayatMemberNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Panchayat Sabhya Name'**
  String get panchayatMemberNameLabel;

  /// No description provided for @panchayatAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Panchayat Address'**
  String get panchayatAddressLabel;

  /// No description provided for @panchayatMemberName.
  ///
  /// In en, this message translates to:
  /// **'Mr. Rajeshbhai Patel'**
  String get panchayatMemberName;

  /// No description provided for @panchayatAddress.
  ///
  /// In en, this message translates to:
  /// **'Gram Panchayat Bhavan, Ground Floor, Ward No. 3'**
  String get panchayatAddress;

  /// No description provided for @refreshStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh Status'**
  String get refreshStatus;

  /// No description provided for @logoutVerification.
  ///
  /// In en, this message translates to:
  /// **'Logout & Use Different Number'**
  String get logoutVerification;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Smart Village Management'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Experience comprehensive village management at your fingertips. Track local development projects, view real-time statistics, and participate in local governance digitally for a better tomorrow.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Secure Digital Locker'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Your essential documents are safe with us. Securely store and access your Aadhar, PAN, and Voter ID anytime. Seamlessly apply for government services without the paperwork hassle.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Community Network'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Stay connected with your community. Receive instant alerts on local events and government schemes. Engage in meaningful discussions to drive collective growth for your village.'**
  String get onboardingDesc3;

  /// No description provided for @chatbot.
  ///
  /// In en, this message translates to:
  /// **'Chatbot'**
  String get chatbot;

  /// No description provided for @villageAssistant.
  ///
  /// In en, this message translates to:
  /// **'Village Assistant'**
  String get villageAssistant;

  /// No description provided for @askAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything...'**
  String get askAnything;

  /// No description provided for @howCanIHelp.
  ///
  /// In en, this message translates to:
  /// **'Hi! How can I help you today?'**
  String get howCanIHelp;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAMessage;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dob;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Permanent Address'**
  String get address;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @noNoticesFound.
  ///
  /// In en, this message translates to:
  /// **'No notices found'**
  String get noNoticesFound;

  /// No description provided for @noSchemesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No schemes available'**
  String get noSchemesAvailable;

  /// No description provided for @noCropCalendarFound.
  ///
  /// In en, this message translates to:
  /// **'No crop calendar found'**
  String get noCropCalendarFound;

  /// No description provided for @noMandiPricesFound.
  ///
  /// In en, this message translates to:
  /// **'No mandi prices found'**
  String get noMandiPricesFound;

  /// No description provided for @noAgriResourcesFound.
  ///
  /// In en, this message translates to:
  /// **'No agricultural resources found'**
  String get noAgriResourcesFound;

  /// No description provided for @stillWaitingVerification.
  ///
  /// In en, this message translates to:
  /// **'Your account is still pending verification. Please visit the Gram Panchayat office.'**
  String get stillWaitingVerification;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
