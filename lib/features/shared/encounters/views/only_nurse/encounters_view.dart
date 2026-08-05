import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/encounters/viewmodels/encounter_viewmodel.dart';
import 'package:marbella/features/shared/encounters/widgets/only_nurse/encounter_card.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class EncountersView extends StatefulWidget {
  const EncountersView({super.key});
  @override
  State<EncountersView> createState() => _EncountersViewState();
}

class _EncountersViewState extends State<EncountersView> {
  late String locale;
  String? token;
  EncounterParams? params;
  final ScrollController scrollController = ScrollController();

  final String? status = null;
  @override
  void initState() {
    super.initState();
    _initFetch();
    scrollController.addListener(_onScroll);
  }

  void _initFetch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      locale = Localizations.localeOf(context).languageCode;
      token =
          context.read<AuthViewmodel>().response?.data?.token ??
          context.read<AuthViewmodel>().userFromCache?.data?.token;
      params = EncounterParams(search: null, status: null, patientId: null);
      context.read<EncounterViewmodel>().refreshToFetchDataList(
        locale,
        token,
        params!,
      );
    });
  }

  Future<void> _fetchData() async {
    params = EncounterParams(search: null, status: null, patientId: null);
    locale = Localizations.localeOf(context).languageCode;
    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    await context.read<EncounterViewmodel>().refreshToFetchDataList(
      locale,
      token,
      params!,
    );
  }

  void _onScroll() {
    if (params == null) return;
    final provider = context.read<EncounterViewmodel>();
    final currentStatus = status;
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !provider.getIsFetching(status) &&
        provider.getHasMore(status)) {
      final nextPage = provider.getCurrentPage(currentStatus);
      provider.getEncounters(locale, token, params!, nextPage);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final encounterProvider = context.watch<EncounterViewmodel>();
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(S().my_encounters)),
      body: LiquidPullToRefresh(
        onRefresh: _fetchData,
        color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
        backgroundColor: colorScheme.surface,
        height: 50,
        child: StateWidget(
          isLoading: encounterProvider.isLoading,
          error: encounterProvider.errorMessage,
          isEmpty:
              !encounterProvider.isLoading &&
              encounterProvider.allEncounters.isEmpty &&
              encounterProvider.errorMessage == null,
          onRetry: _fetchData,
          noDataMsg: S.of(context).no_data,
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount:
                encounterProvider.allEncounters.length +
                (encounterProvider.getIsFetching(status) ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              if (index < encounterProvider.allEncounters.length) {
                return EncounterCard(
                  encounter: encounterProvider.allEncounters[index],
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
    );
  }
}
