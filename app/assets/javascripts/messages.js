var twilio_token;
var identity;
var chatClient;
var chatChannelName;
var chatChannel;
var receivedMessages = [];

Rails.start

Rails.ajax({
  url: "/tokens",
  type: "post",
  data: "",
  success: function(data) { 
    console.log('got it!');
    twilio_token = data.token;
    identity = data.identity
    chatChannelName = data.channel
    Twilio.Chat.Client.create(data.token).then(function(client) {
      console.log('Created chat client');
      chatClient = client;
      chatClient.getSubscribedChannels().then(createOrJoinPersonalChannel(identity));
    })
  },
  error: function(data) { console.log('token bombed')}
})

function createOrJoinPersonalChannel(identity) {
  console.log('Attempting to join personal chat channel...');
  chatClient.getChannelByUniqueName(chatChannelName)
  .then(function(channel) {
    chatChannel = channel;
    console.log('Found channel: ' + chatChannelName);
    console.log(chatChannel);
    setupChannel();
  }).catch(function() {
    // If it doesn't exist, let's create it
    console.log('Unable to create channel ' + chatChannelName);
  });
}

function setupChannel() {
  // Join the general channel
  chatChannel.join().then(function(channel) {
    console.log('General ' + identity +' Channel joined');

    // listen for new messages
    chatChannel.on('messageAdded', function(message) {
      corsole.log('message from - author: ' + message.author + ' - message: ' + message.body + ' sid ' + message.sid);
      if(message.author == identity) {
        add_message_from_them(message.body);
        clear_message_field();
      } else {
        if(!receivedMessages.includes(message.sid)) {
          receivedMessages << message.sid
          console.log('A message from the ether!!!');
          console.log('author ' + message.author + ' me: ' + identity);
          add_message_from_me(message.body);
        }
      }
    });
  });
}

$(document).on('turbolinks:load', function() {
  console.log('DOM ready!');
  document.querySelector("#new_message").addEventListener("submit", function() {
    message = message_text();
    console.log('submitted ' + message); 
    send_message_to_twilio(message);
  }, false);
});

function send_message_to_twilio(message) {
  chatChannel.sendMessage(message)
}

function message_text() {
  return $("#message_text").val()
}

function clear_message_field() {
  $("#message_text").val("")
}

function add_message_from_me(message) {
  var element = document.createElement('p');
  element.className = "from-me";
  element.innerText = message;
  $(".messages").append(element);
  scroll_to_bottom()
}

function add_message_from_them(message) {
  var element = document.createElement('p');
  element.className = "from-them";
  element.innerText = message;
  $(".messages").append(element);
  scroll_to_bottom()
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

function scroll_to_bottom() {
  $(".messenger-container").animate({
    scrollTop: $(".messenger-container")[0].scrollHeight
  }, 100);
}

function show_demo_messages() {
  var timeout = 625;
  setTimeout(function() {
    add_message_from_them("Yes!")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("Great, I'm here to help!")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("Feel free to ask questions anytime.")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("Also, any information you share with me will be held strictly private unless you choose to share it.")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("Let's get started. How old are you?")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_them("52")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("Thank You.  And about how much to you weigh in pounds?")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_them("220")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("Thank You.  And are you taller than 5'10 or shorter?")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_them("Taller")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_them("Great. Half way done. 3 more questions.")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("Are you being treated for Diabetes?")
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_them("No")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("Thank You. Do you have health insurance?")
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_them("Yes")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("Thank You. Last Question. Are you choosing living kidney donation under your own free will with no expectation of reward or payment?")
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_them("Yes")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("Good News!  Based on the data you have provided, you are healthy enough to be considered for Living Kidney donation.  You'll need contact a transplant center for further testing.  Do you have someone you would like to donate to specifically?")
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_them("No")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("Okay. I can connect you to a local transplant center for additional testing if you would like. If you provide me your zip code, I can find transplant centers in your area.")
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_them("63139")
    show_spinner();
  }, timeout)
  timeout += 1800
  setTimeout(function() {
    hide_spinner();
    add_message_from_me("There are two transplant centers near you. Saint Louis University Hospital and Barnes Jewish Hospital")
  }, timeout)
}
