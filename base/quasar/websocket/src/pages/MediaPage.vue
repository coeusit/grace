<template>
  <q-page style="max-width: 680px; margin-left: auto; margin-right: auto;" padding>
    <q-dialog full-height full-width v-model="zoom_dialog">
      <q-card class="full-height">
        <q-card-section>
          <q-img :src="zoom_image" fit="fill"/>
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat label="OK" color="primary" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <div class="row">
      <div class="col-xs-12">
        <q-file multiple filled bottom-slots v-model="new_files" label="Upload Files" counter>

          <template v-slot:append>
            <q-icon v-if="new_files !== null" name="close" @click.stop.prevent="new_files = []" class="cursor-pointer" />
          </template>

          <template v-slot:after>
            <q-btn round dense flat icon="send" @click="upload_files" />
          </template>
        </q-file>
      </div>
      <div class="col-xs-12">
        <q-card>
          <q-card-section>
            <q-list bordered separator>
              <q-item v-ripple v-for="ma in media_assets" :key="ma.id">
                <q-item-section thumbnail>
                  <img :src="ma.file_uri">
                </q-item-section>
                <q-item-section>{{ ma.filename }}</q-item-section>
                <q-item-section side>
                  <div class="text-grey-8 q-gutter-xs">
                    <q-btn @click="delete_file(ma.filename)" class="gt-xs" size="12px" flat dense round icon="delete" />
                    <q-btn @click="zoom_image = ma.file_uri; this.zoom_dialog = true" class="gt-xs" size="12px" flat dense round icon="image" />
                    <q-btn @click="open_window(ma.file_uri)" class="gt-xs" size="12px" flat dense round icon="send" />
                  </div>
                </q-item-section>
              </q-item>
            </q-list>
          </q-card-section>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script>
import { mapRepos, useRepo } from 'pinia-orm'
import MediaAsset from '../stores/orm/MediaAsset'

export default {
  name: 'MediaPage',
  data: () => ({
    new_files: [],
    zoom_image: null,
    zoom_dialog: false
  }),
  methods: {
    open_window(uri) {
      window.open(uri, '_blank');
    },
    delete_file(filename) {
      this.$socket.send(JSON.stringify({
        action: 'delete_media_asset',
        data: {
          filename: filename
        }
      }));
    },
    upload_files() {
      this.new_files.forEach(f => {
        const reader = new FileReader();
        let _filename = f.name;
        let _content;
        let _this = this;
        reader.onload = function() {
          _content = reader.result;
          _this.$socket.send(JSON.stringify({
            action: 'upload_media_asset',
            data: {
              filename: _filename,
              content: btoa(_content)
            }
          }));
        }
        reader.readAsBinaryString(f);
      });
      this.new_files = [];
    }
  },
  computed: {
    ...mapRepos({
      mediaRepo: MediaAsset
    }),
    media_assets() {
      return this.mediaRepo.all();
    }
  }
}
</script>
