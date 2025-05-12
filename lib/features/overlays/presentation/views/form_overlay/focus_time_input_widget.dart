import 'package:flutter/material.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/form_state.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';

class FocusTimeInputWidget extends StatefulWidget {
  const FocusTimeInputWidget({super.key});

  @override
  State<FocusTimeInputWidget> createState() => _FocusTimeInputWidgetState();
}

class _FocusTimeInputWidgetState extends State<FocusTimeInputWidget> {
  int _selectedIndex = 1; // 기본값: 25분 (index 1)
  final List<int> _minutesOptions = [
    -1,
    1,
    3,
    5,
    10,
    15,
    20,
    25,
    30,
    45,
    60,
    120
  ];
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        _minutesOptions.indexOf(FormManager.instance.state.duration ~/ 60);
    _pageController =
        PageController(initialPage: _selectedIndex, viewportFraction: 0.2);
    FormManager.instance.addListener(_onFormStateChanged);
  }

  @override
  void dispose() {
    FormManager.instance.removeListener(_onFormStateChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onFormStateChanged(FocusForm state) {}

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        '얼마나 집중하실 건가요?',
        style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
      SizedBox(
        height: 40,
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: _minutesOptions.length,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            if (_selectedIndex != index) {
              setState(() {
                _selectedIndex = index;
                TimerManager.instance
                    .updateGoalTime(_minutesOptions[index] * 60);
                FormManager.instance
                    .updateDuration(_minutesOptions[index] * 60);
              });
            }
          },
          itemBuilder: (context, index) {
            final isSelected = index == _selectedIndex;
            return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                child: Text(
                  _minutesOptions[index] == -1
                      ? '∞'
                      : '${_minutesOptions[index]}',
                  style: TextStyle(
                    fontSize: isSelected ? 32 : 20,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[500],
                  ),
                ));
          },
        ),
      ),
    ]);
  }
}
