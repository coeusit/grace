<template>
  <q-page style="max-width: 680px; margin-left: auto; margin-right: auto;" padding>
    <q-dialog v-model="editing_dialog" persistent>
      <q-card>
        <q-card-section>
          <div class="text-h6">{{ editing_item.uuid == null ? 'New user' : 'Editing user' }}</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-form class="text-center q-pa-md row items-start">
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="Email" dense v-model="editing_item.email" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="Phone" dense v-model="editing_item.phone" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="First Name" dense v-model="editing_item.first_name" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="Last Name" dense v-model="editing_item.last_name" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="Address Line 1" dense v-model="editing_item.address_line_1" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="Address Line 2" dense v-model="editing_item.address_line_2" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="Address Line 3" dense v-model="editing_item.address_line_3" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="City" dense v-model="editing_item.city_name" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-input label="Region" dense v-model="editing_item.region_name" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-select class="q-ma-sm" outlined v-model="editing_item.country_code" map-options emit-value :options="countries" label="Country" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-toggle label="Enabled" v-model="editing_item.enabled" />
            </div>
            <div class="col-12 col-sm-6 q-pa-sm">
              <q-toggle label="Admin" v-model="editing_item.admin" />
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
          title="Users"
          :rows="users"
          :columns="columns"
          row-key="uuid"
          >
          <template v-slot:body-cell-options="scope">
            <q-td>
              <q-btn @click="edit_item(scope.row.uuid)" label="Edit" />
              <q-btn class="q-mx-sm" @click="delete_item(scope.row.uuid)" label="Delete" />
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
import User from '../stores/orm/User'
import Country from '../stores/orm/Country'

export default {
  name: 'UsersPage',

  data: () => ({
    editing_item: null,
    editing_dialog: false,
    columns: [
      { name: 'options', label: 'Options' },
      { name: 'email', field: 'email', label: 'Email', sortable: true },
      { name: 'enabled', field: 'enabled', label: 'Enabled' }
    ]
  }),
  methods: {
    delete_item(uuid) {
      this.$socket.send(JSON.stringify({
        action: 'delete_user',
        data: {
          uuid: uuid
        }
      }));
    },
    new_item() {
      this.editing_item = {
        uuid: null,
        email: null,
        first_name: null,
        last_name: null,
        phone: null,
        company: null,
        address_line_1: null,
        address_line_2: null,
        address_line_3: null,
        city_name: null,
        region_name: null,
        country_code: null,
        enabled: false,
        admin: false
      };
      this.editing_dialog = true;
    },
    edit_item(uuid) {
      let u = useRepo(User).where('uuid', uuid).first();
      this.editing_item = {
        uuid: u.uuid,
        email: u.email,
        first_name: u.first_name,
        last_name: u.last_name,
        phone: u.phone,
        company: u.company,
        address_line_1: u.address_line_1,
        address_line_2: u.address_line_2,
        address_line_3: u.address_line_3,
        city_name: u.city_name,
        region_name: u.region_name,
        country_code: u.country_code,
        enabled: u.enabled,
        admin: u.admin
      };
      this.editing_dialog = true;
    },
    save_item() {
      let ei = this.editing_item;
      this.$socket.send(JSON.stringify({
        action: 'save_user',
        data: ei
      }));
      this.editing_dialog = false;
    }
  },
  computed: {
    ...mapRepos({
      userRepo: User,
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
    },
    users() {
      let _mi = Array();
      this.userRepo.all().forEach((mi) => {
        _mi.push({
          uuid: mi.uuid,
          email: mi.email,
          first_name: mi.first_name,
          last_name: mi.last_name,
          phone: mi.phone,
          company: mi.company,
          address_line_1: mi.address_line_1,
          address_line_2: mi.address_line_2,
          address_line_3: mi.address_line_3,
          city_name: mi.city_name,
          region_name: mi.region_name,
          country_code: mi.country_code,
          enabled: mi.enabled,
          admin: mi.admin
        });
      });
      return _mi;
    }
  }
}
</script>
