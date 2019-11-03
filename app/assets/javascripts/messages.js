function add_message_from_me(message) {
  var element = document.createElement('p');
  element.className = "from-me";
  element.innerText = message;
  $(".messages").append(element);
}

function add_message_from_them(message) {
  var element = document.createElement('p');
  element.className = "from-them";
  element.innerText = message;
  $(".messages").append(element);
}

function show_spinner() { 
  var element = document.createElement('div');
  element.className = "typing-indicator";
  element.append(document.createElement('span'));
  element.append(document.createElement('span'));
  element.append(document.createElement('span'));
  $(".messages").append(element);
}

function hide_spinner() {
  $(".typing-indicator").remove();
}
