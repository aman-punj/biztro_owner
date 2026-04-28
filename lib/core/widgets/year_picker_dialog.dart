import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YearPickerDialog extends StatefulWidget {
  const YearPickerDialog({
    required this.initialYear,
    required this.firstYear,
    required this.lastYear,
    super.key,
  });

  final int initialYear;
  final int firstYear;
  final int lastYear;

  @override
  State<YearPickerDialog> createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<YearPickerDialog> {
  late int selectedYear;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
    
    // Estimate position: each item is roughly 50.h
    final int index = selectedYear - widget.firstYear;
    _scrollController = ScrollController(
      initialScrollOffset: (index * 50.h) - 100.h, // Center roughly
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Year',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTokens.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 250.h,
              width: double.maxFinite,
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                ),
                itemCount: widget.lastYear - widget.firstYear + 1,
                itemBuilder: (context, index) {
                  final year = widget.firstYear + index;
                  final isSelected = year == selectedYear;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedYear = year;
                      });
                    },
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTokens.brandPrimary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected
                              ? AppTokens.brandPrimary
                              : AppTokens.border,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        year.toString(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? AppTokens.white
                              : AppTokens.textPrimary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(color: AppTokens.textSecondary),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, selectedYear),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTokens.brandPrimary,
                    foregroundColor: AppTokens.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: const Text('SELECT'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<int?> showAppYearPicker({
  required BuildContext context,
  required int initialYear,
  int? firstYear,
  int? lastYear,
}) async {
  return showDialog<int>(
    context: context,
    builder: (context) => YearPickerDialog(
      initialYear: initialYear,
      firstYear: firstYear ?? 1900,
      lastYear: lastYear ?? DateTime.now().year + 1,
    ),
  );
}
