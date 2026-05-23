import 'package:flutter/material.dart';
import 'package:smartreminder/core/utils/app_colors.dart';

class SrAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String? appBarTitle;
  const SrAppBar({super.key, this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      title: Text(appBarTitle ?? ""),
      iconTheme: const IconThemeData(color: AppColors.primaryColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
