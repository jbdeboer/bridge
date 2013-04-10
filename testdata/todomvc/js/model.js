// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// Translated from: https://github.com/dart-lang/web-ui/blob/master/example/todomvc/web/model.dart


/**
 * @constructor
 */
function ViewModel() {}

/** @type{?boolean} */
ViewModel.prototype.todo;

ViewModel.prototype.isVisible = function() {
  return (
      this.todo != null &&
      ((this.getShowIncomplete() && !this.todo.done) ||
       (this.getShowDone() && this.todo.done)));
}

ViewModel.prototype.getShowIncomplete = function() {
  // TODO(chirayu): Implement.
}

ViewModel.prototype.getShowDone = function() {
  // TODO(chirayu): Implement.
}

/** @const */
var viewModel = new ViewModel();


/**
 * The real model:
 * @constructor
 */
function AppModel() {
  this.todos = null;
}

/** Array<Todo> */
AppModel.prototype.todos;

/**
 * Remove a Todo item.
 * @param {Todo} the item to remove.
 */
AppModel.prototype.removeTodo = function(todo) {
  var index = this.todos.indexOf(todo);
  if (index != -1) {
    this.todos.splice(index, 1);
  }
}

/** @return {boolean} */
AppModel.prototype.getAllChecked = function() {
  return (this.todos.length > 0 &&
          this.todos.every(function(t) { return t.done; }));
}

/**
 * @param {boolean} value.
 */
AppModel.prototype.setAllChecked = function(value) {
  this.todos.forEach(function(t) { t.done = value; });
}

/** @return {number} */
AppModel.prototype.getDoneCount = function() {
  /** @type {number} */
  var res = 0;
  this.todos.forEach(function(t) { if (t.done) res++; });
  return res;
}

AppModel.prototype.clearDone = function() {
  this.todos = this.todos.filter(function(t) { return !t.done });
}

/** @const */
var appModel = new AppModel();


/**
 * @constructor
 */
function Todo() {}

/** @type {string} */
Todo.prototype.task;

/** @type {boolean} */
Todo.prototype.done;

Todo.prototype.toString = function() {
  return task + " " + done ? '(done)' : '(not done)';
};
