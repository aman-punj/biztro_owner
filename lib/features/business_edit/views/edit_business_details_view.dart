import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/multi_select_bottom_sheet_field.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/business_edit/controllers/edit_business_details_controller.dart';
import 'package:bizrato_owner/features/business_edit/widgets/widgets.dart';
import 'package:bizrato_owner/features/onboarding/data/models/search_result_model.dart';
import 'package:bizrato_owner/features/business_edit/widgets/business_category_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:bizrato_owner/features/onboarding/widgets/category_search_results_widget.dart';

class EditBusinessDetailsView extends StatefulWidget {
  const EditBusinessDetailsView({super.key});

  @override
  State<EditBusinessDetailsView> createState() =>
      _EditBusinessDetailsViewState();
}

class _EditBusinessDetailsViewState extends State<EditBusinessDetailsView> {
  final EditBusinessDetailsController controller =
  Get.find<EditBusinessDetailsController>();

  late final TextEditingController _searchController;
  late final TextEditingController _customKeywordController;
  late final FocusNode _categoryFocusNode;
  late final FocusNode _customKeywordFocusNode;
  late final VoidCallback _searchListener;
  Worker? _searchQueryWorker;

  @override
  void initState() {
    super.initState();

    _searchController =
        TextEditingController(text: controller.searchQuery.value);

    _customKeywordController = TextEditingController();
    _categoryFocusNode = FocusNode();
    _customKeywordFocusNode = FocusNode();

    _searchListener = () {
      controller.onSearchChanged(_searchController.text);
    };

    _searchController.addListener(_searchListener);

    _searchQueryWorker = ever<String>(
      controller.searchQuery,
      _updateSearchText,
    );
  }

  void _updateSearchText(String value) {
    if (_searchController.text == value) return;

    _searchController.removeListener(_searchListener);

    _searchController.text = value;
    _searchController.selection =
        TextSelection.collapsed(offset: value.length);

    _searchController.addListener(_searchListener);
  }

  void _handleCategoryTap(SearchResultModel result) {
    controller.onCategorySelected(result);
    _updateSearchText(result.displayName);
    FocusScope.of(context).unfocus();
  }

  void _addCustomKeywordFromField() {
    final previousCount = controller.customKeywords.length;
    final value = _customKeywordController.text;

    controller.addCustomKeyword(value);

    if (controller.customKeywords.length != previousCount) {
      _customKeywordController.clear();
      controller.hideCustomKeywordInput();
    }
  }

  void _toggleCustomKeywordInput() {
    if (controller.isAddingCustomKeyword.value) {
      _customKeywordFocusNode.unfocus();
      controller.hideCustomKeywordInput();
      return;
    }

    controller.showCustomKeywordInput();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _customKeywordFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchQueryWorker?.dispose();
    _searchController.removeListener(_searchListener);
    _searchController.dispose();
    _customKeywordController.dispose();
    _categoryFocusNode.dispose();
    _customKeywordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Business Details',
      child: Obx(() {
        if (controller.isLoadingPage.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BusinessEditHeader(
                businessName: controller.businessName,
                subtitle: 'Smart Keywords Selection',
              ),

              SizedBox(height: 16.h),

              OnboardingSectionCard(
                title: 'CATEGORY SEARCH',
                child: Obx(
                      () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BusinessCategorySearchField(
                        controller: _searchController,
                        focusNode: _categoryFocusNode,
                        isCategoryRestored:
                            controller.isCategoryRestored.value,
                        isSearching: controller.isSearching.value,
                        onClearRestoredCategory:
                            controller.clearRestoredCategory,
                        results: CategorySearchResultsWidget(
                          searchResults: controller.searchResults,
                          isSearching: controller.isSearching.value,
                          onCategoryTap: _handleCategoryTap,
                          searchQuery: controller.searchQuery.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Obx(
                    () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: controller.hasSelectedCategory
                      ? _buildKeywordSection()
                      : const SizedBox.shrink(),
                ),
              ),

              SafeArea(
                child: Obx(
                      () => PrimaryButton(
                    label: 'SAVE & CONTINUE',
                    isLoading: controller.isSaving.value,
                    onPressed: controller.saveAndUpdate,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildKeywordSection() {
    return OnboardingSectionCard(
      child: Obx(
            () {
          if (controller.isLoadingKeywords.value) {
            return SizedBox(
              height: 120.h,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTokens.brandPrimary,
                ),
              ),
            );
          }

          final allKeywordOptions = [
            ...controller.qualityKeywords.map((k) => MultiSelectOption(id: k.keywordId, label: k.keyword)),
            ...controller.serviceKeywords.map((k) => MultiSelectOption(id: k.keywordId, label: k.keyword)),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapDown: (_) => _categoryFocusNode.unfocus(),
                child: MultiSelectBottomSheetField(
                  title: 'Select business keywords',
                  options: allKeywordOptions,
                  selectedIds: controller.selectedKeywordIds,
                  onSelectionChanged: (ids) =>
                      controller.setSelectedKeywords(ids),
                  selectionLimit: null,
                  searchHint: 'Search keywords...',
                  searchLabel: 'Keywords',
                ),
              ),

              SizedBox(height: 12.h),

              Text(
                'ADD YOUR OWN',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTokens.textSecondary,
                ),
              ),

              SizedBox(height: 12.h),

              ...controller.customKeywords.map(
                    (keyword) => EditableKeywordRow(
                  value: keyword,
                  onDelete: () =>
                      controller.removeCustomKeyword(keyword),
                  onSave: (value) =>
                      controller.updateCustomKeyword(
                        oldValue: keyword,
                        newValue: value,
                      ),
                ),
              ),

              Obx(() => Column(
                children: [
                  if (controller.isAddingCustomKeyword.value &&
                      controller.canAddMoreKeywords)
                    KeywordInputRow(
                      controller: _customKeywordController,
                      focusNode: _customKeywordFocusNode,
                      isReadOnly: false,
                      hint: 'Enter keyword...',
                      actionIcon: Icons.check,
                      actionBackgroundColor:
                      AppTokens.brandPrimary.withValues(
                        alpha: .12,
                      ),
                      actionIconColor:
                      AppTokens.brandPrimary,
                      onSubmitted: (_) =>
                          _addCustomKeywordFromField(),
                      onAction: _addCustomKeywordFromField,
                    ),

                  if (controller.canAddMoreKeywords)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: OutlinedButton(
                        onPressed: _toggleCustomKeywordInput,
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(
                            double.maxFinite,
                            52.h,
                          ),
                        ),
                        child: Text(
                          controller.isAddingCustomKeyword.value
                              ? 'Cancel'
                              : 'Add Another Keyword',
                        ),
                      ),
                    ),
                ],
              )),
            ],
          );
        },
      ),
    );
  }
}
