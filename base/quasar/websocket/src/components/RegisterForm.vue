<template>
  <q-form class="text-center q-gutter-md">
    <div class="row">
      <div class="col-xs-12 col-md-6">
        <q-input class="q-ma-sm" v-model="email" outlined label="Email"/>
      </div>
      <div class="col-xs-12 col-md-6">
        <q-input class="q-ma-sm" v-model="password" :type="pwdVisible ? 'text' : 'password'" outlined label="Password">
          <template v-slot:append>
            <q-icon :name="pwdVisible ? 'visibility' : 'visibility_off'" class="cursor-pointer" @click="pwdVisible = !pwdVisible"/>
          </template>
        </q-input>
      </div>
      <div class="col-xs-12 col-md-6">
        <q-input class="q-ma-sm" outlined v-model="first_name" label="First Name" />
      </div>
      <div class="col-xs-12 col-md-6">
        <q-input class="q-ma-sm" outlined v-model="last_name" label="Last Name" />
      </div>
      <div class="col-xs-12 col-md-6">
        <q-input class="q-ma-sm" outlined v-model="company" label="Company" />
      </div>
      <div class="col-xs-12 col-md-6">
        <q-input class="q-ma-sm" outlined v-model="phone" label="Phone" />
      </div>
      <div class="col-xs-12">
        <q-input class="q-ma-sm" outlined v-model="address_line_1" label="Address Line 1" />
      </div>
      <div class="col-xs-12">
        <q-input v-if="address_line_1 != ''" class="q-ma-sm" outlined v-model="address_line_2" label="Address Line 2" />
      </div>
      <div class="col-xs-12">
        <q-input v-if="address_line_2 != ''" class="q-ma-sm" outlined v-model="address_line_3" label="Address Line 3" />
      </div>
      <div class="col-xs-12 col-md-6">
        <q-select
          v-model="city"
          use-input
          outlined
          hide-selected
          fill-input
          class="q-ma-sm"
          input-debounce="0"
          :options="session.city_suggestions"
          @input-value="get_suggestions"
          label="City"
          />
      </div>
      <div class="col-xs-12 col-md-6">
        <q-select class="q-ma-sm" outlined v-model="country_code" map-options emit-value :options="countries" label="Country" />
      </div>
      <div v-if="session.register_status == 0" class="col-xs-12">
        <q-btn class="q-my-md" size="lg" outlined unelevated color="primary" label="Register" @click="send_login"/>
      </div>
      <div v-if="session.register_status == 1" class="col-xs-12">
        <q-inner-loading :showing="true">
          <q-spinner-gears size="50px" color="primary" />
        </q-inner-loading>
      </div>
      <div v-if="session.register_status == 2" class="col-xs-12">
        <q-banner class="q-my-md bg-primary text-white">
          Your account has been registered. You can log in now.
        </q-banner>
      </div>
      <div class="col-xs-12">
        <q-btn size="md"  outlined unelevated label="Log in" to="/login"/>
      </div>
    </div>
  </q-form>
</template>

<script>
import { useSessionStore } from '../stores/session'
import { defineComponent } from 'vue'
import Country from '../stores/orm/Country'
import { mapRepos } from 'pinia-orm'

export default defineComponent({
  setup () {
    const session = useSessionStore();

    return {
      session
    }
  },
  name: 'RegisterForm',
  methods: {
    send_login() {
      this.session.register_status = 1;
      this.$socket.send(JSON.stringify({
        action: 'register_user',
        data: {
          email: this.email,
          password: this.password,
          company: this.company,
          phone: this.phone,
          first_name: this.first_name,
          last_name: this.last_name,
          address_line_1: this.address_line_1,
          address_line_2: this.address_line_2,
          address_line_3: this.address_line_3,
          city: this.city,
          country: this.country_code
        }
      }))
    },
    get_suggestions(e) {
      this.$socket.send(JSON.stringify({
        action: 'get_city_suggestions',
        data: {
          phrase: e
        }
      }));
    }
  },
  computed: {
    ...mapRepos({
      cRepo: Country
    }),
    countries() {
      let _countries = Array();
      this.cRepo.all().forEach((c) => {
        _countries.push({
          label: c.name,
          value: c.code
        })
      });
      return _countries;
    }
  },
  data: () => ({
    pwdVisible: false,
    email: '',
    password: '',
    company: '',
    phone: '',
    first_name: '',
    last_name: '',
    address_line_1: '',
    address_line_2: '',
    address_line_3: '',
    city: '',
    country_code: ''
  })
})
</script>
