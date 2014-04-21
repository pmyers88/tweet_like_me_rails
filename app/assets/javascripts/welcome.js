var accounts = '';

// get a json array of usernames
$.ajax({
  async: false,
  type: 'get',
  dataType: 'json',
  url: '/accounts.json',
  success: function(data) {
    accounts = data;
  }
});

function validate() {
  // remove any previous errors
  if($('#error').length) {
    $('#error').remove();
  }
  var re = new RegExp('^\\w{1,15}$');
  var username = $('#account_username').val();
  var account = getAccount(username);
  if(!re.test(username)) {
    $('<p id="error">Usernames can only have letters, numbers and underscores. Try another username.</p>')
      .insertAfter('form');
    $('#account_username').val('');
    return false;
  } else if(account != null) {
    // redirect to the username url if it already exists
    window.location.href = '/accounts/' + account.id + '/';
    return false;
  } else {
    $('<p>Fetching tweets (this only needs to be done once per account) <imc src="/loader.gif"></p>')
      .insertAfter('form');
    return true;
  }
}

function getAccount(username) {
  for(var i = 0; i < accounts.length; i++) {
    if(accounts[i].username == username) {
      return accounts[i];
    }
  }
  return null;
}
