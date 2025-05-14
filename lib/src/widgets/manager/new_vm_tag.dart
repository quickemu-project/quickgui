import 'package:flutter/material.dart';

class NewVmTag extends StatelessWidget {
  const NewVmTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.fiber_new,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
