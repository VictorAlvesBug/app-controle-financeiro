import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabeledDivider extends StatelessWidget{
  LabeledDivider({
    Key? key,
    required this.text,
    required this.verticalPadding,
}) : super(key: key);

  final String text;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        SizedBox(height: verticalPadding),
        Row(children: <Widget>[
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black38,
                  height: 20,
                )),
          ),
          Text(text,style: TextStyle(color: Colors.white70)),
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: Divider(
                  color: Colors.black38,
                  height: 20,
                )),
          ),
        ]),
        SizedBox(height: verticalPadding),
      ],
    );
  }
}