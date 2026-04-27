import 'package:bizrato_owner/core/network/app_errors.dart';
import 'package:bizrato_owner/features/leads/data/models/lead_model.dart';
import 'package:bizrato_owner/features/leads/data/repositories/leads_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';

class LeadsController extends GetxController {
  LeadsController(this._repository);

  final LeadsRepository _repository;
  final AppToastService _toastService = Get.find<AppToastService>();


  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  final leads = <LeadModel>[].obs;
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  static const List<String> leadStatusFilters = [
    'Interested',
    'Converted',
    'Not Interested',
    'Follow-up',
    'Ringing',
    'Junk Lead',
    'Busy',
    'Wrong Number',
    'Switched Off',
    'Price Issue',
    'Location Issue',
  ];

  final selectedLeadStatuses = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
    fetchLeads();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchLeads() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    final response = await _repository.getLeads();

    if (response.success && response.data != null) {
      leads.value = response.data!;
    } else {
      hasError.value = true;
      errorMessage.value = response.message;
      if (response.message == AppErrors.noInternet ||
          response.message == AppErrors.serverNotResponding) {
        _toastService.error(response.message);
      }
    }

    isLoading.value = false;
  }

  List<LeadModel> get filteredLeads {
    var result = leads.toList();

    // Basic search filtering
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((lead) {
        return lead.userName.toLowerCase().contains(query) ||
            (lead.city?.toLowerCase().contains(query) ?? false) ||
            lead.userId.toString().contains(query);
      }).toList();
    }

    if (selectedLeadStatuses.isNotEmpty) {
      final selectedNormalized = selectedLeadStatuses
          .map(_normalizeStatus)
          .toSet();
      result = result.where((lead) {
        final status = _normalizeStatus(lead.leadStatus);
        return status.isNotEmpty && selectedNormalized.contains(status);
      }).toList();
    }

    result.sort((a, b) {
      if (a.leadDate == null) return 1;
      if (b.leadDate == null) return -1;
      final dateA = DateTime.tryParse(a.leadDate!) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = DateTime.tryParse(b.leadDate!) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA);
    });

    return result;
  }

  String _normalizeStatus(String? status) {
    if (status == null) return '';
    return status.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  Future<void> callLead(String? mobileNo) async {
    if (mobileNo == null || mobileNo.trim().isEmpty) {
      _toastService.warning('Phone number is not available for this lead.');
      return;
    }

    final sanitizedNumber = mobileNo.trim();
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: sanitizedNumber,
    );
    
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _toastService.error('Could not launch dialer.');
      }
    } catch (e) {
      _toastService.error('Could not launch dialer.');
    }
  }

  void handleAction(LeadModel lead) {
    // Stub definition as per user instructions
  }

  void handleDetails(LeadModel lead) {
    // Stub definition as per user instructions
  }

  void toggleLeadStatusFilter(String status) {
    if (selectedLeadStatuses.contains(status)) {
      selectedLeadStatuses.remove(status);
      return;
    }
    selectedLeadStatuses.add(status);
  }

  void clearLeadStatusFilters() {
    selectedLeadStatuses.clear();
    leads.refresh();
  }

  void applyFilter() {
    // trigger rebuilds or refresh if needed. Currently computing via getter.
    Get.back(); // close bottom sheet
    leads.refresh();
  }
}
