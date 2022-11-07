<template>
  <q-list bordered padding>
    <q-item-label header>User Controls</q-item-label>

    <q-item clickable v-if="session.is_admin" to="/settings" v-ripple>
      <q-item-section>
        <q-item-label>Settings</q-item-label>
        <q-item-label caption>
          Your site settings
        </q-item-label>
      </q-item-section>
    </q-item>

    <q-item clickable to="/contact" v-ripple>
      <q-item-section>
        <q-item-label>Contact</q-item-label>
        <q-item-label caption>
          See your support messages
        </q-item-label>
      </q-item-section>
    </q-item>

    <q-item clickable to="/authentication" v-ripple>
      <q-item-section>
        <q-item-label>Authentication</q-item-label>
        <q-item-label caption>
          Reset your password or add OTP security
        </q-item-label>
      </q-item-section>
    </q-item>

    <q-item clickable @click="deauth" v-ripple>
      <q-item-section>
        <q-item-label>Logout</q-item-label>
        <q-item-label caption>
          End your session
        </q-item-label>
      </q-item-section>
    </q-item>

    <q-separator v-if="session.is_admin" spaced />
    <q-item-label v-if="session.is_admin" header>Admin</q-item-label>

    <q-item v-if="session.is_admin" clickable to="/email" v-ripple>
      <q-item-section>
        <q-item-label>Email</q-item-label>
        <q-item-label caption>
          Email settings
        </q-item-label>
      </q-item-section>
    </q-item>

    <q-item v-if="session.is_admin" clickable to="/contact/requests" v-ripple>
      <q-item-section>
        <q-item-label>Contact Requests</q-item-label>
        <q-item-label caption>
          Contact threads
        </q-item-label>
      </q-item-section>
    </q-item>

    <q-item v-if="session.is_admin" clickable to="/menu" v-ripple>
      <q-item-section>
        <q-item-label>Menu</q-item-label>
        <q-item-label caption>
          Menu management
        </q-item-label>
      </q-item-section>
    </q-item>

    <q-item v-if="session.is_admin" clickable to="/media" v-ripple>
      <q-item-section>
        <q-item-label>Media</q-item-label>
        <q-item-label caption>
          Media management
        </q-item-label>
      </q-item-section>
    </q-item>


    <q-item v-if="session.is_admin" clickable to="/pages" v-ripple>
      <q-item-section>
        <q-item-label>CMS</q-item-label>
        <q-item-label caption>
          Page management
        </q-item-label>
      </q-item-section>
    </q-item>


    <q-item v-if="session.is_admin" clickable to="/users" v-ripple>
      <q-item-section>
        <q-item-label>Users</q-item-label>
        <q-item-label caption>
          User account management
        </q-item-label>
      </q-item-section>
    </q-item>

    <q-item v-if="session.is_admin" tag="label" v-ripple>
      <q-item-section side top>
        <q-checkbox v-model="session.editing" />
      </q-item-section>

      <q-item-section>
        <q-item-label>Editing</q-item-label>
        <q-item-label caption>
          Enable editing on pages
        </q-item-label>
      </q-item-section>
    </q-item>
  </q-list>
</template>

<script>
import { useSessionStore } from '../stores/session'

export default {
  name: 'SideBar',
  setup () {
    const session = useSessionStore()
    return {
      session
    }
  },
  methods: {
    deauth: function() {
      this.$socket.send(JSON.stringify({
        action: 'deauth'
      }))
    }
  }
}
</script>
