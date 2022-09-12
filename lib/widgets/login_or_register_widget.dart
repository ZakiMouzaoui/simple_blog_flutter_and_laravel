import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';


class LoginOrRegisterWidget extends StatelessWidget {
  const LoginOrRegisterWidget({
    Key? key,
    required this.firstText,
    required this.secondText,
    required this.onTap
  }) : super(key: key);

  final String firstText;
  final String secondText;
  final Callback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            firstText
        ),
        const SizedBox(width: 5,),
        GestureDetector(
          onTap: onTap,
          child: Text(
            secondText,
            style: const TextStyle(
                color: Colors.amber
            ),
          ),
        )
      ],
    );
  }
}
