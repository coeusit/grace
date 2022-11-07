<template>
  <div>
    <q-dialog v-model="dialog_add_display" persistent>
      <q-card style="min-width: 350px">
        <q-card-section>
          <div class="text-h6">Scan the QR code below on your authenticator app to add your account.</div>
        </q-card-section>

        <q-card-section v-if="session.otp_uri != null" class="text-center">
          <qrcode-vue :size="250" :value="session.otp_uri"/>
          <div>
            Alternatively you can copy the OTP key below.
          </div>
          <q-input readonly v-model="session.otp_secret">
            <template v-slot:append>
              <q-icon
                name="content_copy"
                tooltip="Copy to clipboard"
                class="cursor-pointer"
                @click="copy_secret"
              />
            </template>
          </q-input>
        </q-card-section>

        <q-card-section>
          <div class="text-h6">Next, enter your OTP code below and click Enable.</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-input label="OTP code" dense v-model="otp_code" autofocus @keyup.enter="enable_otp" />
        </q-card-section>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="Cancel" @click="setup_dialog = false" />
          <q-btn flat label="Enable" @click="enable_otp" />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-dialog v-model="dialog_disable_display" persistent>
      <q-card style="min-width: 350px">
        <q-card-section>
          <div class="text-h6">To disable OTP security, enter your OTP code below and click Disable.</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-input label="OTP code" dense v-model="otp_code" autofocus @keyup.enter="disable_otp" />
        </q-card-section>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="Cancel" @click="disable_dialog = false" />
          <q-btn flat label="Disable" @click="disable_otp" />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <div v-if="!otp_enabled">
      <q-banner inline-actions class="text-white bg-red q-mb-sm">
        OTP is <b>not</b> enabled on your account.
      </q-banner>
      <q-btn outline class="full-width" label="Enable OTP" @click="open_setup_dialog" />
    </div>
    <div v-else>
      <q-banner inline-actions class="text-white bg-green q-mb-sm">
        OTP is enabled on your account.
      </q-banner>
      <q-btn outline class="full-width" label="Disable OTP" @click="open_disable_dialog" />
    </div>
  </div>
</template>

<script>
import { copyToClipboard, Notify } from 'quasar'
import { useSessionStore } from '../stores/session'
import QrcodeVue from 'qrcode.vue'

export default {
  name: 'OtpSetup',
  setup () {
    const session = useSessionStore()

    return {
      session
    }
  },
  computed: {
    otp_enabled() {
      return this.session.otp_enabled;
    },
    dialog_disable_display() {
      return this.disable_dialog && this.session.otp_enabled
    },
    dialog_add_display() {
      return this.setup_dialog && !this.session.otp_enabled
    }
  },
  components: {
    QrcodeVue
  },
  methods: {
    copy_secret() {
      copyToClipboard(this.session.otp_secret);
      Notify.create({
        message: 'Copied to memory',
        color: 'primary'
      });
    },
    disable_otp() {
      this.$socket.send(JSON.stringify({
        action: 'disable_otp',
        data: {
          otp_attempt: this.otp_code
        }
      }));
    },
    enable_otp() {
      this.$socket.send(JSON.stringify({
        action: 'register_otp',
        data: {
          otp_secret: this.session.otp_secret,
          otp_attempt: this.otp_code
        }
      }))
    },
    open_setup_dialog() {
      this.session.otp_uri = null;
      this.session.otp_secret = null;
      this.setup_dialog = true;
      this.otp_code = '';
      this.$socket.send(JSON.stringify({
        action: 'generate_otp'
      }));
    },
    open_disable_dialog() {
      this.otp_code = '';
      this.disable_dialog = true;
    }
  },
  data: () => ({
    otp_code: '',
    setup_dialog: false,
    disable_dialog: false
  })
}
</script>
