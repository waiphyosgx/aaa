import 'package:falcon_bootstrap/falcon_bootstrap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sgx_online_common/sgx_online_common_content.dart';
import 'package:sgx_online_common/sgx_online_common_models.dart';

import '../../../../../sgx_online_market_models.dart';
import '../../../../content/content.dart';
import '../../../../services/security_service.dart';
import '../../../../state/security_detail/security_detail_state.dart';
import '../../../../state/security_state_model.dart';
import '../../../../utils/security_tab_utils.dart';
import 'company_announcement/company_announcement_widget.dart';
import 'corporate_actions/corporate_actions.dart';
import 'corporate_information/corporate_information_widget.dart';
import 'corporate_information/term_sheet_listing_documents.dart';
import 'financial_statement/financial_statement.dart';
import 'internal_widgets/bottom_bar_widget.dart';
import 'company_info_and_news/company_general_info_widget.dart';
import 'gt_indexes/gt_indexes_widget.dart';
import 'price_charts/prices_chart.dart';
import 'internal_widgets/security_detail_tab.dart';
import 'internal_widgets/security_details_info_widget.dart';
import 'internal_widgets/security_details_header_widget.dart';
import 'market_update/market_update_widget.dart';
import 'warrant_agent_info/warrant_agent_info_widget.dart';

class SecurityDetailsPage extends ConsumerStatefulWidget {
  const SecurityDetailsPage({
    super.key,
    required this.content,
    required this.sharedContent,
  });

  final Content content;
  final SharedContent sharedContent;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SecurityListState();
}

class _SecurityListState extends ConsumerState<SecurityDetailsPage>
    with TickerProviderStateMixin {
  List<SecurityDataModel> securities = [];
  late SecurityStateModel selectedStock;
  String selectedStockCode = '';
  String selectedSecurityType = '';
  String _currentIndex = 'stock';

  final securityDetailProvider = SecurityDetailState(
    () => SecurityDetailNotifier(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        selectedStockCode = GoRouter.of(context)
            .routeInformationProvider
            .value
            .uri
            .pathSegments
            .last;
        selectedSecurityType = GoRouter.of(context)
            .routeInformationProvider
            .value
            .uri
            .pathSegments[GoRouter.of(context)
                .routeInformationProvider
                .value
                .uri
                .pathSegments
                .length -
            2];
        final SecurityService securityService = GetIt.I.get();
        final SecurityDataModel? itemData =
            await securityService.getSecurityByCategoryAndCode(
          selectedSecurityType,
          selectedStockCode,
        );
        if (itemData != null) {
          selectedStock = SecurityStateModel(
            data: itemData,
            change: Change.no,
          );
          ref
              .read(securityDetailProvider.notifier)
              .getStockDetailInfoByCode(selectedStock.data);
        }
      } catch (e) {
        if (kDebugMode) {
          print('error: $e');
        }
      }
    });
  }

  Widget _currentPage({
    required String currentIndex,
    required SecurityDetailIndustryModel? industryModel,
    required RicDataModel? ricDataModel,
    required String? ibmCode,
    required String? isinCode,
  }) {
    final details = widget.content.details;
    if (currentIndex == details.pricenchart ||
        currentIndex == details.overview) {
      return PriceAndChart(
        type: selectedStock.data.securityType?.code,
        content: widget.content,
        code: selectedStock.data.sgxCode ?? '',
        ricCode: ricDataModel?.primaryRIC,
        ibmCode: ibmCode,
        securityDataModel: selectedStock.data,
        industryModel: industryModel,
        sharedContent: widget.sharedContent,
      );
    } else if (currentIndex == details.companyinfonews) {
      return CompanyGeneralInfo(
        content: widget.content,
        industryModel: industryModel,
        ibmCode: ibmCode,
        code: ricDataModel?.primaryRIC,
      );
    } else if (currentIndex == details.comapnyannouncement ||
        currentIndex == details.issuerAnnouncement) {
      return CompanyAnnouncementWidget(
        code: selectedStock.data.sgxCode ?? '',
        content: widget.content,
      );
    } else if (currentIndex == details.coporateactions) {
      return CorporateActionWidget(
        content: widget.content,
        ibmCode: ibmCode,
      );
    } else if (currentIndex == details.marketUpdate) {
      return MarketUpdateWidget(
        stockCode: selectedStock.data.sgxCode ?? '',
        content: widget.content,
      );
    } else if (currentIndex == details.research) {
      return MarketUpdateWidget(
        stockCode: selectedStock.data.sgxCode ?? '',
        content: widget.content,
        title: widget.content.details.research,
      );
    } else if (currentIndex == details.productInformation) {
      if (selectedStock.data.securityType ==
          SecurityProduct.listedCertificates) {
        return TermSheetDocumentsWidget(
          content: widget.content,
          isinCode: isinCode ?? '',
        );
      }
      return CorporateInformationWidget(
        ibmCode: ibmCode,
        stockCode: selectedStock.data.sgxCode,
        type: selectedStock.data.securityType?.code,
        content: widget.content,
      );
    } else if (currentIndex == details.gti) {
      return GtIndexesWidget(
        securityCode: selectedStock.data.sgxCode ?? '',
        content: widget.content,
      );
    } else if (currentIndex == details.warrantAgent) {
      return WarrantAgentInfoWidget(
        ibmCode: ibmCode ?? '',
      );
    } else if (currentIndex == details.financialstatements) {
      return FinancialStatement(
        code: ricDataModel?.primaryRIC ?? '',
        content: widget.content,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final securityDetailState = ref.watch(securityDetailProvider);
    final detail = widget.content.details;
    bool isIFrameWebView = (_currentIndex == detail.warrantAgent) ||
        (_currentIndex == detail.productInformation &&
            selectedStock.data.securityType !=
                SecurityProduct.listedCertificates);
    return Scaffold(
      body: switch (securityDetailState) {
        SecurityDetailLoadingModel() => const SpinnerWidget(),
        SecurityDetailSuccessModel(
          infoModel: SecurityDetailIndustryModel? industryModel,
          ricDataModel: RicDataModel? ricModel,
          ibmCode: String? ibmCode,
          isninCode: String? isinCode,
          sgxCode: String? sgxCode,
        ) =>
          SafeArea(
            child: Column(
              children: [
                StockDetailHeaderWidget(
                  selectedStock: selectedStock.data,
                  ricDataModel: ricModel,
                  content: widget.content,
                ),
                Expanded(
                  child: NestedScrollView(
                    headerSliverBuilder: (context, value) {
                      return [
                        SliverToBoxAdapter(
                          child: SecurityDetailInfoWidget(
                            content: widget.content,
                            sharedContent: widget.sharedContent,
                            currentSecurity: selectedStock,
                            industryModel: industryModel,
                          ),
                        ),
                      ];
                    },
                    body: Column(
                      children: [
                        SecurityDetailTab(
                          tabs: showTabData(
                              content: widget.content,
                              securityProduct:
                                  selectedStock.data.securityType!),
                          firstIndex: (String defaultIndex) {
                            setState(() {
                              _currentIndex = defaultIndex;
                            });
                          },
                          content: widget.content,
                          securityProduct: selectedStock.data.securityType,
                          onClick: (String currentIndex) {
                            setState(() {
                              _currentIndex = currentIndex.trim();
                            });
                          },
                        ),
                        //for iframe view , we can only allow to scroll iframe
                        if (sgxCode.isNotEmpty)
                          isIFrameWebView
                              ? Expanded(
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: _currentPage(
                                          currentIndex: _currentIndex,
                                          industryModel: industryModel,
                                          ricDataModel: ricModel,
                                          ibmCode: ibmCode,
                                          isinCode: isinCode,
                                        ),
                                      ),
                                      SecurityDetailBottomBarWidget(
                                        content: widget.content,
                                      )
                                    ],
                                  ),
                                )
                              : Expanded(
                                  child: IndexedStack(
                                    index: showTabData(
                                            content: widget.content,
                                            securityProduct: selectedStock
                                                .data.securityType!)
                                        .indexOf(_currentIndex),
                                    children: [
                                      for (int i = 0;
                                          i <
                                              showTabData(
                                                      content: widget.content,
                                                      securityProduct:
                                                          selectedStock.data
                                                              .securityType!)
                                                  .length;
                                          i++)
                                        SingleChildScrollView(
                                          controller: ScrollController(),
                                          child: Column(
                                            children: [
                                              _currentPage(
                                                currentIndex: showTabData(
                                                    content: widget.content,
                                                    securityProduct:
                                                        selectedStock.data
                                                            .securityType!)[i],
                                                industryModel: industryModel,
                                                ricDataModel: ricModel,
                                                ibmCode: ibmCode,
                                                isinCode: isinCode,
                                              ),
                                              SecurityDetailBottomBarWidget(
                                                content: widget.content,
                                              )
                                            ],
                                          ),
                                        )
                                    ], //m
                                  ),
                                ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        SecurityDetailFailedModel() => const Center(
            child: Text('error'),
          ),
      },
    );
  }
}
