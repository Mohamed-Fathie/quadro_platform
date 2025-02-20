import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/nav_bloc.dart';
import 'bloc/nav_state.dart';

class OfferIcon extends StatelessWidget {
  const OfferIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.build_circle),
            if (state.thereIsOffer ?? false)
              Positioned(
                // Adjust position as needed
                right: -2,
                top: -2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
