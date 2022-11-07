<template>
  <q-form
    @submit="submit_form"
    >
    <div v-if="!is_sent" class="row">
      <div class="col-md-6 col-sm-12 q-pa-sm">
        <q-input
          filled
          v-model="form.name"
          label="Name"
          hint="Your name and surname"
          lazy-rules
          :rules="[ val => val && val.length > 0 || 'Please type something']"
        />
      </div>
      <div class="col-md-6 col-sm-12 q-pa-sm">
        <q-input
          filled
          v-model="form.company"
          label="Company"
          hint="Your company name"
        />
      </div>
      <div class="col-md-4 col-sm-12 q-pa-sm">
        <q-input
          filled
          v-model="form.email"
          label="Email address"
          hint="Your email address"
          lazy-rules
          :rules="[ val => val && val.length > 0 || 'Please type something']"
        />
      </div>
      <div class="col-md-4 col-sm-12 q-pa-sm">
        <q-input
          filled
          v-model="form.phone"
          label="Phone number"
          hint="Your phone number"
        />
      </div>
      <div class="col-md-4 col-sm-12 q-pa-sm">
        <q-input
          filled
          v-model="form.website"
          label="Website"
          hint="Your website address"
        />
      </div>
      <div class="col-sm-12 q-pa-sm">
        <q-input
          filled
          v-model="form.message"
          label="Your message"
          hint="Contact message"
          lazy-rules
          type="textarea"
          :rules="[ val => val && val.length > 3 || 'Please type something']"
        />
      </div>
      <div class="col-sm-12 q-pa-sm">
        <q-btn label="Submit" type="submit" color="primary" />
      </div>
    </div>
    <div v-else>
      <q-banner class="bg-primary text-white">
        Your message has been sent
      </q-banner>
    </div>
  </q-form>
</template>

<script>
export default {
  name: 'ContactForm',
  methods: {
    submit_form() {
      this.$socket.send(JSON.stringify({
        action: 'submit_contact_form',
        data: this.form
      }));
      this.is_sent = true;
    }
  },
  data: () => ({
    is_sent: false,
    form: {
      name: '',
      email: '',
      website: '',
      phone: '',
      company: '',
      message: ''
    }
  }),
  setup () {
    return {}
  }
}
</script>
