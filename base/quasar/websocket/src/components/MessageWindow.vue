<template>
  <div>
    <div v-if="session.user_id == null">
      <q-banner class="q-mt-sm bg-primary text-white">
        You aren't currently logged in. Create an account or log in to submit a contact request.
        <template v-slot:action>
          <q-btn flat color="white" label="Register" to="/register" />
          <q-btn flat color="white" label="Log in" to="/login" />
        </template>
      </q-banner>
    </div>
    <div v-else>
      <q-card class="q-mt-sm">
        <q-card-section>
          <div v-if="support_messages.length > 0">
            <q-scroll-area ref="chatScroll" @scroll="scroll_update" :style="`height: ${height}px;`">
              <q-chat-message
                v-for="m in support_messages"
                :text="[m.content]"
                :stamp="m.sent_at"
                :name="(m.outgoing ? 'Support' : m.user.first_name)"
                :sent="!m.outgoing"
                :key="m.uuid"
              />
            </q-scroll-area>
          </div>
          <div v-else>
            <q-banner class="q-mt-sm bg-primary text-white">
              You do not have a message history yet. Send a message to start talking.
            </q-banner>
          </div>
          <div>
            <q-input @keydown.enter.prevent="send_message" class="q-mt-sm" outlined v-model="new_msg" label="Your message" />
          </div>
        </q-card-section>
      </q-card>
    </div>
  </div>
</template>

<script>
import { useSessionStore } from '../stores/session'
import { mapRepos } from 'pinia-orm'
import SupportMessage from '../stores/orm/SupportMessage'

export default {
  name: 'MessageWindow',
  props: [
    'user_id',
    'height'
  ],
  data: () => ({
    scroll_max: 0,
    new_msg: ''
  }),
  watch: {
    scroll_max() {
      this.$refs.chatScroll.setScrollPercentage('vertical', 1.0);
    }
  },
  methods: {
    scroll_update(info) {
      this.scroll_max = info.verticalSize;
    },
    send_message() {
      this.$socket.send(JSON.stringify({
        action: 'send_message',
        data: {
          message: this.new_msg,
          user_id: this.user_id
        }
      }));
      this.new_msg = '';
    }
  },
  computed: {
    ...mapRepos({
      messageRepo: SupportMessage
    }),
    support_messages() {
      return this.messageRepo.with('user').where('user_id', this.user_id).orderBy('sent_at').get();
    }
  },
  setup () {
    const session = useSessionStore();

    return {
      session
    }
  }
}
</script>
