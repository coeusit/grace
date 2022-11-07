<template>
  <q-layout view="lHh Lpr lFf">
    <q-page-container v-if="session.initialized">
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useSessionStore } from '../stores/session'
import { storeToRefs } from 'pinia'

export default defineComponent({
  name: 'MainLayout',

  setup () {
    const router = useRouter()
    const session = useSessionStore()
    const { requireOtp } = storeToRefs(session)

    watch(() => requireOtp.value, (requireOtp) => {
      if (!requireOtp) {
        router.push('/')
      }
    })

    if (requireOtp.value == false) {
      router.push('/')
    }

    return {
      session
    }
  }
})
</script>
