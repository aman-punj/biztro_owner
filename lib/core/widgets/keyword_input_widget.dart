import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeywordInputRow extends StatelessWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final VoidCallback onAction;
  final bool isReadOnly;
  final String hint;
  final IconData actionIcon;
  final Color? actionBackgroundColor;
  final Color? actionIconColor;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const KeywordInputRow({
    super.key,
    this.initialValue,
    this.controller,
    required this.onAction,
    this.isReadOnly = true,
    this.hint = "Enter keyword...",
    this.actionIcon = Icons.delete_outline,
    this.actionBackgroundColor,
    this.actionIconColor,
    this.onSubmitted,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 44.h),
              child: TextFormField(
                controller: controller,
                initialValue: controller == null ? initialValue : null,
                readOnly: isReadOnly,
                onFieldSubmitted: onSubmitted,
                onChanged: onChanged,
                minLines: 1,
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
                maxLines: maxLines,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textFieldBackground,
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: onAction,
            child: Container(
              width: 44.h,
              height: 44.h,
              decoration: BoxDecoration(
                color: actionBackgroundColor ??
                    AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                actionIcon,
                color: actionIconColor ?? AppColors.error,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditableKeywordRow extends StatefulWidget {
  const EditableKeywordRow({
    super.key,
    required this.value,
    required this.onDelete,
    required this.onSave,
  });

  final String value;
  final VoidCallback onDelete;
  final ValueChanged<String> onSave;

  @override
  State<EditableKeywordRow> createState() => _EditableKeywordRowState();
}

class _EditableKeywordRowState extends State<EditableKeywordRow> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant EditableKeywordRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_controller.text == widget.value) {
      return;
    }
    widget.onSave(_controller.text);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              onFieldSubmitted: (_) => _save(),
              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
                _save();
              },
              minLines: 1,
              maxLines: 3,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textFieldBackground,
                hintText: 'Enter keyword...',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: widget.onDelete,
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: AppImage(
                  path: AppAssets.deleteRedIcon,
                  width: 20.w,
                  height: 20.w,
                  color: AppColors.error,
                  showLoading: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
