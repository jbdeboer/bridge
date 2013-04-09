/**
 * Created with JetBrains WebStorm.
 * User: deboer
 * Date: 4/8/13
 * Time: 9:02 PM
 * To change this template use File | Settings | File Templates.
 */


var dartMain;
var dartMainCallback;
var waitingForDart;

function dartMainRunner(main) {
    dartMain = main;
    console.log('got main');
    if (waitingForDart) {
        waitingForDart();
    }
}

function dartPrint(message) {
    console.log('dartPrint');
    if (message[0] == '!') {
        console.log('found results')
        dartMainCallback(message.substring(1));
    }
}

function callDart(callback) {
    console.log('callDart');
    dartMainCallback = callback;
    dartMain.call();
}

function DartCtrl($scope) {
    var editor = ace.edit("editor");
    editor.setTheme("ace/theme/chrome");
    editor.getSession().setMode("ace/mode/dart");

    editor.getSession().on('change', function(e) {
        $scope.dartText = editor.getValue();
        $scope.$apply();
    });

    var jseditor = ace.edit("jseditor");
    jseditor.setTheme("ace/theme/chrome");
    jseditor.getSession().setMode("ace/mode/javascript");
    jseditor.setReadOnly(true);
    jseditor.setHighlightActiveLine(false);


    console.log('constructor');
    $scope.callDart = function() {

        callDart(function(x) {
            $scope.dartResult = x;
        });
    };

    $scope.$watch('dartResult', function() {
        jseditor.setValue($scope.dartResult);
        jseditor.getSelection().clearSelection();
    });

    $scope.$watch('dartText', function() {
        if ($scope.dartText && $scope.dartText != $.dartText) {
          $.dartText = $scope.dartText;
          $scope.callDart();
        }

    });

    waitingForDart = function() {
        if ($scope.dartText) {
            $.dartText = $scope.dartText;
        }
        $scope.callDart();
        $scope.$apply();
    }
    if (dartMain) {
        waitingForDart();
    }

}