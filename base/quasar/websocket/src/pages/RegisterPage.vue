<template>
  <q-page style="max-width: 680px; margin-left: auto; margin-right: auto;" class="flex flex-center">
    <q-card class="q-pa-md" style="max-width: 600px">
      <q-card-section>
        <RegisterForm/>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import { defineComponent } from 'vue'
import RegisterForm from 'components/RegisterForm.vue'

export default defineComponent({
  name: 'RegisterPage',

  components: {
    RegisterForm
  }
})
</script>
