import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  State<ScrollableOptionList> createState() => _ScrollableOptionListState();
}

class _ScrollableOptionListState extends State<ScrollableOptionList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 3.w, // Thin scrollbar as per UI
      radius: const Radius.circular(10),
      thumbColor: AppColors.borderLight, // Matches the grey scroll track look
      padding: EdgeInsets.only(right: 2.w), // Creates the "minor gap" from the edge
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.maxHeight.h),
        child: ListView.separated(
          controller: _scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.only(right: 12.w), // Spacing between cards and scrollbar
          physics: const ClampingScrollPhysics(),
          itemCount: widget.items.length,
          // No divider between cards in the new UI style
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final isSelected = widget.selectedIds.contains(item.id);
            return _OptionRow(
              item: item,
              isSelected: isSelected,
              onTap: () => widget.onTap(item),
            );
          },
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          decoration: BoxDecoration(
            // Blue tint for selected, white/transparent for unselected
            color: isSelected
                ? AppColors.primary.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            // Border changes color based on selection
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderLight,
              width: 1.2,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ),
              // The circular check indicator
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.borderLight,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}