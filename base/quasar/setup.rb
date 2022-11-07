conn_method = ask('Connection method? [(W)ebsocket, (r)EST (in development)] ').downcase == 'r' ? 'rest' : 'websocket'
if conn_method == 'websocket'
  ws_domain = ask('Production domain? ')
  ws_port = ask('Websocket port? [42001] ').to_i
  if ws_port == 0
    ws_port = 42001
  end
  plugins = [
    '@babel/core',
    '@babel/eslint-parser',
    '@babel/preset-env',
    '@babel/preset-typescript',
    '@tiptap/starter-kit',
    '@tiptap/vue-3',
    'tiptap/extension-bubble-menu',
    'js-sha512',
    'pinia-orm',
    'qrcode.vue',
    'uuid',
    'vue-agile',
    'vue-native-websocket-vue3',
    'vue3-highlightjs'
  ]
  tmpl_path = "#{File.dirname(__FILE__)}/files"
  yarn
  system("yarn add #{plugins.join(' ')}")
  FileUtils.cp_r("#{tmpl_path}/.","./")
  src = File.read('./src/boot/websocket.js')
  src.gsub!('#domain', ws_domain)
  src.gsub!('#port', ws_port)
  File.open('./src/boot/websocket.js', 'w') {|f| f.puts src }
  @logger.info 'Quasar package installed'
else
  @logger.info "The REST client is under revision"
end
