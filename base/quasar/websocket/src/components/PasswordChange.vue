<template>
  <div>
    <q-dialog v-model="otp_prompt" persistent>
      <q-card style="min-width: 350px">
        <q-card-section>
          <div class="text-h6">You need to enter your OTP code to save these changes.</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-input label="OTP code" dense v-model="otp_code" autofocus @keyup.enter="submit_pwd" />
        </q-card-section>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="Cancel" v-close-popup />
          <q-btn flat label="Add address" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-input outlined :type="!show_old_password ? 'password' : 'text'" v-model="old_password" label="Old Password">
      <template v-slot:append>
        <q-icon
          :name="show_old_password ? 'visibility_off' : 'visibility'"
          class="cursor-pointer"
          @click="show_old_password = !show_old_password"
        />
      </template>
    </q-input>
    <q-input class="q-my-sm" outlined :type="!show_new_password ? 'password' : 'text'" v-model="new_password" label="New Password">
      <template v-slot:append>
        <q-icon
          :name="show_new_password ? 'visibility_off' : 'visibility'"
          class="cursor-pointer"
          @click="show_new_password = !show_new_password"
        />
      </template>
    </q-input>
    <q-btn class="full-width" outline color="primary" @click="change_pwd" label="Change Password" />
  </div>
</template>

<script>
import { useSessionStore } from '../stores/session'

export default {
  name: 'PasswordChange',
  setup () {
    const session = useSessionStore()

    return {
      session
    }
  },
  methods: {
    change_pwd() {
      if (this.session.otp_enabled) {
        this.otp_prompt = true;
        this.otp_code = ''
      } else {
        this.submit_pwd();
      }
    },
    submit_pwd() {
      this.otp_prompt = false;
      let data;
      if (this.session.otp_enabled) {
        data = {
          old_pwd: this.old_password,
          new_pwd: this.new_password,
          otp_code: this.otp_code
        };
      } else {
        data = {
          old_pwd: this.old_password,
          new_pwd: this.new_password
        };
      }
      this.$socket.send(JSON.stringify({
        action: 'change_pwd',
        data: data
      }))
    }
  },
  data: () => ({
    otp_prompt: false,
    otp_code: '',
    show_old_password: false,
    old_password: '',
    show_new_password: false,
    new_password: ''
  })
}
</script>
