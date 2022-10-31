import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PassWordValidate extends StatefulWidget {
  final bool isPasswordEightCharacters;

  final bool hasPasswordOneNumber;
  PassWordValidate(
      {super.key,
      required this.isPasswordEightCharacters,
      required this.hasPasswordOneNumber});

  @override
  State<PassWordValidate> createState() => _PassWordValidateState();
}

class _PassWordValidateState extends State<PassWordValidate> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: widget.isPasswordEightCharacters
                        ? Colors.green
                        : Colors.transparent,
                    border: widget.isPasswordEightCharacters
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(50)),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text("Contains at least 8 characters"),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: widget.hasPasswordOneNumber
                        ? Colors.green
                        : Colors.transparent,
                    border: widget.hasPasswordOneNumber
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(50)),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text("Contains at least 1 number")
            ],
          ),
        ],
      ),
    );
  }
}
