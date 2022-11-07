<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated v-if="session.initialized">
      <q-toolbar>
        <q-btn
          flat
          dense
          round
          icon="menu"
          aria-label="Menu"
          @click="toggleLeftDrawer"
        />

        <q-toolbar-title>
          Grace for Quasar
        </q-toolbar-title>

        <q-btn v-if="session.user_id != null" dense flat round icon="menu" @click="toggleRightDrawer" />
        <q-btn v-if="session.user_id == null" dense flat round icon="login" to="/login" />
      </q-toolbar>
    </q-header>

    <q-drawer
      v-model="leftDrawerOpen"
      show-if-above
      bordered
      v-if="session.initialized"
    >
      <q-list>
        <template v-for="(link, linkIndex) in essentialLinks">
          <q-item
            v-if="link.children.length == 0"
            :key="linkIndex"
            clickable
            tag="a"
            :to="link.uri"
          >
            <q-item-section
              v-if="link.icon"
              avatar
            >
              <q-icon :name="link.icon" />
            </q-item-section>

            <q-item-section>
              <q-item-label>{{ link.caption }}</q-item-label>
              <q-item-label caption>{{ link.subtitle }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-expansion-item
            v-else
            :key="'l'+linkIndex"
            expand-separator
            :icon="link.icon"
            :label="link.caption"
            :caption="link.subtitle"
            :content-inset-level="0.5"
            >
            <template v-for="(sl, slIndex) in link.children">
              <q-item
                v-if="sl.children.length == 0"
                clickable
                :key="slIndex"
                tag="a"
                :to="sl.uri"
              >
                <q-item-section
                  v-if="sl.icon"
                  avatar
                >
                  <q-icon :name="sl.icon" />
                </q-item-section>

                <q-item-section>
                  <q-item-label>{{ sl.caption }}</q-item-label>
                  <q-item-label caption>{{ sl.subtitle }}</q-item-label>
                </q-item-section>
              </q-item>
              <q-expansion-item
                v-else
                :key="'sl'+slIndex"
                expand-separator
                :icon="sl.icon"
                :label="sl.caption"
                :caption="sl.subtitle"
                :content-inset-level="0.5"
                >
                <q-item
                  v-for="(ssl, sslIndex) in sl.children"
                  clickable
                  :key="sslIndex"
                  tag="a"
                  :to="ssl.uri"
                >
                  <q-item-section
                    v-if="ssl.icon"
                    avatar
                  >
                    <q-icon :name="ssl.icon" />
                  </q-item-section>

                  <q-item-section>
                    <q-item-label>{{ ssl.caption }}</q-item-label>
                    <q-item-label caption>{{ ssl.subtitle }}</q-item-label>
                  </q-item-section>
                </q-item>
              </q-expansion-item>
            </template>
          </q-expansion-item>
        </template>
      </q-list>
    </q-drawer>
    <q-drawer v-if="session.initialized && session.user_id != null" show-if-above v-model="rightDrawerOpen" side="right" bordered>
      <SideBar/>
    </q-drawer>

    <q-page-container v-if="session.initialized">
      <router-view />
    </q-page-container>
    <q-page-container v-if="!session.initialized">
      <div style="max-width: 680px; margin-left: auto; margin-right: auto;" class="text-center">
        <q-spinner
          color="primary"
          class="q-ma-lg"
          size="80%"
          :thickness="1"
        />
      </div>
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useSessionStore } from '../stores/session'
import { storeToRefs } from 'pinia'
import { mapRepos } from 'pinia-orm'
import SideBar from '../components/SideBar.vue'
import MenuItem from '../stores/orm/MenuItem'

export default defineComponent({
  name: 'MainLayout',

  setup () {
    const router = useRouter()
    const leftDrawerOpen = ref(false)
    const rightDrawerOpen = ref(false)
    const session = useSessionStore()
    const { requireOtp } = storeToRefs(session)

    watch(() => requireOtp.value, (requireOtp) => {
      if (requireOtp) {
        router.push('/otp')
      }
    })

    if (requireOtp.value == true) {
      router.push('/otp')
    }

    return {
      session,
      requireOtp,
      leftDrawerOpen,
      toggleLeftDrawer () {
        leftDrawerOpen.value = !leftDrawerOpen.value
      },
      rightDrawerOpen,
      toggleRightDrawer () {
        rightDrawerOpen.value = !rightDrawerOpen.value
      }
    }
  },
  computed: {
    ...mapRepos({
      menuRepo: MenuItem
    }),
    essentialLinks() {
      return this.menuRepo.where('parent_id', null).orderBy('sorted_by').with('children', (query) => {
        query.with('children')
      }).get();
    }
  },
  components: {
    SideBar
  }
})
</script>
