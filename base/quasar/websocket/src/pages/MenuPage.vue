<template>
  <q-page style="max-width: 680px; margin-left: auto; margin-right: auto;" padding>
    <q-dialog v-model="editing_dialog" persistent>
      <q-card>
        <q-card-section>
          <div class="text-h6">{{ editing_item.uuid == null ? 'New menu item' : 'Editing menu item' }}</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-form class="text-center q-pa-md row items-start">
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="Caption" dense v-model="editing_item.caption" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="Subtitle" dense v-model="editing_item.subtitle" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="URI" dense v-model="editing_item.uri" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="Icon" dense v-model="editing_item.icon" />
            </div>
            <div class="col-12 col-sm-4 q-pa-sm">
              <q-select map-options outlined v-model="editing_item.parent_id" option-value="value" option-label="label" :options="parent_options" label="Parent item" />
            </div>
            <div class="col-12 col-sm-4 q-pa-sm">
              <q-input label="Index" dense v-model="editing_item.sorted_order" />
            </div>
            <div class="col-12 col-sm-4 q-pa-sm">
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
          title="Menu Items"
          :rows="menu_items"
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
import MenuItem from '../stores/orm/MenuItem'

export default {
  name: 'MenuPage',

  data: () => ({
    editing_item: null,
    editing_dialog: false,
    columns: [
      { name: 'options', label: 'Options' },
      { name: 'caption', field: 'caption', label: 'Caption', sortable: true },
      { name: 'uri', field: 'uri', label: 'URI', sortable: true },
      { name: 'parent', field: 'parent', label: 'Parent', sortable: true },
      { name: 'public', field: 'public', label: 'Public' }
    ]
  }),
  methods: {
    delete_item(uuid) {
      this.$socket.send(JSON.stringify({
        action: 'delete_menu_item',
        data: {
          uuid: uuid
        }
      }));
    },
    new_item() {
      this.editing_item = {
        uuid: null,
        parent_id: null,
        uri: null,
        caption: null,
        sorted_order: null,
        subtitle: null,
        icon: null,
        public: false
      };
      this.editing_dialog = true;
    },
    edit_item(uuid) {
      let u = useRepo(MenuItem).with('parent').where('uuid', uuid).first();
      this.editing_item = {
        uuid: u.uuid,
        parent_id: (u.parent != null ? { value: u.parent_id, label: u.parent.caption } : null),
        uri: u.uri,
        caption: u.caption,
        sorted_order: u.sorted_order,
        subtitle: u.subtitle,
        icon: u.icon,
        public: u.public
      };
      this.editing_dialog = true;
    },
    save_item() {
      let ei = this.editing_item;
      if (ei.parent_id != null) {
        ei.parent_id = ei.parent_id.value;
      }
      this.$socket.send(JSON.stringify({
        action: 'save_menu_item',
        data: ei
      }));
      this.editing_dialog = false;
    }
  },
  computed: {
    ...mapRepos({
      menuRepo: MenuItem
    }),
    parent_options() {
      let _mi = Array({
        label: 'None',
        value: null
      });
      this.menuRepo.all().forEach((mi) => {
        _mi.push({
          label: mi.caption,
          value: mi.uuid
        });
      });
      return _mi;
    },
    menu_items() {
      let _mi = Array();
      this.menuRepo.with('parent').orderBy('parent_id','desc').orderBy('sorted_order').get().forEach((mi) => {
        _mi.push({
          uuid: mi.uuid,
          caption: mi.caption,
          uri: mi.uri,
          sorted_order: mi.sorted_order,
          parent: (mi.parent == null ? null : mi.parent.caption),
          public: mi.public
        });
      });
      return _mi;
    }
  }
}
</script>
