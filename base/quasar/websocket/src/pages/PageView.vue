<template>
  <q-page>
    <div v-if="page != null">
      <q-card v-if="session.editing" class="q-pa-md q-mb-md">
        <q-card-section>
          <q-btn @click="add_component" label="New Component" outline unelevated />
        </q-card-section>
      </q-card>
      <div class="row">
        <VuePageComponent
          v-for="vpc in page_components"
          :key="vpc.uuid"
          :uuid="vpc.uuid"
          />
      </div>
    </div>
    <div v-else class="text-center q-pa-md flex flex-center">
      <div>
        <div style="font-size: 30vh">
          404
        </div>

        <div class="text-h2" style="opacity:.4">
          Page Not Found
        </div>

        <div class="text-h3" style="opacity:.4">
          Requested URI: {{ Array.isArray($route.params.uri) ? $route.params.uri.join('/') : '' }}
        </div>

        <q-btn
          class="q-mt-xl"
          unelevated
          outline
          to="/"
          label="To index"
          no-caps
        />
      </div>
    </div>
  </q-page>
</template>

<script>
import { useSessionStore } from '../stores/session'
import { mapRepos } from 'pinia-orm'
import Page from '../stores/orm/Page'
import PageComponent from '../stores/orm/PageComponent'
import VuePageComponent from '../components/VuePageComponent.vue'

export default {
  setup () {
    const session = useSessionStore();

    return {
      session
    }
  },
  methods: {
    add_component() {
      this.$socket.send(JSON.stringify({
        action: 'save_page_component',
        data: {
          page_id: this.page.uuid,
          sorted_order: this.page_components.length
        }
      }));
    }
  },
  name: 'PageView',
  components: {
    VuePageComponent
  },
  computed: {
    ...mapRepos({
      pageRepo: Page,
      pcRepo: PageComponent
    }),
    page_components() {
      return this.pcRepo.where('page_id', this.page.uuid).orderBy('sorted_order').get();
    },
    page() {
      return (Array.isArray(this.$route.params.uri) ? this.pageRepo.where('uri', this.$route.params.uri.join('/')).first() : this.pageRepo.where('uri', '').first());
    }
  }
}
</script>
