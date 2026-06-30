import 'package:hive_flutter/adapters.dart';
import 'package:sdgvs/core/hive_models/complaint_hive_model.dart';
import 'package:sdgvs/core/hive_models/document_hive_model.dart';
import 'package:sdgvs/core/hive_models/feedback_hive_model.dart';
import 'package:sdgvs/core/hive_models/notice_hive_model.dart';
import 'package:sdgvs/core/hive_models/notification_hive_model.dart';
import 'package:sdgvs/core/hive_models/poll_hive_model.dart';
import 'package:sdgvs/core/hive_models/scheme_hive_model.dart';
import 'package:sdgvs/core/hive_models/user_hive_model.dart';

import '../hive_models/crop_calendar_hive_model.dart';
import '../hive_models/mandi_price_hive_model.dart';
import '../hive_models/agri_resource_hive_model.dart';
import '../models/user_model.dart';
import '../models/complaint_model.dart';
import '../models/notice_model.dart';
import '../models/scheme_model.dart';
import '../models/poll_model.dart';
import '../models/document_model.dart';
import '../models/notification_model.dart';
import '../models/feedback_model.dart';
import '../models/news_model.dart';
import '../hive_models/news_hive_model.dart';
import '../models/crop_calendar_model.dart';
import '../models/mandi_price_model.dart';
import '../models/agri_resource_model.dart';
import '../models/weather_alert_model.dart';
import '../models/agri_notice_model.dart';
import '../models/admin_model.dart';
import '../hive_models/weather_alert_hive_model.dart';
import '../hive_models/agri_notice_hive_model.dart';
import '../hive_models/admin_hive_model.dart';

/// Central Hive offline data store manager.
/// Call [HiveService.init()] in main() before runApp().
class HiveService {
  static const String _userBoxName = 'userBox';
  static const String _complaintsBoxName = 'complaintsBox';
  static const String _noticesBoxName = 'noticesBox';
  static const String _schemesBoxName = 'schemesBox';
  static const String _pollsBoxName = 'pollsBox';
  static const String _documentsBoxName = 'documentsBox';
  static const String _notificationsBoxName = 'notificationsBox';
  static const String _feedbackBoxName = 'feedbackBox';
  static const String _cropCalendarBoxName = 'cropCalendarBox';
  static const String _mandiPricesBoxName = 'mandiPricesBox';
  static const String _agriResourcesBoxName = 'agriResourcesBox';
  static const String _newsBoxName = 'newsBox';
  static const String _weatherAlertsBoxName = 'weatherAlertsBox';
  static const String _agriNoticesBoxName = 'agriNoticesBox';
  static const String _adminBoxName = 'adminBox';

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register all adapters
    Hive.registerAdapter(UserHiveModelAdapter());
    Hive.registerAdapter(ComplaintHiveModelAdapter());
    Hive.registerAdapter(NoticeHiveModelAdapter());
    Hive.registerAdapter(SchemeHiveModelAdapter());
    Hive.registerAdapter(PollOptionHiveModelAdapter());
    Hive.registerAdapter(PollHiveModelAdapter());
    Hive.registerAdapter(DocumentHiveModelAdapter());
    Hive.registerAdapter(NotificationHiveModelAdapter());
    Hive.registerAdapter(FeedbackHiveModelAdapter());
    Hive.registerAdapter(CropCalendarHiveModelAdapter());
    Hive.registerAdapter(MandiPriceHiveModelAdapter());
    Hive.registerAdapter(AgriResourceHiveModelAdapter());
    Hive.registerAdapter(NewsHiveModelAdapter());
    Hive.registerAdapter(WeatherAlertHiveModelAdapter());
    Hive.registerAdapter(AgriNoticeHiveModelAdapter());
    Hive.registerAdapter(AdminHiveModelAdapter());

    // Open all boxes
    await Hive.openBox<UserHiveModel>(_userBoxName);
    await Hive.openBox<ComplaintHiveModel>(_complaintsBoxName);
    await Hive.openBox<NoticeHiveModel>(_noticesBoxName);
    await Hive.openBox<SchemeHiveModel>(_schemesBoxName);
    await Hive.openBox<PollHiveModel>(_pollsBoxName);
    await Hive.openBox<DocumentHiveModel>(_documentsBoxName);
    await Hive.openBox<NotificationHiveModel>(_notificationsBoxName);
    await Hive.openBox<FeedbackHiveModel>(_feedbackBoxName);
    await Hive.openBox<CropCalendarHiveModel>(_cropCalendarBoxName);
    await Hive.openBox<MandiPriceHiveModel>(_mandiPricesBoxName);
    await Hive.openBox<AgriResourceHiveModel>(_agriResourcesBoxName);
    await Hive.openBox<NewsHiveModel>(_newsBoxName);
    await Hive.openBox<WeatherAlertHiveModel>(_weatherAlertsBoxName);
    await Hive.openBox<AgriNoticeHiveModel>(_agriNoticesBoxName);
    await Hive.openBox<AdminHiveModel>(_adminBoxName);
    await Hive.openBox('settingsBox');
  }

  // ---------------------------------------------------------------------------
  // Box Getters
  // ---------------------------------------------------------------------------

  static Box<UserHiveModel> get _userBox =>
      Hive.box<UserHiveModel>(_userBoxName);
  static Box<ComplaintHiveModel> get _complaintsBox =>
      Hive.box<ComplaintHiveModel>(_complaintsBoxName);
  static Box<NoticeHiveModel> get _noticesBox =>
      Hive.box<NoticeHiveModel>(_noticesBoxName);
  static Box<SchemeHiveModel> get _schemesBox =>
      Hive.box<SchemeHiveModel>(_schemesBoxName);
  static Box<PollHiveModel> get _pollsBox =>
      Hive.box<PollHiveModel>(_pollsBoxName);
  static Box<DocumentHiveModel> get _documentsBox =>
      Hive.box<DocumentHiveModel>(_documentsBoxName);
  static Box<NotificationHiveModel> get _notificationsBox =>
      Hive.box<NotificationHiveModel>(_notificationsBoxName);
  static Box<FeedbackHiveModel> get _feedbackBox =>
      Hive.box<FeedbackHiveModel>(_feedbackBoxName);
  static Box<CropCalendarHiveModel> get _cropCalendarBox =>
      Hive.box<CropCalendarHiveModel>(_cropCalendarBoxName);
  static Box<MandiPriceHiveModel> get _mandiPricesBox =>
      Hive.box<MandiPriceHiveModel>(_mandiPricesBoxName);
  static Box<AgriResourceHiveModel> get _agriResourcesBox =>
      Hive.box<AgriResourceHiveModel>(_agriResourcesBoxName);
  static Box<NewsHiveModel> get _newsBox =>
      Hive.box<NewsHiveModel>(_newsBoxName);
  static Box<WeatherAlertHiveModel> get _weatherAlertsBox =>
      Hive.box<WeatherAlertHiveModel>(_weatherAlertsBoxName);
  static Box<AgriNoticeHiveModel> get _agriNoticesBox =>
      Hive.box<AgriNoticeHiveModel>(_agriNoticesBoxName);
  static Box<AdminHiveModel> get _adminBox =>
      Hive.box<AdminHiveModel>(_adminBoxName);

  // ---------------------------------------------------------------------------
  // USER
  // ---------------------------------------------------------------------------

  static Future<void> saveUser(UserModel user) async {
    final hiveUser = UserHiveModel(
      id: user.id,
      name: user.name,
      village: user.village,
      district: user.district,
      taluka: user.taluka,
      mobile: user.mobile,
      isVerified: user.isVerified,
      profileImage: user.profileImage,
      email: user.email,
      gender: user.gender,
      dob: user.dob,
      address: user.address,
      occupation: user.occupation,
      villageId: user.villageId,
      status: user.status,
      lastLogin: user.lastLogin,
    );
    await _userBox.put('currentUser', hiveUser);
  }

  static UserModel? getUser() {
    final hiveUser = _userBox.get('currentUser');
    if (hiveUser == null) return null;
    return UserModel(
      id: hiveUser.id ?? '',
      name: hiveUser.name,
      village: hiveUser.village,
      district: hiveUser.district,
      taluka: hiveUser.taluka,
      mobile: hiveUser.mobile,
      isVerified: hiveUser.isVerified,
      profileImage: hiveUser.profileImage,
      email: hiveUser.email,
      gender: hiveUser.gender,
      dob: hiveUser.dob,
      address: hiveUser.address,
      occupation: hiveUser.occupation,
      villageId: hiveUser.villageId,
      status: hiveUser.status,
      lastLogin: hiveUser.lastLogin,
    );
  }

  static Future<void> saveAdmin(AdminModel admin) async {
    final hiveAdmin = AdminHiveModel(
      id: admin.id,
      name: admin.name,
      email: admin.email,
      role: admin.role,
      villageId: admin.villageId,
      isFirstLogin: admin.isFirstLogin,
      status: admin.status,
    );
    await _adminBox.put('currentAdmin', hiveAdmin);
  }

  static AdminModel? getAdmin() {
    final h = _adminBox.get('currentAdmin');
    if (h == null) return null;
    return AdminModel(
      id: h.id,
      name: h.name,
      email: h.email,
      role: h.role,
      villageId: h.villageId,
      isFirstLogin: h.isFirstLogin,
      status: h.status,
    );
  }

  static Future<void> clearAdmin() async {
    await _adminBox.delete('currentAdmin');
  }

  static Future<void> clearUser() async {
    await _userBox.delete('currentUser');
  }

  // ---------------------------------------------------------------------------
  // COMPLAINTS
  // ---------------------------------------------------------------------------

  static Future<void> addComplaint(
    ComplaintModel complaint, {
    bool pendingSync = true,
  }) async {
    final hiveComplaint = ComplaintHiveModel(
      id: complaint.id,
      category: complaint.category,
      description: complaint.description,
      imagePath: complaint.imagePath,
      voicePath: complaint.voicePath,
      timestamp: complaint.timestamp,
      status: complaint.status,
      adminRemarks: complaint.adminRemarks,
      pendingSync: pendingSync,
    );
    await _complaintsBox.put(complaint.id, hiveComplaint);
  }

  static List<ComplaintModel> getPendingSyncComplaints() {
    return _complaintsBox.values
        .where((h) => h.pendingSync == true)
        .map(
          (h) => ComplaintModel(
            id: h.id,
            category: h.category,
            description: h.description,
            imagePath: h.imagePath,
            voicePath: h.voicePath,
            timestamp: h.timestamp,
            status: h.status,
            adminRemarks: h.adminRemarks,
          ),
        )
        .toList();
  }

  static List<ComplaintModel> getAllComplaints() {
    return _complaintsBox.values
        .map(
          (h) => ComplaintModel(
            id: h.id,
            category: h.category,
            description: h.description,
            imagePath: h.imagePath,
            voicePath: h.voicePath,
            timestamp: h.timestamp,
            status: h.status,
            adminRemarks: h.adminRemarks,
          ),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static Future<void> updateComplaintStatus({
    required String id,
    required String status,
    String? adminRemarks,
  }) async {
    final hive = _complaintsBox.get(id);
    if (hive != null) {
      hive.status = status;
      hive.adminRemarks = adminRemarks;
      hive.pendingSync = false;
      await hive.save();
    }
  }

  static Future<void> deleteComplaint(String id) async {
    await _complaintsBox.delete(id);
  }

  // ---------------------------------------------------------------------------
  // NOTICES
  // ---------------------------------------------------------------------------

  static Future<void> cacheNotices(List<NoticeModel> notices) async {
    await _noticesBox.clear();
    for (final notice in notices) {
      final hive = NoticeHiveModel(
        id: notice.id,
        title: notice.title,
        message: notice.message,
        typeIndex: notice.type.index,
        date: notice.date,
        isHighPriority: (notice.priorityOrder ?? 0) > 0,
      );
      await _noticesBox.put(notice.id, hive);
    }
  }

  static List<NoticeModel> getCachedNotices() {
    return _noticesBox.values
        .map(
          (h) => NoticeModel(
            id: h.id,
            title: h.title,
            message: h.message,
            type: NoticeType.values[h.typeIndex],
            date: h.date,
            priorityOrder: h.isHighPriority ? 1 : 0,
          ),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static bool get hasNoticesCache => _noticesBox.isNotEmpty;

  // ---------------------------------------------------------------------------
  // NEWS
  // ---------------------------------------------------------------------------

  static Future<void> cacheNews(List<NewsModel> news) async {
    await _newsBox.clear();
    for (final item in news) {
      final hive = NewsHiveModel(
        id: item.id,
        title: item.title,
        description: item.description,
        categoryIndex: item.category.index,
        date: item.date,
        imageUrl: item.imageUrl,
        author: item.author,
        likes: item.likes,
        userLiked: item.userLiked,
      );
      await _newsBox.put(item.id, hive);
    }
  }

  static List<NewsModel> getCachedNews() {
    return _newsBox.values
        .map(
          (h) => NewsModel(
            id: h.id,
            title: h.title,
            description: h.description,
            category: NewsCategory.values[h.categoryIndex],
            date: h.date,
            imageUrl: h.imageUrl,
            author: h.author,
            likes: h.likes,
            userLiked: h.userLiked ?? false,
          ),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static bool get hasNewsCache => _newsBox.isNotEmpty;

  // ---------------------------------------------------------------------------
  // SCHEMES
  // ---------------------------------------------------------------------------

  static Future<void> cacheSchemes(List<SchemeModel> schemes) async {
    await _schemesBox.clear();
    for (final scheme in schemes) {
      final hive = SchemeHiveModel(
        id: scheme.id,
        title: scheme.title,
        category: scheme.category,
        description: scheme.description,
        objectives: scheme.objectives,
        eligibility: scheme.eligibility,
        benefits: scheme.benefits,
        documentsRequired: scheme.documentsRequired,
      );
      await _schemesBox.put(scheme.id, hive);
    }
  }

  static List<SchemeModel> getCachedSchemes({String? category}) {
    final all = _schemesBox.values
        .map(
          (h) => SchemeModel(
            id: h.id,
            title: h.title,
            category: h.category,
            description: h.description,
            objectives: h.objectives,
            eligibility: h.eligibility,
            benefits: h.benefits,
            documentsRequired: h.documentsRequired,
          ),
        )
        .toList();
    if (category != null) {
      return all.where((s) => s.category == category).toList();
    }
    return all;
  }

  static bool get hasSchemesCache => _schemesBox.isNotEmpty;

  // ---------------------------------------------------------------------------
  // POLLS
  // ---------------------------------------------------------------------------

  static Future<void> cachePolls(List<PollModel> polls) async {
    await _pollsBox.clear();
    for (final poll in polls) {
      final hive = PollHiveModel(
        id: poll.id,
        question: poll.question,
        options: poll.options
            .map((o) => PollOptionHiveModel(id: o.id, text: o.text, votes: o.votes))
            .toList(),
        totalVotes: poll.totalVotes,
        expiryDate: poll.expiryDate,
        userVotedOptionIndex: poll.userVotedOptionIndex,
      );
      await _pollsBox.put(poll.id, hive);
    }
  }

  static List<PollModel> getCachedPolls() {
    return _pollsBox.values
        .map(
          (h) => PollModel(
            id: h.id,
            question: h.question,
            options: h.options
                .map((o) => PollOption(id: o.id, text: o.text, votes: o.votes))
                .toList(),
            totalVotes: h.totalVotes,
            expiryDate: h.expiryDate,
            userVotedOptionIndex: h.userVotedOptionIndex,
          ),
        )
        .toList();
  }

  static bool get hasPollsCache => _pollsBox.isNotEmpty;

  static Future<void> recordLocalVote(String pollId, int optionIndex) async {
    final hive = _pollsBox.get(pollId);
    if (hive != null &&
        hive.userVotedOptionIndex == null &&
        optionIndex < hive.options.length) {
      hive.options[optionIndex].votes += 1;
      hive.totalVotes += 1;
      hive.userVotedOptionIndex = optionIndex;
      await hive.save();
    }
  }

  // ---------------------------------------------------------------------------
  // DOCUMENTS (Locker)
  // ---------------------------------------------------------------------------

  static Future<void> addDocument(DocumentModel doc) async {
    final hive = DocumentHiveModel(
      id: doc.id,
      title: doc.title,
      type: doc.type,
      uploadDate: doc.uploadDate,
      filePath: doc.filePath,
    );
    await _documentsBox.put(doc.id, hive);
  }

  /// Replaces the full local cache with the latest list from the server.
  static Future<void> cacheDocuments(List<DocumentModel> docs) async {
    await _documentsBox.clear();
    for (final doc in docs) {
      final hive = DocumentHiveModel(
        id: doc.id,
        title: doc.title,
        type: doc.type,
        uploadDate: doc.uploadDate,
        filePath: doc.filePath,
      );
      await _documentsBox.put(doc.id, hive);
    }
  }

  static List<DocumentModel> getAllDocuments() {
    return _documentsBox.values
        .map(
          (h) => DocumentModel(
            id: h.id,
            title: h.title,
            type: h.type,
            uploadDate: h.uploadDate,
            filePath: h.filePath ?? '',
          ),
        )
        .toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  static Future<void> deleteDocument(String id) async {
    await _documentsBox.delete(id);
  }

  static int get documentCount => _documentsBox.length;

  // ---------------------------------------------------------------------------
  // NOTIFICATIONS
  // ---------------------------------------------------------------------------

  static Future<void> cacheNotifications(
    List<NotificationModel> notifications,
  ) async {
    // Preserve local read states from Hive before clearing
    final Map<String, bool> localReadStates = {};
    for (final hiveModel in _notificationsBox.values) {
      localReadStates[hiveModel.id] = hiveModel.isRead;
    }

    await _notificationsBox.clear();
    for (final n in notifications) {
      final isLocalRead = localReadStates[n.id] ?? n.isRead;
      final hive = NotificationHiveModel(
        id: n.id,
        title: n.title,
        message: n.message,
        typeIndex: n.type.index,
        timestamp: n.timestamp,
        isRead: isLocalRead,
      );
      await _notificationsBox.put(n.id, hive);
    }
  }

  static List<NotificationModel> getCachedNotifications() {
    return _notificationsBox.values
        .map(
          (h) => NotificationModel(
            id: h.id,
            title: h.title,
            message: h.message,
            type: NotificationType.values[h.typeIndex],
            timestamp: h.timestamp,
            isRead: h.isRead,
          ),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static bool get hasNotificationsCache => _notificationsBox.isNotEmpty;

  static int get unreadNotificationCount =>
      _notificationsBox.values.where((n) => !n.isRead).length;

  /// Mark a single notification as read and persist.
  static Future<void> markNotificationRead(String id) async {
    final hive = _notificationsBox.get(id);
    if (hive != null) {
      hive.isRead = true;
      await hive.save();
    }
  }

  /// Mark all notifications as read and persist.
  static Future<void> markAllNotificationsRead() async {
    for (final hive in _notificationsBox.values) {
      if (!hive.isRead) {
        hive.isRead = true;
        await hive.save();
      }
    }
  }

  // ---------------------------------------------------------------------------
  // FEEDBACK
  // ---------------------------------------------------------------------------

  static Future<void> addFeedback(FeedbackModel feedback) async {
    final hive = FeedbackHiveModel(
      id: feedback.id,
      complaintId: feedback.complaintId,
      rating: feedback.rating,
      comments: feedback.comments,
      timestamp: feedback.timestamp,
    );
    await _feedbackBox.put(feedback.id, hive);
  }

  static List<FeedbackModel> getAllFeedback() {
    final user = getUser();
    final currentUserId = user?.id ?? '';
    return _feedbackBox.values
        .map(
          (h) => FeedbackModel(
            id: h.id,
            complaintId: h.complaintId,
            rating: h.rating,
            comments: h.comments,
            timestamp: h.timestamp,
            userId: currentUserId,
          ),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static List<FeedbackModel> getFeedbackForComplaint(String complaintId) {
    return getAllFeedback().where((f) => f.complaintId == complaintId).toList();
  }

  // ---------------------------------------------------------------------------
  // LOCKER
  // ---------------------------------------------------------------------------

  static Future<void> cacheCropCalendar(List<CropCalendarModel> items) async {
    await _cropCalendarBox.clear();
    for (final item in items) {
      await _cropCalendarBox.put(
        item.id,
        CropCalendarHiveModel(
          id: item.id,
          cropName: item.cropName,
          stage: item.stage,
          recommendedDates: item.recommendedDates,
          status: item.status,
          season: item.season,
          sowingPeriod: item.sowingPeriod,
          duration: item.duration,
          harvestPeriod: item.harvestPeriod,
          bestSoil: item.bestSoil,
          waterRequirement: item.waterRequirement,
          description: item.description,
        ),
      );
    }
  }

  static List<CropCalendarModel> getCachedCropCalendar() {
    return _cropCalendarBox.values
        .map(
          (h) => CropCalendarModel(
            id: h.id,
            cropName: h.cropName,
            stage: h.stage,
            recommendedDates: h.recommendedDates,
            status: h.status,
            season: h.season,
            sowingPeriod: h.sowingPeriod,
            duration: h.duration,
            harvestPeriod: h.harvestPeriod,
            bestSoil: h.bestSoil,
            waterRequirement: h.waterRequirement,
            description: h.description,
          ),
        )
        .toList();
  }

  static Future<void> cacheMandiPrices(List<MandiPriceModel> items) async {
    await _mandiPricesBox.clear();
    for (final item in items) {
      await _mandiPricesBox.put(
        item.id,
        MandiPriceHiveModel(
          id: item.id,
          cropName: item.cropName,
          price: item.price,
          change: item.change,
          mandi: item.mandi,
          minPrice: item.minPrice,
          maxPrice: item.maxPrice,
          unit: item.unit,
          status: item.status,
          date: item.date,
        ),
      );
    }
  }

  static List<MandiPriceModel> getCachedMandiPrices() {
    return _mandiPricesBox.values
        .map(
          (h) => MandiPriceModel(
            id: h.id,
            cropName: h.cropName,
            price: h.price,
            maxPrice: h.maxPrice,
            minPrice: h.minPrice,
            unit: h.unit,
            status: h.status,
            change: h.change,
            mandi: h.mandi,
            date: h.date,
          ),
        )
        .toList();
  }

  static Future<void> cacheAgriResources(List<AgriResourceModel> items) async {
    await _agriResourcesBox.clear();
    for (final item in items) {
      await _agriResourcesBox.put(
        item.id,
        AgriResourceHiveModel(
          id: item.id,
          resourceName: item.resourceName,
          availabilityPercent: item.availabilityPercent,
          statusColor: item.statusColor,
        ),
      );
    }
  }

  static List<AgriResourceModel> getCachedAgriResources() {
    return _agriResourcesBox.values
        .map(
          (h) => AgriResourceModel(
            id: h.id,
            resourceName: h.resourceName,
            availabilityPercent: h.availabilityPercent,
            statusColor: h.statusColor,
          ),
        )
        .toList();
  }

  static Future<void> cacheWeatherAlerts(List<WeatherAlertModel> items) async {
    await _weatherAlertsBox.clear();
    for (final item in items) {
      await _weatherAlertsBox.put(
        item.id,
        WeatherAlertHiveModel(
          id: item.id,
          title: item.title,
          message: item.message,
          level: item.level,
          expiresAt: item.expiresAt,
        ),
      );
    }
  }

  static List<WeatherAlertModel> getCachedWeatherAlerts() {
    return _weatherAlertsBox.values
        .map(
          (h) => WeatherAlertModel(
            id: h.id,
            title: h.title,
            message: h.message,
            level: h.level,
            expiresAt: h.expiresAt,
          ),
        )
        .toList();
  }

  static Future<void> cacheAgriNotices(List<AgriNoticeModel> items) async {
    await _agriNoticesBox.clear();
    for (final item in items) {
      await _agriNoticesBox.put(
        item.id,
        AgriNoticeHiveModel(
          id: item.id,
          title: item.title,
          message: item.message,
          date: item.date,
        ),
      );
    }
  }

  static List<AgriNoticeModel> getCachedAgriNotices() {
    return _agriNoticesBox.values
        .map(
          (h) => AgriNoticeModel(
            id: h.id,
            title: h.title,
            message: h.message,
            date: h.date,
          ),
        )
        .toList();
  }

  // ---------------------------------------------------------------------------
  // CLOSE (optional — for testing / cleanup)
  // ---------------------------------------------------------------------------

  static Future<void> closeAll() async {
    await Hive.close();
  }
}
