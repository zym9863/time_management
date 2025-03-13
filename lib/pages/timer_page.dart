import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/timer_model.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with SingleTickerProviderStateMixin {
  final TimerModel _timerModel = TimerModel();
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _workMinutes = 25;
  int _restMinutes = 5;
  bool _isSettingsOpen = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut)
    );
    _animationController.repeat(reverse: true);

    // 设置计时器回调
    _timerModel.onTick = () {
      setState(() {});
    };
    
    _timerModel.onComplete = () {
      _playAlarmSound();
      
      if (_timerModel.status == TimerStatus.working) {
        _timerModel.startRest();
      } else if (_timerModel.status == TimerStatus.resting) {
        _timerModel.startWork();
      }
      
      setState(() {});
    };
  }
  
  @override
  void dispose() {
    _timerModel.dispose();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _playAlarmSound() async {
    await _audioPlayer.play(AssetSource('sounds/sound_effect.mp3'));
  }
  
  String _formatRemainingTime() {
    final minutes = _timerModel.remainingSeconds ~/ 60;
    final seconds = _timerModel.remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  String _getStatusText() {
    switch (_timerModel.status) {
      case TimerStatus.idle:
        return '准备开始';
      case TimerStatus.working:
        return '专注工作中';
      case TimerStatus.resting:
        return '休息时间';
      case TimerStatus.paused:
        return '已暂停';
    }
  }
  
  Color _getStatusColor() {
    switch (_timerModel.status) {
      case TimerStatus.idle:
        return const Color(0xFF4A90E2);
      case TimerStatus.working:
        return const Color(0xFFFF6B6B);
      case TimerStatus.resting:
        return const Color(0xFFA0D8B3);
      case TimerStatus.paused:
        return const Color(0xFFFFD93D);
    }
  }
  
  void _applySettings() {
    _timerModel.setWorkDuration(_workMinutes);
    _timerModel.setRestDuration(_restMinutes);
    setState(() {
      _isSettingsOpen = false;
    });
  }
  
  Widget _buildSettingsPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('设置', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          Row(
            children: [
              Text('工作时间（分钟）', style: Theme.of(context).textTheme.bodyLarge),
              Expanded(
                child: Slider(
                  value: _workMinutes.toDouble(),
                  min: 1,
                  max: 60,
                  divisions: 59,
                  activeColor: const Color(0xFF4A90E2),
                  label: _workMinutes.toString(),
                  onChanged: (value) {
                    setState(() {
                      _workMinutes = value.toInt();
                    });
                  },
                ),
              ),
              Text(_workMinutes.toString(), style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('休息时间（分钟）', style: Theme.of(context).textTheme.bodyLarge),
              Expanded(
                child: Slider(
                  value: _restMinutes.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  activeColor: const Color(0xFFA0D8B3),
                  label: _restMinutes.toString(),
                  onChanged: (value) {
                    setState(() {
                      _restMinutes = value.toInt();
                    });
                  },
                ),
              ),
              Text(_restMinutes.toString(), style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applySettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
              ),
              child: const Text('应用设置'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_timerModel.status == TimerStatus.idle) ...[  
          ElevatedButton.icon(
            onPressed: () {
              _timerModel.startWork();
              setState(() {});
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('开始工作'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              elevation: 4,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              _timerModel.startRest();
              setState(() {});
            },
            icon: const Icon(Icons.coffee),
            label: const Text('开始休息'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA0D8B3),
              foregroundColor: Colors.white,
              elevation: 4,
            ),
          ),
        ] else if (_timerModel.status == TimerStatus.paused) ...[  
          ElevatedButton.icon(
            onPressed: () {
              _timerModel.resume();
              setState(() {});
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('继续'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              elevation: 4,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              _timerModel.stop();
              setState(() {});
            },
            icon: const Icon(Icons.stop),
            label: const Text('停止'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[400],
              foregroundColor: Colors.white,
              elevation: 4,
            ),
          ),
        ] else ...[  // working or resting
          ElevatedButton.icon(
            onPressed: () {
              _timerModel.pause();
              setState(() {});
            },
            icon: const Icon(Icons.pause),
            label: const Text('暂停'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD93D),
              foregroundColor: Colors.white,
              elevation: 4,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              _timerModel.stop();
              setState(() {});
            },
            icon: const Icon(Icons.stop),
            label: const Text('停止'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[400],
              foregroundColor: Colors.white,
              elevation: 4,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        title: Text('时间管理工具', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF636E72)),
            onPressed: () {
              setState(() {
                _isSettingsOpen = !_isSettingsOpen;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF5F7FA),
              const Color(0xFFF5F7FA).withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _animation,
                        child: Image.asset(
                          'assets/time_management_image.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _getStatusColor().withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getStatusText(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        _formatRemainingTime(),
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 72,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 48),
                      _buildControlButtons(),
                    ],
                  ),
                ),
              ),
              if (_isSettingsOpen) ...[  
                const SizedBox(height: 24),
                _buildSettingsPanel(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}