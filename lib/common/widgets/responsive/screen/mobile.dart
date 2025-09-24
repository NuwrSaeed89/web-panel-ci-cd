import 'package:brother_admin_panel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:flutter/material.dart';

class Mobile extends StatelessWidget {
  const Mobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TRoundedContainer(
            height: 450,
            width: double.infinity,
            backgroundColor: Colors.blue.withValues(alpha: 0.2),
            child: const Center(
              child: Text('Box 1'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TRoundedContainer(
            height: 215,
            width: double.infinity,
            backgroundColor: Colors.orange.withValues(alpha: 0.2),
            child: const Center(
              child: Text('Box 2'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TRoundedContainer(
            height: 215,
            width: double.infinity,
            backgroundColor: Colors.orange.withValues(alpha: 0.2),
            child: const Center(
              child: Text('Box 2'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TRoundedContainer(
            height: 215,
            width: double.infinity,
            backgroundColor: Colors.orange.withValues(alpha: 0.2),
            child: const Center(
              child: Text('Box 2'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TRoundedContainer(
            height: 190,
            width: double.infinity,
            backgroundColor: Colors.red.withValues(alpha: 0.2),
            child: const Center(
              child: Text('Box 5'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TRoundedContainer(
            height: 190,
            width: double.infinity,
            backgroundColor: Colors.pink.withValues(alpha: 0.2),
            child: const Center(
              child: Text('Box 6'),
            ),
          )
        ],
      ),
    );
  }
}
