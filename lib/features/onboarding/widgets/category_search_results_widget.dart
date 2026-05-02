import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/features/onboarding/data/models/search_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategorySearchResultsWidget extends StatelessWidget {
  const CategorySearchResultsWidget({
    required this.searchResults,
    required this.isSearching,
    required this.onCategoryTap,
    required this.searchQuery,
    super.key,
  });

  final List<SearchResultModel> searchResults;
  final bool isSearching;
  final ValueChanged<SearchResultModel> onCategoryTap;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final hasResults = searchResults.isNotEmpty;

    if (!hasResults && !isSearching) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppTokens.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTokens.border,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: isSearching
            ? SizedBox(
                height: 50.h,
                child: Center(
                  child: SizedBox(
                    height: 18.w,
                    width: 18.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTokens.brandPrimary,
                    ),
                  ),
                ),
              )
            : ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 150.h,
                ),
                child: searchResults.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                        ),
                        child: Text(
                          'No categories found for "$searchQuery".',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTokens.textSecondary,
                          ),
                        ),
                      )
                    : MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: searchResults.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            thickness: .6,
                            color: AppTokens.border,
                          ),
                          itemBuilder: (context, index) {
                            final result = searchResults[index];

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => onCategoryTap(result),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 10.h,
                                  ),
                                  child: Text(
                                    result.displayName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.4.sp,
                                      height: 1.08,
                                      fontWeight: FontWeight.w500,
                                      color: AppTokens.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
