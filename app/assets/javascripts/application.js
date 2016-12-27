// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

function calc1() {
  var point = 100000 - Number($("#score2").val()) - Number($("#score3").val()) - Number($("#score4").val());
  $("#score1").val(point);
};

function calc2() {
  var point = 100000 - Number($("#score3").val()) - Number($("#score4").val()) - Number($("#score1").val());
  $("#score2").val(point);
};

function calc3() {
  var point = 100000 - Number($("#score4").val()) - Number($("#score1").val()) - Number($("#score2").val());
  $("#score3").val(point);
};

function calc4() {
  var point = 100000 - Number($("#score1").val()) - Number($("#score2").val()) - Number($("#score3").val());
  $("#score4").val(point);
};
