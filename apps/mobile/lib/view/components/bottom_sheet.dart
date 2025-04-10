import 'package:flutter/material.dart';

class BottomSheet extends StatelessWidget {
  final ScrollController scrollController;

  const BottomSheet({Key? key, required this.scrollController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : const Color.fromARGB(255, 253, 246, 254),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.15,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black26,
                ),
              ),
              const Text(
                'Content of the bottom sheet',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
