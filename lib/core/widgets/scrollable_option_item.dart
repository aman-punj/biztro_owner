import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
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
    this.title,
    this.titleIconPath,
  });

  final List<ScrollableOptionItem> items;
  final Set<int> selectedIds;
  final void Function(ScrollableOptionItem item) onTap;
  final double maxHeight;
  final bool multiSelect;
  final String? title;
  final String? titleIconPath;

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
    final hasHeader = (widget.title?.trim().isNotEmpty ?? false);

    return Container(
      decoration: BoxDecoration(
        color: AppTokens.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasHeader)
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 8.h),
              child: Row(
                children: [
                  if (widget.titleIconPath?.trim().isNotEmpty ?? false) ...[
                    AppImage(
                      path: widget.titleIconPath!,
                      width: 14.w,
                      height: 14.w,
                      showLoading: false,
                    ),
                    SizedBox(width: 6.w),
                  ],
                  Expanded(
                    child: Text(
                      widget.title!.trim(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTokens.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          RawScrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thickness: 3.w,
            radius: const Radius.circular(10),
            thumbColor: AppTokens.border,
            padding: EdgeInsets.only(right: 2.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.maxHeight.h),
              child: ListView.separated(
                controller: _scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(
                  12.w,
                  hasHeader ? 0 : 12.h,
                  12.w,
                  12.h,
                ),
                physics: const ClampingScrollPhysics(),
                itemCount: widget.items.length,
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
          ),
        ],
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
            color: isSelected
                ? AppTokens.brandPrimary.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected ? AppTokens.brandPrimary : AppTokens.border,
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
                    color: AppTokens.textPrimary,
                  ),
                ),
              ),
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? AppTokens.brandPrimary : Colors.transparent,
                  border: Border.all(
                    color:
                        isSelected ? AppTokens.brandPrimary : AppTokens.border,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 12.sp, color: AppTokens.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
