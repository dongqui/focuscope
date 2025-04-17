import 'package:flutter/material.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/form_state.dart';

class FocusActivityInputWidget extends StatefulWidget {
  const FocusActivityInputWidget({super.key});

  @override
  State<FocusActivityInputWidget> createState() => _State();
}

class _State extends State<FocusActivityInputWidget> {
  final TextEditingController _focusTextController = TextEditingController();
  late List<String> _tags = [];

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
    _focusTextController.dispose();
    super.dispose();
  }

  void _onFormStateChanged(FocusForm state) {
    print('state: ${state.activity}');
    _focusTextController.text = state.activity;
  }

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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextField(
          controller: _focusTextController,
          onChanged: (text) {
            FormManager.instance.updateActivity(text);
          },
          decoration: const InputDecoration(
            hintText: '예: 수학 문제 풀기, 영어 단어 외우기',
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _tags
                .map((tag) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          print('tag: $tag');
                          setState(() {
                            FormManager.instance.updateActivity(tag);
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
