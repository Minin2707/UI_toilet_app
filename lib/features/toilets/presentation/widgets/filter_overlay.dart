import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class FilterOverlay extends StatelessWidget {

  final bool approvedOnly;

  final bool accessibleOnly;

  final bool freeOnly;

  final VoidCallback onApprovedTap;

  final VoidCallback onAccessibleTap;

  final VoidCallback onFreeTap;

  const FilterOverlay({

    super.key,

    required this.approvedOnly,

    required this.accessibleOnly,

    required this.freeOnly,

    required this.onApprovedTap,

    required this.onAccessibleTap,

    required this.onFreeTap,
  });

  @override
  Widget build(BuildContext context) {

    return Positioned(

      top: 12,
      left: 12,

      child: SizedBox(

        width:
            MediaQuery.of(context)
                .size
                .width - 24,

        child: Container(

          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),

          decoration: BoxDecoration(

            color:
                Colors.white.withOpacity(0.08),

            borderRadius:
                BorderRadius.circular(22),

            border: Border.all(

              color:
                  Colors.white.withOpacity(0.08),
            ),

            boxShadow: [

              BoxShadow(

                color:
                    Colors.black.withOpacity(0.25),

                blurRadius: 8,

                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: SingleChildScrollView(

            scrollDirection: Axis.horizontal,

            child: Row(
              children: [

                _GlassFilterChip(

                  title:
                      AppLocalizations.of(context)!
                          .approved,

                  selected: approvedOnly,

                  onTap: onApprovedTap,
                ),

                const SizedBox(width: 10),

                _GlassFilterChip(

                  title:
                      AppLocalizations.of(context)!
                          .accessible,

                  selected: accessibleOnly,

                  onTap: onAccessibleTap,
                ),

                const SizedBox(width: 10),

                _GlassFilterChip(

                  title:
                      AppLocalizations.of(context)!
                          .free,

                  selected: freeOnly,

                  onTap: onFreeTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _GlassFilterChip
    extends StatelessWidget {

  final String title;

  final bool selected;

  final VoidCallback onTap;

  const _GlassFilterChip({

    required this.title,

    required this.selected,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: AnimatedContainer(

        duration:
            const Duration(milliseconds: 180),

        padding: const EdgeInsets.symmetric(
          horizontal: 22,
        ),
        height: 46,

        decoration: BoxDecoration(

          color:
              selected
                  ? Colors.cyanAccent
                  : Colors.white.withOpacity(0.06),

          borderRadius:
              BorderRadius.circular(16),

          border: Border.all(

            color:
                selected
                    ? Colors.cyanAccent
                    : Colors.white.withOpacity(0.08),
          ),

          boxShadow: [

            if (selected)

              BoxShadow(

                color:
                    Colors.cyanAccent.withOpacity(0.35),

                blurRadius: 6,
              ),
          ],
        ),

        child: Center(

          child: Text(

            title,

            style: TextStyle(

              color:
                  selected
                      ? Colors.black
                      : Colors.white,

              fontWeight:
                  FontWeight.w600,

              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}