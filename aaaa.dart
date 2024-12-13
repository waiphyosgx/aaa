import 'package:package_info_plus/package_info_plus.dart';
import 'package:sgx_online_common/sgx_online_common_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionUtils {
  static Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }
  static void  updateIOS() async{
    const iosAppId = "id938618269";
    const appStoreUrl = 'https://apps.apple.com/app/$iosAppId';
    if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
      await launchUrl(Uri.parse(appStoreUrl));
    } else {
      luchSGXAppHomePage();
    }
  }
  static void updateAndroid() async {
    if (await isHmsAvailable()) {
      const appID = "C101482211";
      const appGalleryStore = "tps://appgallery.huawei.com/app/$appID";
      if (await canLaunchUrl(Uri.parse(appGalleryStore))) {
        await launchUrl(Uri.parse(appGalleryStore));
      } else {
        luchSGXAppHomePage();
      }
    }
    else {
      final packageName = await getPackageName();
      final playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';
      if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
        await launchUrl(Uri.parse(playStoreUrl));
      } else {
        luchSGXAppHomePage();
      }
    }
  }
  static void  luchSGXAppHomePage() async{
    const sgxHomeUrl = 'https://www.sgx.com/qr/redirect/mobileapp';
    if (await canLaunchUrl(Uri.parse(sgxHomeUrl))) {
      await launchUrl(Uri.parse(sgxHomeUrl));
    } else {
      throw 'Could not launch App Store URL';
    }
  }
}
