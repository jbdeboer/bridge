// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library model;

import 'package:web_ui/observe.dart';
import 'package:web_ui/observe/html.dart';

@observable
class ViewModel {
  bool isVisible(Todo todo) => todo != null &&
      ((getShowIncomplete() && !todo.done) || (getShowDone() && todo.done));

  //bool get showIncomplete => locationHash != '#/completed';
  bool getShowIncomplete() => locationHash != '#/completed';

  //bool get showDone => locationHash != '#/active';
  bool getShowDone() => locationHash != '#/active';
}

final ViewModel viewModel = new ViewModel();

// The real model:

@observable
class AppModel {
  ObservableList<Todo> todos = new ObservableList<Todo>();

  // TODO(jmesserly): remove this once List has a remove method.
  void removeTodo(Todo todo) {
    var index = todos.indexOf(todo);
    if (index != -1) {
      todos.removeRange(index, 1);
    }
  }

  // bool get allChecked => todos.length > 0 && todos.every((t) => t.done);
  bool getAllChecked() => todos.length > 0 && todos.every((t) => t.done);

  // set allChecked(bool value) => todos.forEach((t) { t.done = value; });
  setAllChecked(bool value) => todos.forEach((t) { t.done = value; });

  // int get doneCount {
  int getDoneCount() {
    int res = 0;
    todos.forEach((t) { if (t.done) res++; });
    return res;
  }

  // int get remaining => todos.length - doneCount;
  int getRemaining() => todos.length - getDoneCount();

  void clearDone() {
    // TODO(jmesserly): should methods on ObservableList return Observables?
    todos = toObservable(todos.where((t) => !t.done));
  }
}

final AppModel app = new AppModel();

@observable
class Todo {
  String task;
  bool done = false;

  Todo(this.task);

  String toString() => "$task ${done ? '(done)' : '(not done)'}";
}
