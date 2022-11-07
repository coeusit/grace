import VueNativeSock from "vue-native-websocket-vue3";
import { boot } from 'quasar/wrappers'
import { storeToRefs } from 'pinia'
import { useSocketStore } from 'stores/socket';

export default boot(async ({ app }) => {
  const socketStore = useSocketStore();
  let _uri = '';
  if (process.env.DEV) {
    _uri = "ws://localhost:#port"
  } else if (process.env.PROD) {
    _uri = "wss://#domain:#port"
  }
  app.use(VueNativeSock,_uri, {
    store: socketStore,
    reconnection: true,
    reconnectionAttempts: 5,
    reconnectionDelay: 3000
  });
})
