import 'package:brother_admin_panel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:flutter/material.dart';

class Tablet extends StatelessWidget {
  const Tablet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TRoundedContainer(
                  height: 450,
                  backgroundColor: Colors.blue.withValues(alpha: 0.2),
                  child: const Center(
                    child: Text('Box 1'),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      TRoundedContainer(
                        height: 215,
                        backgroundColor: Colors.orange.withValues(alpha: 0.2),
                        child: const Center(
                          child: Text('Box 2'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TRoundedContainer(
                              height: 215,
                              backgroundColor:
                                  Colors.orange.withValues(alpha: 0.2),
                              child: const Center(
                                child: Text('Box 2'),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TRoundedContainer(
                              height: 215,
                              backgroundColor:
                                  Colors.orange.withValues(alpha: 0.2),
                              child: const Center(
                                child: Text('Box 2'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
