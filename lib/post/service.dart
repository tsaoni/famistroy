import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

getClickableTextSpans (BuildContext context, List<String> tokenizedString) {
  return tokenizedString.map(
    (word) => TextSpan(
        text: word,
        style: TextStyle(color: Colors.black),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            showDialog(
              context: context,
              barrierColor: Colors.black12,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(word),
                        InkWell(
                          child: Icon(Icons.volume_up_rounded),
                          onTap: () {
                            // TODO: Text To Speech service
                          },
                        ),
                      ],
                    ),
                  ),
                );
            });
          } 
      ),
  ).toList();
}