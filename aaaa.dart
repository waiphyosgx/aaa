import 'package:sgx_online_common/sgx_online_common_models.dart';
import 'package:sgx_online_common/sgx_online_common_utils.dart';
import 'package:share/share.dart';

class ShareUtil {
  static void shareText(String text) {
    Share.share(text);
  }

  static void shareTextWithSubject(String text, String subject) {
    Share.share(text, subject: subject);
  }

  static void shareFiles(List<String> filePaths, String text) {
    Share.shareFiles(filePaths, text: text);
  }

  static void sharePDF(String pdfPath, String text) {
    Share.shareFiles([pdfPath], text: text);
  }

  static void shareLink(String url) {
    Share.share(url);
  }

  static void shareSecurity(SecurityDataModel securityDataModel) {
    if (securityDataModel.securityType?.code == null) {
      return;
    }
    String shareURL =
        '$shareSiteEndpoint?action=view&cat=securities&type=${securityDataModel.securityType!.code}&code=${securityDataModel.sgxCode}';
    Share.share(shareURL);
  }

  static void shareDerivative(DerivativeData derivativeData) {
    if (derivativeData.contractCode == null) {
      return;
    }
    String shareURL =
        '$shareSiteEndpoint?action=view&cat=derivatives&type=${derivativeData.derivativeType}&code=${derivativeData.contractCode}';
    Share.share(shareURL);
  }

  static void shareIndice(IndiceData indiceData) {
    if (indiceData.pid == null) {
      return;
    }
    String shareURL = '$shareSiteEndpoint?action=view&cat=indices&code=${indiceData.pid}';
    Share.share(shareURL);
  }
}
