import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BodyMessageChat extends StatefulWidget {
  const BodyMessageChat({Key? key}) : super(key: key);

  @override
  State<BodyMessageChat> createState() => _BodyMessageChatState();
}

class _BodyMessageChatState extends State<BodyMessageChat> {
  late final FocusNode focusNode;
  late final TextEditingController textController;
  @override
  void initState() {
    focusNode = FocusNode();
    textController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expanded(
        //   child: ScrollablePositionedList.builder(
        //     shrinkWrap: true,
        //     itemCount: 5,
        //     itemBuilder: (context, index) {
        //       return textWidget(
        //         text: "asd",
        //       );
        //     },
        //   ),
        // ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withOpacity(0.6),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 32,
                color: const Color(0xFF087949).withOpacity(0.08),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(32.w),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: null,
                            controller: textController,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.red,
                              ),
                              hintText: "Type message",
                              hintStyle: TextStyle(
                                color: Colors.green,
                              ),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
