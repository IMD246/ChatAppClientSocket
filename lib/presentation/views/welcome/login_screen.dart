import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../UIData/image_sources.dart';
import '../../services/bloc/authBloc/auth_bloc.dart';
import '../../services/bloc/authBloc/auth_event.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        imageAssetWidget(
          urlImage: ImageSoruces.imgChatIcon,
          packageName: null,
          width: 200.w.toInt(),
          height: 200.h.toInt(),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(16.w),
          onTap: () {
            context.read<AuthBloc>().add(
                  AuthEventLogin(),
                );
          },
          child: Center(
            child: Container(
              width: 200.w,
              height: 50.h,
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 1.h,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black54,
                ),
                borderRadius: BorderRadius.circular(
                  16.w,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  textWidget(text: "Login with google"),
                  SizedBox(
                    width: 8.w,
                  ),
                  imageAssetWidget(
                    urlImage: ImageSoruces.imgGooleIcon,
                    packageName: null,
                    width: 25.w.toInt(),
                    height: 25.h.toInt(),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
