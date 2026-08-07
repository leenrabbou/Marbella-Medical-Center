import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/widgets/search_textfield_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/only_doctor/patients/viewmodels/patients_viewmodel.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/only_doctor/patients/widgets/patient_card.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class PatientsView extends StatefulWidget {
  const PatientsView({super.key, required this.isCurrent});
  final bool isCurrent;
  @override
  State<PatientsView> createState() => _PatientsViewState();
}

class _PatientsViewState extends State<PatientsView> {
  final ScrollController scrollController = ScrollController();
  late TextEditingController searchController;
  late String locale;
  String? token;
  PatientsParams? params;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _fetchData();
    scrollController.addListener(_onScroll);
  }

  Future<void> _fetchData() async {
    params = PatientsParams(search: null);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      locale = Localizations.localeOf(context).languageCode;
      token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      await context.read<PatientsViewmodel>().refreshToFetchDataList(
        locale,
        token,
        params!,
      );
    });
  }

  void _onSearch(String searchText) {
    params?.setSearch(searchText.trim().isEmpty ? null : searchText.trim());
    context.read<PatientsViewmodel>().refreshToFetchDataList(
      locale,
      token,
      params!,
    );
    setState(() {});
  }

  void _onCancelSearch() {
    searchController.clear();
    _onSearch('');
  }

  void _onScroll() {
    final provider = context.read<PatientsViewmodel>();
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !provider.isFetching &&
        provider.hasMore) {
      final nextPage = provider.currentPage;
      provider.getPatients(locale, token, params!, nextPage);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientsProvider = context.watch<PatientsViewmodel>();
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final isSearching = params?.search != null && params!.search!.isNotEmpty;
    return Scaffold(
      appBar: widget.isCurrent
          ? AppBar(title: Text(S().current_patients), leading: null)
          : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchTextFieldWidget(
              searchController: searchController,
              onSubmitted: (text) => _onSearch(text),
            ),
            if (isSearching)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorScheme.primary.withAlpha((0.1 * 255).toInt()),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${S.of(context).results_for} "${params!.search}"',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: colorScheme.primary),
                            maxLines: null,
                          ),
                        ),
                        GestureDetector(
                          onTap: _onCancelSearch,
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10.h),
            Expanded(
              child: LiquidPullToRefresh(
                onRefresh: _fetchData,
                color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
                backgroundColor: colorScheme.surface,
                height: 50,
                child: StateWidget(
                  isLoading: patientsProvider.isLoading,
                  error: patientsProvider.errorMessage,
                  isEmpty:
                      !patientsProvider.isLoading &&
                      patientsProvider.allPatients.isEmpty &&
                      patientsProvider.errorMessage == null,
                  onRetry: _fetchData,
                  noDataMsg: isSearching
                      ? S.of(context).no_search_results
                      : (widget.isCurrent
                            ? S().no_active_patients_subtitle
                            : S().no_patients_subtitle),
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemCount:
                        patientsProvider.allPatients.length +
                        (patientsProvider.isFetching ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index < patientsProvider.allPatients.length) {
                        return PatientCard(
                          patient: patientsProvider.allPatients[index],
                        );
                      } else {
                        return SpinKitThreeBounce(
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
