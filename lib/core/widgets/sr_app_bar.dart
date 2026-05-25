import 'package:flutter/material.dart';
import 'package:smartreminder/core/utils/app_colors.dart';

class SrAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? appBarTitle;
  final List<Widget>? actions;
  final Widget? titleWidget;

  const SrAppBar({super.key, this.appBarTitle, this.actions, this.titleWidget,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.primaryColor),
      title: titleWidget ?? Text(appBarTitle ?? "", style: const TextStyle(fontWeight: FontWeight.w600),),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}