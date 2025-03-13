import 'dart:async';

enum TimerStatus {
  idle,      // 空闲状态
  working,   // 工作状态
  resting,   // 休息状态
  paused     // 暂停状态
}

class TimerModel {
  int workDuration = 25 * 60; // 默认工作时间25分钟（以秒为单位）
  int restDuration = 5 * 60;  // 默认休息时间5分钟（以秒为单位）
  int remainingSeconds = 0;   // 剩余秒数
  TimerStatus status = TimerStatus.idle; // 当前状态
  Timer? _timer;              // 计时器
  Function? onTick;           // 计时回调
  Function? onComplete;       // 完成回调
  
  // 开始工作计时
  void startWork() {
    status = TimerStatus.working;
    remainingSeconds = workDuration;
    _startTimer();
  }
  
  // 开始休息计时
  void startRest() {
    status = TimerStatus.resting;
    remainingSeconds = restDuration;
    _startTimer();
  }
  
  // 暂停计时
  void pause() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      status = TimerStatus.paused;
    }
  }
  
  // 继续计时
  void resume() {
    if (status == TimerStatus.paused) {
      if (remainingSeconds > 0) {
        status = (status == TimerStatus.working || status == TimerStatus.paused) 
            ? TimerStatus.working 
            : TimerStatus.resting;
        _startTimer();
      }
    }
  }
  
  // 停止计时
  void stop() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    status = TimerStatus.idle;
    remainingSeconds = 0;
  }
  
  // 设置工作时间（分钟）
  void setWorkDuration(int minutes) {
    workDuration = minutes * 60;
    if (status == TimerStatus.idle) {
      remainingSeconds = workDuration;
    }
  }
  
  // 设置休息时间（分钟）
  void setRestDuration(int minutes) {
    restDuration = minutes * 60;
  }
  
  // 启动计时器
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        if (onTick != null) {
          onTick!();
        }
      } else {
        timer.cancel();
        if (onComplete != null) {
          onComplete!();
        }
      }
    });
  }
  
  // 释放资源
  void dispose() {
    _timer?.cancel();
  }
}