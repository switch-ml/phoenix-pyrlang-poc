// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import { Socket } from "phoenix"

let socket = new Socket("/socket", { params: { token: window.userToken } })

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()


let create_block = $('#create');
let strategy = $('#strategy');
let scriptFile = $('#script-file');
let script = $('#script');
let submit = $('#submit');
let binary_data;


let execute_block = $('#execute');
let script_input = $('#script-input');
let submit_execution = $('#submit-execution');

let query_id = $('#query-id');
let query_strategy = $('#query-strategy');
let source_div = $('#source-div');

let result_block = $('#result');
let input_div = $('#input-div');
let result_div = $('#result-div');

let block_id;
result_block.hide()
execute_block.hide()


// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("room:general", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })



submit.on("click", event => {
  const payload = { script: binary_data ? binary_data : script.val(), strategy: strategy.val() }
  channel.push('message', payload);
  strategy.val('');
  binary_data = null;
  scriptFile.val(null)
  // 
})

submit_execution.on("click", event => {
  const payload = { uuid: block_id, input: script_input.val() }
  channel.push('user_input', payload);
})

scriptFile.on("change", event => {
  const reader = new FileReader()
  reader.onload = (event) => {
    binary_data = event.target.result
  };
  reader.readAsText(scriptFile.prop("files")[0])
})

channel.on('message', payload => {

  const { uuid, strategy, script } = payload
  block_id = uuid
  query_id.text(uuid)
  query_strategy.text(strategy)
  source_div.text(script)
  create_block.hide()
  execute_block.show()

});

channel.on('user_input', payload => {
  input_div.text(script_input.val())
  script_input.val("")
  result_div.text(JSON.stringify(payload, null, '\t'))
  result_block.show()

});

export default socket












