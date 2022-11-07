import { defineStore } from 'pinia'

export const useSessionStore = defineStore('session', {
  state: () => ({
    otp_enabled: false,
    otp_passed: false,
    admin: false,
    email: null,
    first_name: null,
    locale: null,
    user_id: null,
    editing: false,
    city_suggestions: Array(),
    register_status: 0,
    redirect: null,
    initialized: false,
    otp_secret: null,
    otp_uri: null
  }),

  getters: {
    isAdmin (state) {
      return state.admin
    },
    isAuthenticated (state) {
      return (state.user_id == null ? false : true)
    },
    requireOtp (state) {
      return state.otp_enabled && !state.otp_passed
    }
  },

  actions: {
    setId (_id) {
      this.id = _id
    }
  }
})
