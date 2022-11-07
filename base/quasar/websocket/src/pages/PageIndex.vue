<template>
  <q-page style="max-width: 680px; margin-left: auto; margin-right: auto;" padding>
    <q-dialog v-model="editing_dialog" persistent>
      <q-card>
        <q-card-section>
          <div class="text-h6">{{ editing_item.uuid == null ? 'New page' : 'Editing page' }}</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-form class="text-center q-pa-md row items-start">
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="URI" dense v-model="editing_item.uri" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-toggle label="Public" v-model="editing_item.public" />
            </div>
          </q-form>
        </q-card-section>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="Cancel" v-close-popup />
          <q-btn flat label="Save" @click="save_item" />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-card>
      <q-card-section>
        <q-table
          title="Pages"
          :rows="pages"
          :columns="columns"
          row-key="uuid"
          >
          <template v-slot:body-cell-options="scope">
            <q-td>
              <q-btn @click="edit_item(scope.row.uuid)" label="Edit" />
              <q-btn @click="delete_item(scope.row.uuid)" label="Delete" />
            </q-td>
          </template>
        </q-table>
      </q-card-section>
      <q-card-actions>
        <q-btn flat @click="new_item">Create Item</q-btn>
      </q-card-actions>
    </q-card>
  </q-page>
</template>

<script>
import { mapRepos, useRepo } from 'pinia-orm'
import Page from '../stores/orm/Page'

export default {
  name: 'PageIndex',

  data: () => ({
    editing_item: null,
    editing_dialog: false,
    columns: [
      { name: 'options', label: 'Options' },
      { name: 'uri', field: 'uri', label: 'URI', sortable: true },
      { name: 'public', field: 'public', label: 'Public' }
    ]
  }),
  methods: {
    delete_item(uuid) {
      this.$socket.send(JSON.stringify({
        action: 'delete_page',
        data: {
          uuid: uuid
        }
      }));
    },
    new_item() {
      this.editing_item = {
        uuid: null,
        uri: null,
        public: false
      };
      this.editing_dialog = true;
    },
    edit_item(uuid) {
      let u = useRepo(Page).where('uuid', uuid).first();
      this.editing_item = {
        uuid: u.uuid,
        uri: u.uri,
        public: u.public
      };
      this.editing_dialog = true;
    },
    save_item() {
      let ei = this.editing_item;
      this.$socket.send(JSON.stringify({
        action: 'save_page',
        data: ei
      }));
      this.editing_dialog = false;
    }
  },
  computed: {
    ...mapRepos({
      pageRepo: Page
    }),
    pages() {
      let _mi = Array();
      this.pageRepo.all().forEach((mi) => {
        _mi.push({
          uuid: mi.uuid,
          uri: mi.uri,
          public: mi.public
        });
      });
      return _mi;
    }
  }
}
</script>
