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

function calc_4ma_1() {
  var point = 100000 - Number($("#score2").val()) - Number($("#score3").val()) - Number($("#score4").val());
  $("#score1").val(point);
};
function calc_4ma_2() {
  var point = 100000 - Number($("#score3").val()) - Number($("#score4").val()) - Number($("#score1").val());
  $("#score2").val(point);
};
function calc_4ma_3() {
  var point = 100000 - Number($("#score4").val()) - Number($("#score1").val()) - Number($("#score2").val());
  $("#score3").val(point);
};
function calc_4ma_4() {
  var point = 100000 - Number($("#score1").val()) - Number($("#score2").val()) - Number($("#score3").val());
  $("#score4").val(point);
};

function calc_3ma_1() {
  var point = 105000 - Number($("#score2").val()) - Number($("#score3").val());
  $("#score1").val(point);
};
function calc_3ma_2() {
  var point = 105000 - Number($("#score3").val()) - Number($("#score1").val());
  $("#score2").val(point);
};
function calc_3ma_3() {
  var point = 105000 - Number($("#score1").val()) - Number($("#score2").val());
  $("#score3").val(point);
};

function calc_toutenko_1() {
  var point = 45000 - Number($("#score2").val()) - Number($("#score3").val());
  $("#score1").val(point);
};
function calc_toutenko_2() {
  var point = 45000 - Number($("#score3").val()) - Number($("#score1").val());
  $("#score2").val(point);
};
function calc_toutenko_3() {
  var point = 45000 - Number($("#score1").val()) - Number($("#score2").val());
  $("#score3").val(point);
};

function changePosition_4ma() {
  var before1 = $("#position1").val();
  var before2 = $("#position2").val();
  var before3 = $("#position3").val();
  var before4 = $("#position4").val();

  $("#position1").val(before2);
  $("#position2").val(before3);
  $("#position3").val(before4);
  $("#position4").val(before1);
};

function changePosition_3ma() {
  var before1 = $("#position1").val();
  var before2 = $("#position2").val();
  var before3 = $("#position3").val();

  $("#position1").val(before2);
  $("#position2").val(before3);
  $("#position3").val(before4);
};

(function() {
  $(document).ready(function() {
    $(".toutenko").hide();
  });

  $(document).on("click", "#tournament_mode_4ma", function() {
    $(".4ma").show();
    $(".3ma").hide();
    $(".toutenko").hide();

    $("#tournament_uma1").val(20);
    $("#tournament_uma2").val(10);
    $("#tournament_uma3").val(-10);
    $("#tournament_uma4").val(-20);

    $("#tournament_def_score").val(25000);
    $("#tournament_return_score").val(30000);

    $("#tournament_tobi_point").val(0);
  });

  $(document).on("click", "#tournament_mode_3ma", function() {
    $(".4ma").hide();
    $(".3ma").show();
    $(".toutenko").hide();

    $("#tournament_uma1").val(40);
    $("#tournament_uma2").val(-10);
    $("#tournament_uma3").val(-30);

    $("#tournament_def_score").val(35000);
    $("#tournament_return_score").val(40000);

    $("#tournament_tobi_point").val(0);
  });

  $(document).on("click", "#tournament_mode_toutenko", function() {
    $(".4ma").hide();
    $(".3ma").hide();
    $(".toutenko").show();

    $("#tournament_uma1").val(30);
    $("#tournament_uma2").val(0);
    $("#tournament_uma3").val(-30);

    $("#tournament_def_score").val(15000);
    $("#tournament_return_score").val(18000);

    $("#tournament_tobi_point").val(20);
  });
})();

