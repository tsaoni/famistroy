import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

// global style
final smallTextStyle = TextStyle(
  fontSize: 17.sp,
  color: const Color(0x90000000),
);

final largeTextStyle = TextStyle(
  fontSize: 28.sp,
  color: const Color(0xFF000000),
);

const lightBlack = Color(0x90000000);
const grey = Color(0xFF777777);
const lightYellow = Color.fromARGB(51, 255, 220, 107);
const yellow = Color.fromARGB(255, 255, 213, 107);
// global style


class RoundedRectElevatedButton extends StatelessWidget {
  const RoundedRectElevatedButton({
      Key? key,
      this.fixedSize,
      this.radius,
      required this.backgroundColor,
      required this.onPressed,
      required this.child,
    }
  ) : super(key: key);

  final Color backgroundColor;
  final double? radius;
  final Function() onPressed;
  final Widget child;
  final Size? fixedSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: fixedSize,
        primary: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: (radius != null) ? BorderRadius.circular(radius!) : BorderRadius.zero,
        )
      ),
      child: child
    );
  }
}

class RoundedElevatedButton extends StatelessWidget {
  const RoundedElevatedButton({
    Key? key,
    this.fixedSize,
    required this.onPressed,
    required this.backgroundColor,
    required this.child,
  }) : super(key: key);

  final Function() onPressed;
  final Color backgroundColor;
  final Widget child;
  final Size? fixedSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: fixedSize,
        primary: backgroundColor,
        elevation: 5,
        shape: StadiumBorder(),
      ),
      child: child,
    );
  }
}

class RoundedElevatedButtonWithBorder extends StatelessWidget {
  const RoundedElevatedButtonWithBorder({
    Key? key,
    this.fixedSize,
    required this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
  }) : super(key: key);

  final Function() onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Widget child;

  final Size? fixedSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: fixedSize,
        primary: backgroundColor,
        shape: StadiumBorder(),
        side: BorderSide(width: 5.w, color: borderColor),
      ),
      child: child
    );
  }
}

class CancelTextButton extends StatelessWidget {
  const CancelTextButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        "取消變更",
        style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: 17.sp,
          color: lightBlack,
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}

class OneTextInputField extends StatelessWidget {
  const OneTextInputField({
    Key? key,
    this.value,
    required this.title,
  }) : super(key: key);

  final String? value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: smallTextStyle),
        SizedBox(height: 10.h,),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: grey,
              width: 3.w,
            ),
            borderRadius: BorderRadius.circular(20.r)
          ),
          width: 260.w,
          height: 58.h,
          child: TextField(
            decoration: InputDecoration(
              hintText: value,

              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 13.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}