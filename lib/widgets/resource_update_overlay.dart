import 'package:flutter/material.dart';
import '../features/presentation/viewmodels/resource_update_state.dart';

class ResourceUpdateOverlay extends StatefulWidget {
  const ResourceUpdateOverlay({super.key});

  @override
  State<ResourceUpdateOverlay> createState() => _ResourceUpdateOverlayState();
}

class _ResourceUpdateOverlayState extends State<ResourceUpdateOverlay> {
  late ResourceUpdateManager _updateManager;

  @override
  void initState() {
    super.initState();
    _updateManager = ResourceUpdateManager.instance;
    _updateManager.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _updateManager.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged(ResourceUpdateState state, ResourceUpdateState? previousState) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _updateManager.state;
    
    // idle 상태이거나 completed 상태이고 업데이트가 없는 경우 오버레이를 숨김
    if (state.status == UpdateStatus.idle || 
        (state.status == UpdateStatus.completed && !state.hasUpdates)) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatusIcon(state.status),
                const SizedBox(height: 16),
                Text(
                  _getStatusTitle(state.status),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (state.status == UpdateStatus.downloading) ...[
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: state.progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ],
                if (state.status == UpdateStatus.error) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // 재시도 로직
                    },
                    child: const Text('재시도'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(UpdateStatus status) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case UpdateStatus.checking:
        iconData = Icons.sync;
        iconColor = Colors.blue;
        break;
      case UpdateStatus.downloading:
        iconData = Icons.download;
        iconColor = Colors.orange;
        break;
      case UpdateStatus.completed:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case UpdateStatus.error:
        iconData = Icons.error;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.info;
        iconColor = Colors.grey;
    }

    return Icon(
      iconData,
      size: 48,
      color: iconColor,
    );
  }

  String _getStatusTitle(UpdateStatus status) {
    switch (status) {
      case UpdateStatus.checking:
        return '업데이트 확인 중';
      case UpdateStatus.downloading:
        return '리소스 다운로드 중';
      case UpdateStatus.completed:
        return '완료';
      case UpdateStatus.error:
        return '오류 발생';
      default:
        return '';
    }
  }
}
