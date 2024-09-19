import 'package:falcon_localizations/falcon_localizations.dart';
import 'package:falcon_logger/falcon_logger.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../enums/content_loader_names.dart';
import 'spinner_widget.dart';

const _content = 'content';
const _sharedContent = 'sharedContent';

class FalconScreenWrapper extends ConsumerStatefulWidget {
  const FalconScreenWrapper({
    super.key,
    required this.contentPath,
    required this.factory,
    this.sharedContentPath,
    this.contentLoaderName,
    this.routerState,
    this.shimmer,
  });

  final String contentPath;
  final String? sharedContentPath;
  final String? contentLoaderName;

  final GoRouterState? routerState;

  final Widget? shimmer;

  final Widget Function(
    Map<String, dynamic> json, {
    GoRouterState? routerState,
    Map<String, dynamic>? sharedContentJson,
  }) factory;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FalconScreenWrapperState();
}

class _FalconScreenWrapperState extends ConsumerState<FalconScreenWrapper> {
  Map<String, dynamic>? contentJson;
  Map<String, dynamic>? sharedContentJson;

  @override
  Widget build(BuildContext context) {
    _registerListener();

    if (contentJson == null) {
      final falconLocale = ref.watch(GetIt.I.get<FalconLocale>());

      return FutureBuilder<Map<String, Map<String, dynamic>?>>(
        future: _loadContent(falconLocale.locale),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              contentJson = snapshot.data?[_content] ?? {};
              sharedContentJson = snapshot.data?[_sharedContent];
              return widget.factory(
                contentJson!,
                sharedContentJson: sharedContentJson,
                routerState: widget.routerState,
              );
            } else if (snapshot.hasError) {
              Log.e(snapshot.error?.toString() ??
                  'Unknown Error For FalconContent!!!');
            }
          }

          return widget.shimmer ?? const SpinnerWidget();
        },
      );
    } else {
      return widget.factory(
        contentJson!,
        sharedContentJson: sharedContentJson,
        routerState: widget.routerState,
      );
    }
  }

  Future<Map<String, Map<String, dynamic>?>> _loadContent(Locale locale) async {
    var content = _globalContent['${widget.contentPath}$locale'];
    var sharedContent = _globalContent['${widget.sharedContentPath}$locale'];
    if(content == null ||sharedContent == null) {
      FalconContent falconContent = GetIt.I.get(
        instanceName: widget.contentLoaderName ??
            ContentLoaderNames.assetJsonContentLoder.name,
      );

      final List<Future<Map<String, dynamic>>> futures = [];
      futures.add(falconContent.loadJson(widget.contentPath, locale));
      if (widget.sharedContentPath != null) {
        futures.add(falconContent.loadJson(widget.sharedContentPath!, locale));
      }

      final List<Map<String, dynamic>> data = await Future.wait(futures);
      content = data.isNotEmpty ? data[0] : null;
      sharedContent = data.length >= 2 ? data[1] : null;
      _globalContent['${widget.contentPath}$locale'] = content ?? {};
      _globalContent['${widget.sharedContentPath}$locale'] = sharedContent ?? {};
    }
    return {
      _content: content,
      _sharedContent: sharedContent,
    };
  }

  _registerListener() {
    ref.listen(GetIt.I.get<FalconLocale>(), (curr, next) {
      setState(() {
        // trigger rebuild to load new content
      });
    });
  }
}
Map<String,Map<String,dynamic>> _globalContent = {};

