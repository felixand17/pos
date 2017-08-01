var postWebPlayerId = function(player_id, uri) {
  $.ajax({
    url: uri,
    type: "POST",
    data: {
      "authenticity_token": $('meta[name="csrf-token"]').attr('content'),
      "user": {
        "player_id": player_id
      }
    },
    dataType: "script",
    complete: function(data){}
  });
}

$(document).on('turbolinks:load', function() {
  // Custom JS
  $('body').on('click', 'a[data-target="#modalDialog"]', function(e) {
    e.preventDefault();
    var uri = $(this).attr('href');
    $.ajax({
      url: uri,
      dataType: 'script',
      complete: function(data){
        $('#modalDialog').html(data.responseText);
      }
    });
  });

  $('body').on('keyup', 'input[data-remote-search=true]', function(e) {
    var form = $(this).closest('form'),
    uri = form.attr('action'),
    keyword = $(this).val();

    if (keyword.length > 0) {
      $.ajax({
        url: uri,
        type: "GET",
        data: { "keyword": keyword },
        dataType: 'script',
        complete: function(data){}
      });
    } else {
      $('#searchResult').html("");
    }

    e.preventDefault();
  });

  $( "form.loader" ).submit(function( ) {
    $('.overlay').show();
  });

  // Datepicker
  $('.datepicker').datepicker();

  /*browser detector */
  var BrowserDetect = {
    init: function () {
        this.browser = this.searchString(this.dataBrowser) || "Other";
        this.version = this.searchVersion(navigator.userAgent) || this.searchVersion(navigator.appVersion) || "Unknown";
    },
    searchString: function (data) {
        for (var i = 0; i < data.length; i++) {
            var dataString = data[i].string;
            this.versionSearchString = data[i].subString;

            if (dataString.indexOf(data[i].subString) !== -1) {
                return data[i].identity;
            }
        }
    },
    searchVersion: function (dataString) {
        var index = dataString.indexOf(this.versionSearchString);
        if (index === -1) {
            return;
        }

        var rv = dataString.indexOf("rv:");
        if (this.versionSearchString === "Trident" && rv !== -1) {
            return parseFloat(dataString.substring(rv + 3));
        } else {
            return parseFloat(dataString.substring(index + this.versionSearchString.length + 1));
        }
    },

    dataBrowser: [
        {string: navigator.userAgent, subString: "Edge", identity: "MS Edge"},
        {string: navigator.userAgent, subString: "MSIE", identity: "Explorer"},
        {string: navigator.userAgent, subString: "Trident", identity: "Explorer"},
        {string: navigator.userAgent, subString: "Firefox", identity: "Firefox"},
        {string: navigator.userAgent, subString: "Opera", identity: "Opera"},
        {string: navigator.userAgent, subString: "OPR", identity: "Opera"},

        {string: navigator.userAgent, subString: "Chrome", identity: "Chrome"},
        {string: navigator.userAgent, subString: "Safari", identity: "Safari"}
    ]
  };

  BrowserDetect.init();
  if ( BrowserDetect.browser == 'MSIE' ){
    $('#\\#modal_browser').modal('toggle');
  }
  /* menu search */
  var $rows = $('#tableMenu tr');
    $('#menuSearch').keyup(function() {
        var val = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase();

        $rows.show().filter(function() {
            var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
            return !~text.indexOf(val);
        }).hide();
  });

  var $order = $('#tableOrder tr');
    $('#orderSearch').keyup(function() {
        var val = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase();

        $order.show().filter(function() {
            var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
            return !~text.indexOf(val);
        }).hide();
  });

  /* icheck */
  $('input[type="checkbox"].minimal, input[type="radio"].minimal').iCheck({
    checkboxClass: 'icheckbox_minimal-blue',
    radioClass: 'iradio_minimal-blue'
  });

  $('#place-order').on('click', function() {
    if($(this).hasClass('disabled'))
      return;
    // do work
    $(this).addClass('disabled');
  });

  $('#menuBtn').prop('disabled', true);
  $('.menu_field').keyup(function() {
    if($(this).val() != '') {
      $('#menuBtn').prop('disabled', false);
    }
  });

  $('#payBtn').prop('disabled', true);
  $('#paymentField').keyup(function() {
    if($(this).val() != '') {
      $('#payBtn').prop('disabled', false);
    }
  });

  $('body').on('change', 'select[name="sale[payment_method]"]', function(){
    payment_method = $(this).val();
    amount = $('input[name="sale[amount]"]').val();

    if (payment_method == 'COMPLIMENT' || payment_method == 'DEBIT') {
      $('input[name="sale[payment]"]').val(amount).attr('readonly', true);
      $('#payBtn').prop('disabled', false);
    } else {
      $('input[name="sale[payment]"]').val('').attr('readonly', false);
      $('#payBtn').prop('disabled', true);
    }
  });

  $('body').on('keyup', 'input[name="sale[discount]"]', function(){
    discount = $(this).val();
    order = $('input[name="sale[order_id]"]').val();

    $.ajax({
      url: '/pos/orders/sales/calculate_discount?discount='+discount+'&id='+order,
      dataType: 'script',
      complete: function(data){}
    });
  });

  $('#printBill').on('click', function(){
    form_data = $(this).closest('form').serialize();
    $.ajax({
      url: '/pos/orders/sales/bill?'+form_data,
      dataType: 'script',
      complete: function(data){}
    });
  });

  $("a[id^=show_]").click(function(event) {
    $("#extra_" + $(this).attr('id').substr(5)).slideToggle("slow");
    event.preventDefault();
  });
});
