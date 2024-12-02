import 'package:falcon_ux_theme/falcon_ux_theme.dart';
import 'package:flutter/material.dart';

class NotificationPopup extends StatelessWidget {
  final String message;
  final Widget icon;
  final String title;
  final Map<String,dynamic> data;
  final Function(Map<String,dynamic>) onClick;
  const NotificationPopup({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.data,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final colorSurface = Theme.of(context).extension<FalconUxColorsSurface>()!;
    final falconVars = FalconUxVariables(context);
    final colorAccent = Theme.of(context).extension<FalconUxColorsAccents>()!;
    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.up,
        onDismissed: (_){
          Navigator.pop(context);
        },
        child: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.topCenter,
            child: Stack(
              children: [
                Container(
                  height: 81,
                  margin: const EdgeInsets.only(top: 20),
                  // Position it closer to the top
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                     color: colorSurface.surfaceHighest,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: colorSurface.outline)
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      icon,
                      SizedBox(width: falconVars.size12,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(title,
                            style: falconVars.textTheme.titleMedium?.copyWith(
                              color: colorSurface.onSurface,
                            ),),
                            Text(
                              message,
                              style: falconVars.labelMedium.copyWith(
                                color: colorAccent.tertiary,
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    onClick(data);
                  },
                  child: Container(
                    height: 81,
                    margin: const EdgeInsets.only(top: 20),
                    foregroundDecoration: BoxDecoration(
                      color: const Color(0xffBAF54D).withOpacity(0.08),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showSlideDownPopup({
  required BuildContext context,
  required String title,
  required String message,
  required Widget icon,
  required Map<String,dynamic> data,
  required Function(Map<String,dynamic>) onClick,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    barrierLabel: '',
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox.shrink();
    },
    transitionDuration: const Duration(milliseconds: 500),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, -1), // Start from above the screen
        end: Offset.zero, // Stop at its natural position
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ));

      return SlideTransition(
        position: slideAnimation,
        child:  NotificationPopup(
          title: title,
          message: message,
          icon: icon,
          data: data,
          onClick: onClick,
        ),
      );
    },
  );
}
