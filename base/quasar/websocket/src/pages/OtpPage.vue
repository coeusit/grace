<template>
  <q-page style="max-width: 680px; margin-left: auto; margin-right: auto;" padding>
    <q-card>
      <q-card-section>
        You need to enter your OTP code to proceed
      </q-card-section>
      <q-card-section>
        <q-input label="OTP code" dense v-model="otp_code" autofocus @keyup.enter="verify_otp" />
      </q-card-section>
      <q-card-actions align="right" class="text-primary">
        <q-btn flat label="Log out" @click="deauth" />
        <q-btn flat label="Verify" @click="verify_otp" />
      </q-card-actions>
    </q-card>
  </q-page>
</template>

<script>
export default {
  data: () => ({
    otp_code: ''
  }),
  methods: {
    verify_otp() {
      this.$socket.send(JSON.stringify({
        action: 'verify_otp',
        data: {
          otp_attempt: this.otp_code
        }
      }))
    },
    deauth() {
      this.$socket.send(JSON.stringify({
        action: 'deauth'
      }));
    }
  },
  name: 'OtpPage'
}
</script>
