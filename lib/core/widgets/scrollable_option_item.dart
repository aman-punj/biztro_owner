import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bizrato_owner/core/theme/colors.dart';

class ScrollableOptionItem {
  final int id;
  final String label;
  const ScrollableOptionItem({required this.id, required this.label});
}

class ScrollableOptionList extends StatefulWidget {
  const ScrollableOptionList({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onTap,
    this.maxHeight = 220,
    this.multiSelect = true,
  });

  final List<ScrollableOptionItem> items;
  final Set<int> selectedIds;
  final void Function(ScrollableOptionItem item) onTap;
  final double maxHeight;
  final bool multiSelect;

  @override
  State<ScrollableOptionList> createState() =>
      _ScrollableOptionListState();
}

class _ScrollableOptionListState
    extends State<ScrollableOptionList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          thickness: 4,
          radius: const Radius.circular(4),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxHeight.h),
            child: ListView.separated(
              controller: _scrollController,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.items.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 0, color: AppColors.borderLight),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected =
                    widget.selectedIds.contains(item.id);
                return _OptionRow(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => widget.onTap(item),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final ScrollableOptionItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected
            ? AppColors.primary.withOpacity(0.06)
            : AppColors.white,
        padding: EdgeInsets.symmetric(
            horizontal: 14.w, vertical: 11.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isSelected
                      ? FontWeight.w500
                      : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.white,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.borderLight,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check,
                      size: 12.sp, color: AppColors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}