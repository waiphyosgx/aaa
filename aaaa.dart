import 'package:falcon_bootstrap/falcon_bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sgx_online_common/sgx_online_common_services.dart';
import 'package:sgx_online_favourites/sgx_online_favorites_state.dart';
import 'package:sgx_online_favourites/sgx_online_favourites_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:falcon_device/falcon_device.dart';
import 'package:falcon_ux_font_awesome/falcon_ux_font_awesome.dart';
import 'package:falcon_ux_theme/falcon_ux_theme.dart';
import 'package:falcon_logger/falcon_logger.dart';
import 'package:falcon_utils/string_utils.dart';

import 'package:sgx_online_common/sgx_online_common_utils.dart';
import 'package:sgx_online_common/sgx_online_common_widgets.dart';

import '../../../sgx_online_favourites_service.dart';
import 'social_login_btn.dart';
import 'social_login_provider.dart';
import '../../content/content.dart';

class SocialLoginPage extends ConsumerStatefulWidget {
  const SocialLoginPage({
    super.key,
    required this.content,
    this.embeded = false,
  });

  final Content content;
  final bool embeded;

  @override
  ConsumerState createState() => _SocialLoginPageState();
}

class _SocialLoginPageState extends ConsumerState<SocialLoginPage> {
  final _sessionUtils = SessionUtils();

  final _googleSignIn = GoogleSignIn(scopes: ['email']);
  final _facebookSignIn = FacebookAuth.instance;

  var _userEmail = '';
  var _userName = '';
  var _signedInUsing = SocialLoginProvider.none;
  final FavouriteUserService _favouriteUserService = GetIt.I.get();
  final UserSyncService _userSyncService = GetIt.I.get();
  final WatchListFavouriteGroupState _watchListFavouriteGroupState =
      GetIt.I.get();
  final FavouriteService _favouriteService = GetIt.I.get();

  @override
  void initState() {
    super.initState();

    Future.wait([
      _sessionUtils.getSocialLoginId(),
      _sessionUtils.getSocialLoginUsername(),
      _sessionUtils.getSocialLoginProvider(),
      _sessionUtils.getSocialLoginEmail(),
    ]).then((values) {
      if (values[0].isEmpty) {
        return;
      }
      _userName = values[1];
      _userEmail = values[3];
      if (mounted) {
        setState(() {
          _signedInUsing = SocialLoginProvider.getProviderByName(values[2]);
        });
      }
    });
    _favouriteUserService.getUsersInfo().then((value) {
      if (mounted) {
        setState(() {
          _userName = value.username;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final falconVars = FalconUxVariables(context);
    final falconUxEmphasis =
        Theme.of(context).extension<FalconUxColorsEmphasis>()!;

    final socialLogins = Column(
      children: [
        if (!widget.embeded) SizedBox(height: falconVars.size40),
        Text(
          widget.content.favouritesSyncMessage,
          textAlign: widget.embeded ? TextAlign.center : null,
          style: falconVars.headlineMedium.copyWith(
            color: falconUxEmphasis.highEmpDefault,
          ),
        ),
        SizedBox(
            height: widget.embeded ? falconVars.size24 : falconVars.size40),
        if (FalconDevicePlatform.isIOS) ...[
          SocialLoginBtn(
            icon: 'logo_apple',
            text: _signedInUsing == SocialLoginProvider.apple
                ? widget.content.signOut
                : widget.content.signInWithApple,
            textColor: Colors.white,
            backgroundColor: Colors.black,
            onClick: () {
              _signedInUsing == SocialLoginProvider.apple
                  ? _onSignOutClick(false)
                  : _onSignInClick(SocialLoginProvider.apple);
            },
          ),
        ],
        SizedBox(height: falconVars.size16),
        SocialLoginBtn(
          icon: 'logo_google',
          text: _signedInUsing == SocialLoginProvider.google
              ? widget.content.signOut
              : widget.content.signInWithGoogle,
          textColor: falconVars.onSurface,
          backgroundColor: falconVars.surface,
          onClick: () {
            _signedInUsing == SocialLoginProvider.google
                ? _onSignOutClick(false)
                : _onSignInClick(SocialLoginProvider.google);
          },
        ),
        SizedBox(height: falconVars.size16),
        SocialLoginBtn(
          icon: 'logo_facebook',
          text: _signedInUsing == SocialLoginProvider.facebook
              ? widget.content.signOut
              : widget.content.signInWithFacebook,
          textColor: Colors.white,
          backgroundColor: const Color(0xFF1877F2),
          onClick: () {
            _signedInUsing == SocialLoginProvider.facebook
                ? _onSignOutClick(false)
                : _onSignInClick(SocialLoginProvider.facebook);
          },
        ),
        SizedBox(height: falconVars.size16),
        if (_userEmail.isNotEmpty)
          Text("${widget.content.youHaveLoggedInAs} $_userEmail"),
        SizedBox(height: falconVars.size16),
        if (_signedInUsing != SocialLoginProvider.none)
          Row(
            children: [
              Text('${widget.content.username}: '),
              Text(
                _userName,
                style:
                    falconVars.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: FaIcon(
                  const IconDataLight(FA.penToSquare),
                  size: falconVars.size16,
                ),
                onPressed: _showUsernameEditDialog,
              ),
            ],
          )
      ],
    );

    if (widget.embeded) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: falconVars.size12),
        child: IntrinsicHeight(
          child: socialLogins,
        ),
      );
    }

    return Scaffold(
      appBar: MobileTopHeader(
        secondaryActions: const [],
        leadingAction: IconButton(
          style: falconVars.mediumIconBtn,
          icon: FaIcon(
            const IconDataLight(FA.chevronLeft),
            size: falconVars.size20,
            color: falconVars.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleWidget: Text(
          widget.content.syncDevices,
          style: falconVars.headlineLarge.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: falconVars.size12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 380),
            child: socialLogins,
          ),
        ),
      ),
    );
  }

  _onSignInClick(SocialLoginProvider provider) async {
    if (_signedInUsing != SocialLoginProvider.none) {
      await _onSignOutClick(true);
      if (_signedInUsing != SocialLoginProvider.none) {
        return;
      }
    }

    var userId = '';
    var username = '';
    var email = '';

    try {
      switch (provider) {
        case SocialLoginProvider.google:
          final acc = await _googleSignIn.signIn();

          if (acc != null) {
            userId = acc.id;
            email = acc.email;
          }
          break;
        case SocialLoginProvider.apple:
          final credential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );
          if (credential.userIdentifier != null) {
            userId = credential.userIdentifier!;
            email = credential.email ?? '';
            username = credential.givenName ?? '';
          }
          break;
        case SocialLoginProvider.facebook:
          final result =
              await _facebookSignIn.login(permissions: ['public_profile']);

          if (result.status == LoginStatus.success) {
            final data = await _facebookSignIn.getUserData();

            if (!isBlank(data['id'])) {
              userId = data['id'];
              email = data['email'] ?? '';
              username = data['name'] ?? '';
            }
          }
          break;
        case SocialLoginProvider.huawei:
          // TODO: Handle this case.
          break;
        case SocialLoginProvider.none:
          break;
      }

      if (userId.isEmpty) {
        return;
      }

      setState(() {
        _userEmail = email;
        _signedInUsing = provider;
        _userName = _userName.isEmpty ? username : _userName;
      });

      _saveDataInSession(
        name: _userName.isEmpty ? username : _userName,
        id: userId,
        provider: provider,
        email: email,
      );

      final shouldMergeFavourites = await _showFavouritesMergeDialog();
      _sessionUtils.saveUUID(uuid: userId);
      if (shouldMergeFavourites == true) {
        await _favouriteService.mergedFavouriteService(
          favouriteApiParameterModel: FavouriteApiParameterModel(
            cmd: 'mergewatchlist',
            //TODO (implement for ios and huawei)
            deviceType: 'android',
            deviceToken: await _sessionUtils.getDeviceToken(),
            userId: await _sessionUtils.getUUID(),
          ),
        );
      } else if (shouldMergeFavourites == false) {
        await _userSyncService.login();
        await _userSyncService.reportAppVersion();
      }
      ref
          .read(_watchListFavouriteGroupState.notifier)
          .getWatchListFavouriteModel();
    } catch (e) {
      Log.e(e.toString());
      var showErrorDialog = true;
      if (e is SignInWithAppleAuthorizationException &&
          e.code == AuthorizationErrorCode.canceled) {
        showErrorDialog = false;
      }
      if (showErrorDialog) {
        _showErrorDialog(e);
      }
    }
  }

  _onSignOutClick(bool isAccountChange) async {
    final confirmed = await _showSignOutConfirmDialog(isAccountChange);

    if (confirmed != true) {
      return;
    }

    try {
      if (_signedInUsing == SocialLoginProvider.google) {
        await _googleSignIn.disconnect();
      } else if (_signedInUsing == SocialLoginProvider.facebook) {
        // await _facebookSignIn.logOut();
      }

      setState(() {
        _signedInUsing = SocialLoginProvider.none;
        _userEmail = '';
      });
      final socialId = await _sessionUtils.getUUID();
      await _sessionUtils.saveUUID(uuid: "");
      final isKeep = await _showKeepOrClearDialog();
      if (isKeep == true) {
        try {
          await _favouriteService.mergedFavouriteService(
              favouriteApiParameterModel: FavouriteApiParameterModel(
                cmd: 'logoutandkeep',
                deviceType: 'android',
                userId: await _sessionUtils.getDeviceToken(),
                deviceToken: await _sessionUtils.getDeviceToken(),
                socialLoginId: socialId,
                pushToken: 'FAKE',
              ));
        }
        catch(_){}
      }
      else if(isKeep == false){
        try{
          await _favouriteService.mergedFavouriteService(favouriteApiParameterModel:
          FavouriteApiParameterModel(
            cmd: 'login',
            deviceType: 'android',
            userId: await _sessionUtils.getDeviceToken(),
            deviceToken: await _sessionUtils.getDeviceToken(),
            socialLoginId: socialId,
          ));
        }
        catch(_){}
      }
      _saveDataInSession(
        name: '',
        id: '',
        email: '',
        provider: SocialLoginProvider.none,
      );
      ref.read(_watchListFavouriteGroupState.notifier).getWatchListFavouriteModel();
    } catch (e) {
      Log.e(e.toString());
      _showErrorDialog(e, 'Error while Signing out');
    }
  }

  _saveDataInSession({
    String? id,
    String? name,
    String? email,
    SocialLoginProvider? provider,
  }) async {
    if (id != null) {
      _sessionUtils.saveSocialLoginId(id);
    }
    if (name != null) {
      await _favouriteUserService.updateUserName(name);
      _sessionUtils.saveSocialLoginUsername(name);
    }
    if (email != null) {
      _sessionUtils.saveSocialLoginEmail(email);
    }
    if (provider != null) {
      _sessionUtils.saveSocialLoginProvider(provider.name);
    }
  }

  Future<bool?> _showKeepOrClearDialog() async {
    final keepClearDialog = showConfirmDialog(
      context: context,
      title: widget.content.confirmSignOut,
      content: widget.content.keepFavouriteMessage,
      cancelText: widget.content.clear,
      confirmText: widget.content.keep,
    );
    return keepClearDialog;
  }

  Future<bool?> _showSignOutConfirmDialog(bool isAccountChange) {
    final signOutConfirm = showConfirmDialog(
      context: context,
      title: isAccountChange
          ? widget.content.changeAccount
          : widget.content.confirmSignOut,
      content: isAccountChange
          ? widget.content.changeAccountMessage
          : widget.content.signOutMessage,
      cancelText: widget.content.cancel,
      confirmText: widget.content.confirm,
    );
    return signOutConfirm;
  }

  Future<bool?> _showFavouritesMergeDialog() {
    final mergeConfirm = showConfirmDialog(
      context: context,
      title: widget.content.mergeFavouritesData,
      content: widget.content.favouritesMergeMessage,
      cancelText: widget.content.discard,
      confirmText: widget.content.merge,
    );
    return mergeConfirm;
  }

  _showErrorDialog(Object? error, [String? title]) {
    final falconVars = FalconUxVariables(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title ?? widget.content.error),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.content.errorRetryMessage),
            SizedBox(height: falconVars.size16),
            Text(
              error?.toString() ?? '',
              style: falconVars.bodySmall.copyWith(color: falconVars.error),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: falconVars.mediumBtn,
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(widget.content.close),
          ),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(falconVars.size4)),
      ),
    );
  }

  _showUsernameEditDialog() async {
    final newValue = await showInputDialog(
      context: context,
      title: widget.content.updateUsername,
      hintText: '',
      contentText: widget.content.usernameUpdateMessage,
      useTextCount: false,
      defaultValue: _userName,
      cancelText: widget.content.cancel,
      confirmText: widget.content.update,
    );

    if (_userName != newValue && newValue != null) {
      final val = newValue;
      setState(() => _userName = newValue);
      _saveDataInSession(name: val);
    }
  }
}

class UsernameInputFormatter extends TextInputFormatter {
  final _regex = RegExp(r'^[A-Za-z][A-Za-z0-9]{0,31}$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    return _regex.hasMatch(newValue.text) ? newValue : oldValue;
  }
}
