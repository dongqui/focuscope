import 'package:flutter/material.dart';
import 'package:catodo/features/presentation/viewmodels/form_state.dart';

class FocusActivityInputWidget extends StatefulWidget {
  const FocusActivityInputWidget({super.key});

  @override
  State<FocusActivityInputWidget> createState() => _State();
}

class _State extends State<FocusActivityInputWidget> {
  late List<String> _tags = [];
  final TextEditingController _focusTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FormManager.instance.addListener(_onFormStateChanged);
    initTags();
  }

  @override
  void dispose() {
    // 리스너 제거
    FormManager.instance.removeListener(_onFormStateChanged);

    super.dispose();
  }

  void _onFormStateChanged(FocusForm state) {}

  void initTags() async {
    final tags = await FormManager.instance.getLatestActivities();
    setState(() {
      _tags = tags.map((tag) => tag.name).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '어떤 일에 집중하실 건가요?',
          style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _focusTextController,
          style: TextStyle(color: Color(0xFFFFFFFF)),
          cursorColor: Color(0xFFFFFFFF),
          onChanged: (text) {
            FormManager.instance.updateActivity(text);
          },
          decoration: const InputDecoration(
            fillColor: Color(0xFF0D1B2A),
            hintText: '예: 수학 문제 풀기, 영어 단어 외우기',
            hintStyle: TextStyle(color: Color(0x10FFFFFF)),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _tags
                .map((tag) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            FormManager.instance.updateActivity(tag);
                            _focusTextController.text = tag;
                          });
                        },
                        child: Chip(
                          label: Text(tag),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              _tags.remove(tag);
                            });
                          },
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
