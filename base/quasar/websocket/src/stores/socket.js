import { defineStore } from 'pinia'
import { ref } from 'vue'
import {v4 as uuidv4} from 'uuid';

export const useSocketStore = defineStore('socket', () => {
  const isConnected = ref(false)
  const message = ref(null)
  const reconnectError = ref(false)
  const heartBeatInterval = ref(50000)
  const heartBeatTimer = ref(0)
  const socket = ref(null);

  function SOCKET_ONOPEN(event) {
    //app.config.globalProperties.$socket = event.currentTarget;
    this.socket = event.currentTarget;
    this.isConnected = true;
    this.heartBeatTimer = window.setInterval(() => {
      this.socket.send(JSON.stringify({
        action: 'ping'
      }));
    }, this.heartBeatInterval);
  }

  function SOCKET_ONCLOSE() {
    this.isConnected = false;
    window.clearInterval(this.heartBeatTimer);
    this.heartBeatTimer = 0;
  }

  function SOCKET_ONERROR(event) {
    console.error(event);
  }

  function SOCKET_ONMESSAGE(message) {
    this.message = {
      uuid: uuidv4(),
      content: message.data
    };
  }

  function SOCKET_RECONNECT(count) {
    console.info(`Reconnection attempt ${count}`);
  }
  function SOCKET_RECONNECT_ERROR() {
      this.reconnectError = true;
  }

  return { isConnected, message, reconnectError, heartBeatInterval, heartBeatTimer, socket, SOCKET_ONOPEN, SOCKET_ONCLOSE, SOCKET_ONERROR, SOCKET_ONMESSAGE, SOCKET_RECONNECT, SOCKET_RECONNECT_ERROR }
})
