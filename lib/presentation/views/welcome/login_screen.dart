import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';

import '../../UIData/image_sources.dart';
import '../../services/bloc/authBloc/auth_bloc.dart';
import '../../services/bloc/authBloc/auth_event.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          imageAssetWidget(
            urlImage: ImageSources.imgChatIcon,
            packageName: null,
            width: 300.w.toInt(),
            height: 300.h.toInt(),
          ),
          GestureDetector(
            onTap: () {
              context.read<AuthBloc>().add(
                    AuthEventLogin(),
                  );
            },
            child: Container(
              width: 300.w,
              height: 100.h,
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 1.h,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.7),
                border: Border.all(
                  color: Colors.black54,
                ),
                borderRadius: BorderRadius.circular(
                  16.w,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textWidget(
                    text: context.loc.login_with_google,
                    size: 20.h,
                  ),
                  imageAssetWidget(
                    urlImage: ImageSources.imgGooleIcon,
                    packageName: null,
                    width: 50.w.toInt(),
                    height: 50.h.toInt(),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
