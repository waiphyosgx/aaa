import 'package:falcon_utils/string_utils.dart';
import 'package:falcon_ux_theme/falcon_ux_theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sgx_online_common/sgx_online_common_models.dart';
import 'package:sgx_online_common/sgx_online_common_utils.dart';
import 'package:sgx_online_common/sgx_online_common_widgets.dart';
import 'package:sgx_online_market/src/models/entities/security_details/price_chart/cash_flow/cash_flow.dart';
import 'package:sgx_online_market/src/models/entities/security_details/price_chart/income_statement/income_statement.dart';
import 'package:sgx_online_market/src/state/security_detail/price_chart/overview_price_state_model.dart';

import '../../../../content/content.dart';
import '../../../../models/entities/security_details/price_chart/balance_sheet/financial_statement_report_model.dart';
import '../../../../models/entities/security_details/price_chart/overview/overview_historic_price_model.dart';
import '../../../../models/entities/security_details/price_chart/vwap/vwap_model.dart';
import '../../../../state/security_detail/price_chart/overview_price_state.dart';
import '../../../../state/security_detail/security_detail_model.dart';

class PriceOverViewWidget extends ConsumerStatefulWidget {
  const PriceOverViewWidget({
    super.key,
    required this.code,
    required this.type,
    required this.content,
    required this.ricCode,
    required this.securityDataModel,
    required this.securityDetailIndustryModel,
  });
  final String code;
  final SecurityDataModel securityDataModel;
  final SecurityDetailIndustryModel? securityDetailIndustryModel;
  final String? type;
  final Content content;
  final String? ricCode;

  @override
  ConsumerState<PriceOverViewWidget> createState() => _PriceOverViewWidgetState();
}

class _PriceOverViewWidgetState extends ConsumerState<PriceOverViewWidget> {
  int _selectedIndex = 0;
  final overviewPriceStateProvider = OverViewStateProvider(() => OverviewPriceNotifier());
  bool _showAll = false;
  @override
  void initState() {
    super.initState();
    _getOverviewPrice();
  }

  void _getOverviewPrice() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref.read(overviewPriceStateProvider.notifier).getOverviewHistoric(
              code: widget.code,
              type: widget.type,
              ricCode: widget.ricCode,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content.details;
    final overViewTab = [
      content.overview,
      content.valuation,
      content.finicial,
      content.dividends,
      content.ownership,
    ];
    final overviewPriceState = ref.watch(overviewPriceStateProvider);
    return Column(
      children: [
        _tab(
          onClick: (position) {
            setState(() {
              _selectedIndex = position;
            });
          },
          overViewTab: overViewTab,
        ),
        switch (overviewPriceState) {
          OverviewPriceLoading() => const SizedBox(
              height: 300,
              child: SpinnerWidget(),
            ),
          OverviewPriceSuccess(
            overviewHistoricPriceModel: OverviewHistoricPriceModel? overviewPriceModel,
            stockRatiosReportModel: StockRatiosReportModel? ratioReportModel,
            vWapModel: VWapModel? vwapModel,
            financialStatementReportModel: FinancialStatementReportModel? financialReport,
            cashFlowModel: CashFlowModel? cashFlowModel,
            incomeStatementModel: IncomeStatementModel? incomeStatementModel,
          ) =>
            _content(
              overViewTab[_selectedIndex],
              overviewPriceModel,
              ratioReportModel,
              vwapModel,
              financialReport,
              cashFlowModel,
              incomeStatementModel,
            ),
          OverviewPriceFailed(errorMessage: String errorMessage) => Center(
              child: Text(errorMessage),
            ),
        }
      ],
    );
  }

  Widget _content(
    String title,
    OverviewHistoricPriceModel? model,
    StockRatiosReportModel? ratiosReportModel,
    VWapModel? vWapModel,
    FinancialStatementReportModel? financialStatementReport,
    CashFlowModel? cashFlowModel,
    IncomeStatementModel? incomeStatementModel,
  ) {
    final falconVars = FalconUxVariables(context);
    late List<_PriceOverviewModel> content;
    content = switch (_selectedIndex) {
      0 => _generateOverview(
          model: model,
          ratiosReportModel: ratiosReportModel,
          vWapModel: vWapModel,
        ),
      1 => _generateValuation(
          ratiosReportModel: ratiosReportModel,
        ),
      2 => _generateFinancials(
          ratiosReportModel: ratiosReportModel,
          financialStatementReportModel: financialStatementReport,
          cashFlowModel: cashFlowModel,
          incomeStatementModel: incomeStatementModel,
        ),
      _ => [_PriceOverviewModel(key: "TODO", value: "TO DO")]
    };

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: falconVars.background,
          padding: const EdgeInsets.all(16.0),
          height: 48,
          child: Text(
            title,
            style: falconVars.headlineSmall.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _contentBody(content)
      ],
    );
  }

  Widget _contentBody(List<_PriceOverviewModel> labelValues) {
    final needViewMore = labelValues.length >= 12;
    final showAll = needViewMore && _showAll;
    int displayLimit = showAll ? labelValues.length : 12;
    final falconSurface = Theme.of(context).extension<FalconUxColorsSurface>()!;
    final falconCustom = Theme.of(context).extension<FalconUxColorsCustom>()!;
    final falconVars = FalconUxVariables(context);
    return Column(
      children: [
        for (var label in labelValues.take(displayLimit))
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: falconSurface.surface,
              border: Border(
                bottom: BorderSide(
                  color: falconCustom.onSurfaceLower,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label.key,
                  style: falconVars.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.22,
                    color: falconSurface.onSurface,
                  ),
                ),
                Text(
                  label.value,
                  style: falconVars.bodyMedium.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.22,
                  ),
                ),
              ],
            ),
          ),
        if (needViewMore)
          SizedBox(
            height: 47,
            child: TextButton(
              style: falconVars.mediumBtn.copyWith(
                textStyle: const MaterialStatePropertyAll(
                  TextStyle(fontSize: 14.22),
                ),
              ),
              onPressed: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Text(_showAll ? "View Less" : "View More"),
            ),
          )
      ],
    );
  }

  Widget _tab({
    required Function(int) onClick,
    required List<String> overViewTab,
  }) {
    final falconVars = FalconUxVariables(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: overViewTab.map(
            (e) {
              int currentIndex = overViewTab.indexOf(e);
              bool isSelected = currentIndex == _selectedIndex;
              return isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilledButton(
                        style: falconVars.mediumBtn.copyWith(
                            textStyle: const MaterialStatePropertyAll(
                          TextStyle(fontSize: 14.22),
                        )),
                        onPressed: () {
                          onClick(currentIndex);
                        },
                        child: Text(e),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: OutlinedButton(
                        style: falconVars.mediumBtn.copyWith(
                            textStyle: const MaterialStatePropertyAll(
                          TextStyle(fontSize: 14.22),
                        )),
                        onPressed: () {
                          onClick(currentIndex);
                        },
                        child: Text(e),
                      ),
                    );
            },
          ).toList(),
        ),
      ),
    );
  }

  // Define the model class
  class _PriceOverviewModel {
    final String key;
    final String value;

    _PriceOverviewModel({required this.key, required this.value});
  }

  // Generate overview data
  List<_PriceOverviewModel> _generateOverview({
    required OverviewHistoricPriceModel? model,
    required StockRatiosReportModel? ratiosReportModel,
    required VWapModel? vWapModel,
  }) {
    final detailContent = widget.content.details;
    final historicPriceList = model?.data?.historic;
    final historicPrice = historicPriceList?.isEmpty == true ? null : historicPriceList?.last;
    final currency = historicPrice?.cur ?? '';
    DateTime? dateTime = DateFormatter.parseFormatYyyyMMddhhmmss(historicPrice?.tradingTime ?? '');
    final previousOpenPrice = historicPrice?.o?.toStringAsFixed(3) ?? '-';
    final previousHigh = historicPrice?.h?.toStringAsFixed(3);
    final previousLow = historicPrice?.l?.toStringAsFixed(3);
    final previousHighOrLow = (previousHigh == null || previousLow == null) ? "-" : "$currency $previousHigh - $previousLow";
    final previousDayVolume = historicPrice?.vl?.toString();
    String previousDayVolumeFormatted = "-";
    if (previousDayVolume != null && num.tryParse(previousDayVolume) != null) {
      final previousDayVl = num.parse(previousDayVolume);
      previousDayVolumeFormatted = previousDayVl >= 1000 ? '${PriceUtil.formatThousandsSeparator(previousDayVl.round(), decimal: 2)}K' : previousDayVl.toString();
    }
    final previousClosed = historicPrice?.lt?.toStringAsFixed(3) ?? '-';
    final formattedDate = dateTime != null ? DateFormat('dd MMM yyyy').format(dateTime) : '-';
    final fiftyTwoWeekHigh = ratiosReportModel?.high52Week;
    final fiftyTwoWeekLow = ratiosReportModel?.low52Week;
    final fiftyTwoWeekHighLow = (fiftyTwoWeekHigh == null || fiftyTwoWeekLow == null) ? "-" : "${fiftyTwoWeekHigh.toStringAsFixed(3)}-${fiftyTwoWeekLow.toStringAsFixed(3)}";
    final beta5year = ratiosReportModel?.beta5Year?.toStringAsFixed(2) ?? "-";
    final sharedOutstanding = ratiosReportModel?.sharesOutstanding;
    final sharedOutstandingFormatted = (sharedOutstanding == null) ? "_" : PriceUtil.formatMillionOrBillion(sharedOutstanding);
    String? average3MonthVl = ratiosReportModel?.average3MonthVol?.toStringAsFixed(2);
    average3MonthVl = (average3MonthVl == null) ? "_" : "${average3MonthVl}M";
    final normalizedDiluted = ratiosReportModel?.normalDilutedEps?.toStringAsFixed(2) ?? "_";
    String? sector = widget.content.sectors.toJson()[widget.securityDataModel.sector?.toLowerCase() ?? ''];
    sector = (sector == null || sector.isEmpty) ? "-" : sector;
    final totalMarketCap = ratiosReportModel?.totalMarketCap.toString();
    String totalMarketCapFormatted = "-";
    if (totalMarketCap != null && num.tryParse(totalMarketCap) != null) {
      num marketCap = num.parse(totalMarketCap);
      totalMarketCapFormatted = marketCap >= 1000 ? '${PriceUtil.formatThousandsSeparator(marketCap, decimal: 2)}M' : marketCap.toString();
    }
    List<String> remarkListI = getRemarksArray(widget.securityDataModel.remarksI ?? '-');
    List<String> remarkListR = getRemarksArray(widget.securityDataModel.remarksR ?? '-');
    String activities = [...remarkListI, ...remarkListR].join('/');
    final listingType = widget.securityDataModel.listing?.toLowerCase();
    final listingMap = widget.content.listings.toJson();
    final listingFormatted = (listingType == null || listingMap[listingType] == null) ? "-" : listingMap[listingType];
    String market = widget.securityDataModel.market ?? 'defaultvalue';
    Map<String, dynamic> marketCodes = widget.content.marketCodes.toJson();
    market = market.toLowerCase().replaceAll('_', '');
    market = marketCodes[market];
    final marketFormatted = market;
    final clo = widget.securityDataModel.clo;
    final cloFormatted = clo?.isNotEmpty == true ? clo : "-";
    final boardLot = widget.securityDataModel.boardLot ?? '-';
    final sip = widget.securityDataModel.sip ?? "-";
    final spac = sip.toUpperCase() == "SP" ? "Yes" : "No";
    final tt = sip.toUpperCase() == "TT" ? "Yes" : "No";
    final issuer = widget.securityDataModel.issuerName ?? widget.securityDataModel.remarksI ?? "-";
    final homeExchange = widget.securityDataModel.homeExchange ?? '-';
    final expiryDate = widget.securityDataModel.expiryDate ?? '-';
    final conversionRatio = widget.securityDataModel.conversionRatio ?? '-';
    String vWap = "-";
    String adjustedVwap = "-";
    final vWapData = vWapModel?.data?.prices;
    if (vWapData?.isNotEmpty == true) {
      final price = vWapData![0];
      String currency = price.vwCurrency ?? "";
      vWap = "$currency ${price.vwap}";
      adjustedVwap = "$currency ${price.adjustedVwap}";
    }

    return [
      _PriceOverviewModel(key: detailContent.previousOpenPrice, value: "$currency $previousOpenPrice"),
      _PriceOverviewModel(key: detailContent.previousDayhl, value: previousHighOrLow),
      _PriceOverviewModel(key: detailContent.previousDayvl, value: previousDayVolumeFormatted),
      _PriceOverviewModel(key: detailContent.previousClose, value: "$currency $previousClosed"),
      _PriceOverviewModel(key: detailContent.previousCloseDay, value: formattedDate),
      _PriceOverviewModel(key: detailContent.fiftyTwoWeekHighLow, value: fiftyTwoWeekHighLow),
      _PriceOverviewModel(key: detailContent.fiveyearBeta, value: beta5year),
      _PriceOverviewModel(key: detailContent.shareOutstanding, value: sharedOutstandingFormatted),
      _PriceOverviewModel(key: detailContent.average3MonthVl, value: average3MonthVl),
      _PriceOverviewModel(key: detailContent.normalisedDilEps, value: normalizedDiluted),
      _PriceOverviewModel(key: detailContent.sector, value: sector),
      _PriceOverviewModel(key: detailContent.todayMarketCap, value: totalMarketCapFormatted),
      _PriceOverviewModel(key: detailContent.activities, value: activities),
      _PriceOverviewModel(key: detailContent.listingType, value: listingFormatted),
      _PriceOverviewModel(key: detailContent.market, value: marketFormatted),
      _PriceOverviewModel(key: detailContent.continousListingObligation, value: cloFormatted),
      _PriceOverviewModel(key: detailContent.boardLot, value: boardLot),
      _PriceOverviewModel(key: detailContent.sip, value: sip),
      _PriceOverviewModel(key: detailContent.spac, value: spac),
      _PriceOverviewModel(key: detailContent.tt, value: tt),
      _PriceOverviewModel(key: detailContent.issuer, value: issuer),
      _PriceOverviewModel(key: detailContent.dualclassShare, value: "_"),
      _PriceOverviewModel(key: detailContent.currency, value: currency),
      _PriceOverviewModel(key: detailContent.homeExchange, value: homeExchange),
      _PriceOverviewModel(key: detailContent.expireDate, value: expiryDate),
      _PriceOverviewModel(key: detailContent.exerciseLevel, value: "-"),
      _PriceOverviewModel(key: detailContent.conversionRation, value: conversionRatio),
      _PriceOverviewModel(key: detailContent.classificationofHome, value: "_"),
      _PriceOverviewModel(key: detailContent.indicate6month, value: vWap),
      _PriceOverviewModel(key: detailContent.sixMonthVwrap, value: adjustedVwap),
    ];
  }

  // Generate valuation data
  List<_PriceOverviewModel> _generateValuation({
    required StockRatiosReportModel? ratiosReportModel,
  }) {
    final detailContent = widget.content.details;
    final priceBookVal = ratiosReportModel?.priceBookVal?.toStringAsFixed(3) ?? "-";
    final enterpriseVal = widget.securityDetailIndustryModel?.enterPriseValue;
    final enterPriseValFormatted = enterpriseVal == null ? "-" : "${PriceUtil.formatThousandsSeparator(enterpriseVal, decimal: 2)}M";
    final priceSale = ratiosReportModel?.priceSales?.toStringAsFixed(3) ?? "-";
    final priceCF = ratiosReportModel?.priceCf?.toStringAsFixed(3) ?? "-";
    final dividentYield = ratiosReportModel?.yield?.toStringAsFixed(2) ?? "-";
    final peRatio = ratiosReportModel?.peRatio?.toStringAsFixed(2) ?? "-";
    final dividendYield5year = ratiosReportModel?.yield5Year?.toStringAsFixed(3) ?? "-";
    final netDebt = ratiosReportModel?.netDebt?.toStringAsFixed(2) ?? "-";

    return [
      _PriceOverviewModel(key: detailContent.priceBookValue, value: priceBookVal),
      _PriceOverviewModel(key: detailContent.enterpriseValue, value: enterPriseValFormatted),
      _PriceOverviewModel(key: detailContent.priceSale, value: priceSale),
      _PriceOverviewModel(key: detailContent.priceCF, value: priceCF),
      _PriceOverviewModel(key: detailContent.dividendYield, value: dividentYield),
      _PriceOverviewModel(key: detailContent.pERatio, value: peRatio),
      _PriceOverviewModel(key: detailContent.dividendYield5yearAvg, value: dividendYield5year),
      _PriceOverviewModel(key: detailContent.netDebt, value: netDebt),
    ];
  }

  // Generate financials data
  List<_PriceOverviewModel> _generateFinancials({
    required StockRatiosReportModel? ratiosReportModel,
    required FinancialStatementReportModel? financialStatementReportModel,
    required CashFlowModel? cashFlowModel,
    final IncomeStatementModel? incomeStatementModel,
  }) {
    final securityIndustryModel = widget.securityDetailIndustryModel;
    final detailContent = widget.content.details;
    final financialStatementList = financialStatementReportModel?.data;
    final financialStatement = financialStatementList?.isNotEmpty == true ? financialStatementList![0] : null;
    final totalAssets = financialStatement?.totalAssets;
    final totalAssetsFormatted = (totalAssets == null || num.tryParse(totalAssets) == null) ? "-" : "${PriceUtil.formatThousandsSeparator(num.parse(totalAssets), decimal: 2)}M";
    final totalDebt = financialStatement?.totalDebt;
    final totalDebtFormatted = (totalDebt == null || num.tryParse(totalDebt) == null) ? "-" : "${PriceUtil.formatThousandsSeparator(num.parse(totalDebt), decimal: 2)}M";
    final cashShortTerm = financialStatement?.cashAndShortTermInvestments ?? '-';
    final longTermDebtEquity = ratiosReportModel?.longTermDebt?.toStringAsFixed(3) ?? "-";
    final returnOnEquity = securityIndustryModel?.roe?.toStringAsFixed(2) ?? "-";
    final returnOnAssets = ratiosReportModel?.roa?.toStringAsFixed(3) ?? "-";
    final assetTurnOver = ratiosReportModel?.assetTurnover?.toStringAsFixed(3) ?? "-";
    List<CashFlow>? cashFlowList = cashFlowModel?.data;
    CashFlow? cashFlow = (cashFlowList != null && cashFlowList.isNotEmpty == true) ? cashFlowList.first : null;
    final capEx = cashFlow?.capitalExpenditure;
    final capExFormatted = (capEx == null || num.tryParse(capEx) == null) ? "-" : "${num.parse(capEx).toStringAsFixed(2)}M";
    final currentRatio = ratiosReportModel?.currentRatio?.toStringAsFixed(3) ?? "-";
    final quickRatio = ratiosReportModel?.quickRatio?.toStringAsFixed(3) ?? "-";
    final totalRevenue = ratiosReportModel?.totalRevenue;
    final totalRevenueFormatted = totalRevenue == null ? "-" : "${PriceUtil.formatThousandsSeparator(totalRevenue, decimal: 2)}M";
    final revenueEmployee = ratiosReportModel?.revEmployee;
    final revenueEmployeeFormatted = revenueEmployee == null ? "-" : "${PriceUtil.formatThousandsSeparator(revenueEmployee, decimal: 2)}";
    final ebitda = ratiosReportModel?.ebitda;
    final ebitdaFormatted = ebitda == null ? "-" : "${PriceUtil.formatThousandsSeparator(ebitda, decimal: 2)}M";
    final netInterestCoverage = ratiosReportModel?.netInterestCoverage?.toStringAsFixed(3) ?? "-";
    final icomeStatementList = incomeStatementModel?.data;
    final incomeStatement = (icomeStatementList != null && icomeStatementList.isNotEmpty) ? icomeStatementList.first : null;
    final operatingIncome = incomeStatement?.operatingIncome != null ? num.parse(incomeStatement!.operatingIncome!) : null;
    final operatingIncomeFormatted = operatingIncome != null ? '${PriceUtil.formatThousandsSeparator(operatingIncome, decimal: 2)}M' : "_";
    final netIncome = ratiosReportModel?.netIncome;
    final netIncomeFormatted = netIncome == null ? "-" : "${PriceUtil.formatThousandsSeparator(netIncome, decimal: 2)}M";
    final operatingMargin = ratiosReportModel?.operatingMargin?.toStringAsFixed(3) ?? "-";
    final netProfitMargin = ratiosReportModel?.netProfitMargin?.toStringAsFixed(3) ?? "-";
    final revenueShared = ratiosReportModel?.revShare5Year?.toStringAsFixed(3) ?? "-";
    final eps5yrGrowth = ratiosReportModel?.eps5Year?.toStringAsFixed(3) ?? "-";

    return [
      _PriceOverviewModel(key: detailContent.totalAssets, value: totalAssetsFormatted),
      _PriceOverviewModel(key: detailContent.totalDebt, value: totalDebtFormatted),
      _PriceOverviewModel(key: detailContent.cashShortTermInvestments, value: cashShortTerm),
      _PriceOverviewModel(key: detailContent.longTermDebtEquity, value: longTermDebtEquity),
      _PriceOverviewModel(key: detailContent.returnOnEquity, value: returnOnEquity),
      _PriceOverviewModel(key: detailContent.returnOnAssets, value: returnOnAssets),
      _PriceOverviewModel(key: detailContent.assetsTurnover, value: assetTurnOver),
      _PriceOverviewModel(key: detailContent.capEx, value: capExFormatted),
      _PriceOverviewModel(key: detailContent.currentRatio, value: currentRatio),
      _PriceOverviewModel(key: detailContent.quickRatio, value: quickRatio),
      _PriceOverviewModel(key: detailContent.totalRevenue, value: totalRevenueFormatted),
      _PriceOverviewModel(key: detailContent.revenueEmployee, value: revenueEmployeeFormatted),
      _PriceOverviewModel(key: detailContent.ebitda, value: ebitdaFormatted),
      _PriceOverviewModel(key: detailContent.netInterestCoverage, value: netInterestCoverage),
      _PriceOverviewModel(key: detailContent.operatingIncome, value: operatingIncomeFormatted),
      _PriceOverviewModel(key: detailContent.netIncome, value: netIncomeFormatted),
      _PriceOverviewModel(key: detailContent.operatingMargin, value: operatingMargin),
      _PriceOverviewModel(key: detailContent.netProfitMargin, value: netProfitMargin),
      _PriceOverviewModel(key: detailContent.revenueSharedGrowth, value: revenueShared),
      _PriceOverviewModel(key: detailContent.eps5yrGrowth, value: eps5yrGrowth),
    ];
  }

  // Activities
  List<String> getRemarksArray(String remarkCodes) {
    List<String> remarksArr = [];
    String formattedCode = remarkCodes;
    Map<String, dynamic> securityContent = widget.content.securityRemarks.toJson();
    if (remarkCodes.contains(';')) {
      formattedCode.replaceAll(';', 'Sep');
    }
    String remark = securityContent[formattedCode.toLowerCase()] ?? '';
    // First check to see if the combination of codes is available before splitting them into individual codes
    if (!isBlank(remark) && remark.isNotEmpty) {
      remarksArr.add(remark);
    } else {
      remarkCodes.split(';').forEach((splitCode) {
        if (!isBlank(splitCode)) {
          remark = securityContent[splitCode.toLowerCase()] ?? '';
          if (isNotBlank(remark)) {
            remarksArr.add(remark);
          }
        }
      });
    }

    return remarksArr;
  }
}
