import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_checkbox.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MultiSelectOption {
  final int id;
  final String label;

  const MultiSelectOption({required this.id, required this.label});
}

class MultiSelectBottomSheetField extends StatelessWidget {
  const MultiSelectBottomSheetField({
    required this.title,
    required this.options,
    required this.selectedIds,
    required this.onSelectionChanged,
    super.key,
    this.hint = 'Select options',
    this.selectionLimit,
    this.showSelectionCount = true,
  });

  final String title;
  final String hint;
  final List<MultiSelectOption> options;
  final Set<int> selectedIds;
  final ValueChanged<Set<int>> onSelectionChanged;
  final int? selectionLimit;
  final bool showSelectionCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPickerField(context),
        if (selectedIds.isNotEmpty) ...[
          SizedBox(height: 12.h),
          _buildSelectedChips(),
        ],
      ],
    );
  }

  Widget _buildPickerField(BuildContext context) {
    return InkWell(
      onTap: () => _showBottomSheet(context),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppTokens.inputBackground,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppTokens.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTokens.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _selectionText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTokens.textSecondary,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedChips() {
    final selectedOptions =
        options.where((opt) => selectedIds.contains(opt.id)).toList();

    const int maxVisibleChips = 3;
    final visibleOptions = selectedOptions.take(maxVisibleChips).toList();
    final remainingCount = selectedOptions.length - visibleOptions.length;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        ...visibleOptions.map((opt) => _Chip(label: opt.label)),
        if (remainingCount > 0) _Chip(label: '+$remainingCount more'),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    FocusScope.of(context).unfocus();
    Get.bottomSheet(
      _BottomSheetContent(
        title: title,
        options: options,
        initialSelectedIds: selectedIds,
        selectionLimit: selectionLimit,
        showSelectionCount: showSelectionCount,
        onDone: onSelectionChanged,
      ),
      isScrollControlled: true,
      backgroundColor: AppTokens.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
    );
  }

  String get _selectionText {
    if (!showSelectionCount) {
      return hint;
    }
    if (selectionLimit == null) {
      return '${selectedIds.length} selected';
    }
    return '${selectedIds.length} / $selectionLimit selected';
  }
}

class _BottomSheetContent extends StatefulWidget {
  const _BottomSheetContent({
    required this.title,
    required this.options,
    required this.initialSelectedIds,
    required this.selectionLimit,
    required this.showSelectionCount,
    required this.onDone,
  });

  final String title;
  final List<MultiSelectOption> options;
  final Set<int> initialSelectedIds;
  final int? selectionLimit;
  final bool showSelectionCount;
  final ValueChanged<Set<int>> onDone;

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  late Set<int> _tempSelectedIds;
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tempSelectedIds = Set.from(widget.initialSelectedIds);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MultiSelectOption> get _filteredOptions {
    if (_searchQuery.isEmpty) return widget.options;
    return widget.options
        .where((opt) =>
            opt.label.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleOption(int id) {
    final limit = widget.selectionLimit;
    final canSelectMore = limit == null || _tempSelectedIds.length < limit;
    setState(() {
      if (_tempSelectedIds.contains(id)) {
        _tempSelectedIds.remove(id);
      } else if (canSelectMore) {
        _tempSelectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          _buildHandle(),
          SizedBox(height: 16.h),
          _buildHeader(),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _searchController,
            hintText: 'Search services...',
            title: 'Services...',
            prefixIcon: Icon(Icons.search, size: 20.sp, color: AppTokens.textSecondary),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredOptions.length,
              separatorBuilder: (_, __) => Divider(color: AppTokens.border, height: 1),
              itemBuilder: (context, index) {
                final opt = _filteredOptions[index];
                final isSelected = _tempSelectedIds.contains(opt.id);
                final limit = widget.selectionLimit;
                final isLimitReached =
                    limit != null && _tempSelectedIds.length >= limit && !isSelected;

                return _OptionTile(
                  label: opt.label,
                  isSelected: isSelected,
                  isDisabled: isLimitReached,
                  onTap: () => _toggleOption(opt.id),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: AppTokens.border,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.textPrimary,
                ),
              ),
              if (widget.showSelectionCount)
                Text(
                  _headerSelectionText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTokens.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onDone(Set<int>.from(_tempSelectedIds));
            Get.back();
          },
          child: Text(
            'Done',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTokens.brandPrimary,
            ),
          ),
        ),
      ],
    );
  }

  String get _headerSelectionText {
    if (!widget.showSelectionCount) {
      return '';
    }
    if (widget.selectionLimit == null) {
      return '${_tempSelectedIds.length} selected';
    }
    return '${_tempSelectedIds.length} / ${widget.selectionLimit} selected';
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDisabled = false,
  });

  final String label;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: isDisabled ? null : onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          color: isDisabled ? AppTokens.textSecondary : AppTokens.textPrimary,
        ),
      ),
      trailing: AppCheckbox(
        isSelected: isSelected,
        size: 20.w,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppTokens.selectionBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppTokens.brandPrimary.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppTokens.brandPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
