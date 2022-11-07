<template>
  <q-page style="max-width: 680px; margin-left: auto; margin-right: auto;" padding>
    <q-btn @click="send_test_email" label="Test Email" />
  </q-page>
</template>

<script>
export default {
  name: 'PageName',
  methods: {
    send_test_email() {
      this.$socket.send(JSON.stringify({
        action: 'smtp_test'
      }))
    }
  }
}
</script>
