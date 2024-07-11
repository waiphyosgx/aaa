import 'package:falcon_ux_theme/falcon_ux_theme.dart';
import 'package:flutter/material.dart';

Future<String?> showInputDialog({
  required BuildContext context,
  required String title,
  required String hintText,
  required String cancelText,
  required String confirmText,
  String? contentText,
  String? defaultValue,
  bool? useTextCount,
}) {
  return showGeneralDialog<String?>(
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 300),
    context: context,
    pageBuilder: (context, ani1, ani2) => Center(
      child: _InputDialog(
        title: title,
        hintText: hintText,
        cancelText: cancelText,
        confirmText: confirmText,
        contentText: contentText,
        defaultValue: defaultValue,
        useTextCount: useTextCount ?? true,
      ),
    ),
  );
}

class _InputDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String cancelText;
  final String confirmText;
  final String? contentText;
  final String? defaultValue;
  final bool useTextCount;

  const _InputDialog({
    required this.title,
    required this.hintText,
    required this.cancelText,
    required this.confirmText,
    this.contentText,
    this.defaultValue,
    required this.useTextCount,
  });

  @override
  __InputDialogState createState() => __InputDialogState();
}

class __InputDialogState extends State<_InputDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final falconVars = FalconUxVariables(context);
    final falconUxColorSurface =
        Theme.of(context).extension<FalconUxColorsSurface>()!;
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: 280,
      decoration: BoxDecoration(
        color: falconVars.surface,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.title,
                  style: falconVars.headlineMedium.copyWith(
                    color: falconUxColorSurface.onSurface,
                  )),
            ),
            const SizedBox(
              height: 16,
            ),
            if (widget.contentText != null) Text(widget.contentText!,),
            if (widget.contentText != null)
              const SizedBox(
                height: 20,
              ),
            TextField(
              maxLength: widget.useTextCount ? 25 : null,
              cursorHeight: 20.0,
              style: const TextStyle(
                fontSize: 14.0,
              ),
              controller: _controller,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: const Color(0xff3C3C43).withOpacity(0.30),
                ),
                hintText: widget.hintText,
                fillColor: falconUxColorSurface.surface,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: falconVars.mediumBtn,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(widget.cancelText),
                ),
                SizedBox(
                  width: falconVars.size12,
                ),
                FilledButton(
                  style: falconVars.mediumBtn,
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Navigator.pop(context, _controller.text);
                    }
                  },
                  child: Text(widget.confirmText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
