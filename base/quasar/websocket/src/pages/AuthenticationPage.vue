<template>
  <q-page style="max-width: 680px; margin-left: auto; margin-right: auto;" padding>
    <q-card>
      <q-card-section class="row">
        <div class="col-md-6 q-pa-sm">
          <PasswordChange/>
        </div>
        <div class="col-md-6 q-pa-sm">
          <OtpSetup/>
        </div>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import PasswordChange from 'components/PasswordChange.vue'
import OtpSetup from 'components/OtpSetup.vue'

export default {
  name: 'AuthenticationPage',
  components: {
    PasswordChange,
    OtpSetup
  }
}
</script>
