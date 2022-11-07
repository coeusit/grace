<template>
  <q-form class="text-center q-gutter-md">
    <div class="row">
      <div class="col-xs-12">
        <q-input v-model="email" outlined label="Email"/>
        <q-input class="q-my-sm" v-model="password" :type="pwdVisible ? 'text' : 'password'" outlined label="Password">
          <template v-slot:append>
            <q-icon :name="pwdVisible ? 'visibility' : 'visibility_off'" class="cursor-pointer" @click="pwdVisible = !pwdVisible"/>
          </template>
        </q-input>
      </div>
      <div class="col-xs-12">
        <q-btn class="q-my-md" size="lg" outlined unelevated color="primary" label="Login" @click="send_login"/>
      </div>
      <div class="col-xs-12">
        <q-btn size="md"  outlined unelevated label="Register an Account" to="/register"/>
      </div>
    </div>
  </q-form>
</template>

<script>
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'LoginForm',
  methods: {
    send_login: function() {
      this.$socket.send(JSON.stringify({
        action: 'authenticate_user',
        data: {
          email: this.email,
          password: this.password
        }
      }))
    }
  },
  data: () => ({
    pwdVisible: false,
    email: '',
    password: ''
  })
})
</script>
