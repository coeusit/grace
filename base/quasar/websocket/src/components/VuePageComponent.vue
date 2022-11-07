<template>
  <div :style="(params.boxed == true ? 'max-width: 1000px; margin-left: auto; margin-right: auto;' : '')" :class="params.container_classes.join(' ')">
    <q-dialog v-model="confirm.delete" persistent>
      <q-card>
        <q-card-section class="row items-center">
          <q-avatar icon="delete" color="primary" text-color="white" />
          <span class="q-ml-sm">Are you sure you want to delete this component?</span>
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat label="Cancel" color="primary" v-close-popup />
          <q-btn flat label="Delete" color="primary" @click="delete_component" />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-dialog v-model="settings_dialog" persistent>
      <q-card>
        <q-card-section class="row items-center">
          <q-form>
            <div class="row">
              <div class="col-12">
                Container classes
              </div>
              <div v-for="cco in container_class_options" :key="cco" class="col-xs-12 col-sm-6 col-md-3">
                <q-checkbox v-model="params.container_classes" :val="cco" :label="cco" />
              </div>
            </div>
            <div class="row">
              <div class="col-12">
                Content classes
              </div>
              <div v-for="cco in content_class_options" :key="cco" class="col-xs-12 col-sm-6 col-md-3">
                <q-checkbox v-model="params.content_classes" :val="cco" :label="cco" />
              </div>
            </div>
            <div class="row">
              <div class="col-12">
                Component settings
              </div>
              <div class="col-xs-12 col-sm-6 col-md-3">
                <q-checkbox v-model="params.boxed" label="Boxed" />
              </div>
              <div class="col-xs-12 col-sm-6 col-md-3">
                <q-checkbox v-model="params.card" label="Card" />
              </div>
              <div class="col-xs-12 col-sm-6">
                <q-select class="q-mb-sm" outlined v-model="params.type" :options="component_types" label="Type" />
              </div>
            </div>
            <div class="row" v-if="params.type == 'image'">
              <div class="col-12">
                Image Settings
              </div>
              <div class="col-xs-12 col-sm-6 q-pa-sm">
                <q-select class="q-mb-sm" outlined v-model="params.fit_type" :options="image_fit_types" label="Fit Type" />
              </div>
              <div class="col-xs-12 col-sm-6 q-pa-sm">
                <q-select class="q-mb-sm" outlined v-model="params.uri" map-options emit-value :options="image_names" label="Image File" />
              </div>
            </div>
            <div class="row" v-if="params.type == 'agile'">
              <div class="col-12">
                Agile Settings
              </div>
              <div class="col-xs-12 col-sm-6 q-pa-sm">
                <q-select class="q-mb-sm" outlined v-model="params.slides" map-options emit-value :options="image_names" label="Slides" multiple />
              </div>
            </div>
            <div class="row" v-if="params.type == 'codeblock'">
              <div class="col-12">
                Codeblock Settings
              </div>
              <div class="col-xs-12 col-sm-6 q-pa-sm">
                <q-select class="q-mb-sm" outlined v-model="params.language" :options="code_languages" label="Languages" />
              </div>
            </div>
            <div class="row" v-if="params.type == 'supportchat'">
              <div class="col-12">
                Supportchat Settings
              </div>
              <div class="col-xs-12 col-sm-6 q-pa-sm">
                <q-input class="q-mb-sm" outlined v-model="params.height" label="Height (px)" />
              </div>
            </div>
          </q-form>
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat label="Close" color="primary" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-card v-if="session.editing || params.card" :class="params.content_classes.join(' ')">
      <q-card-section v-if="session.editing">
        <div class="row">
          <div class="col-xs-12">
            <q-btn class="float-right q-ml-sm q-mb-sm" label="Save" @click="save_changes" outline unelevated />
            <q-btn class="float-right q-ml-sm q-mb-sm" @click="settings_dialog = true" label="Settings" outline unelevated />
            <q-btn class="float-right q-ml-sm q-mb-sm" @click="confirm.delete = true" label="Delete" outline unelevated />
            <q-btn @click="move_down" v-if="pc.sorted_order < pc.page.page_components.length - 1" square class="float-right q-ml-sm q-mb-sm" color="primary" icon="expand_more" />
            <q-btn @click="move_up" v-if="pc.sorted_order > 0" square class="float-right q-ml-sm q-mb-sm" color="primary" icon="expand_less" />
          </div>
        </div>
      </q-card-section>
      <q-card-section v-if="params.type == 'text' && params.card && !session.editing">
        <div v-html="params.content">
        </div>
      </q-card-section>
      <q-card-section v-if="params.type == 'text' && params.card && session.editing">
        <TiptapEditor v-model="params.content" />
      </q-card-section>
      <q-card-section v-if="params.type == 'contactform' && params.card">
        <ContactForm />
      </q-card-section>
      <q-card-section v-if="params.type == 'codeblock' && params.card && !session.editing">
        <pre v-highlightjs="params.content"><code :class="params.language"></code></pre>
      </q-card-section>
      <q-card-section v-if="params.type == 'codeblock' && params.card && session.editing">
        <q-input v-model="params.content" outlined type="textarea"/>
      </q-card-section>
      <q-card-section v-if="params.type == 'image' && params.card">
        <div v-if="params.type == 'image' && params.uri != undefined && params.uri != null">
          <q-img :src="params.uri" :fit="params.fit_type"/>
        </div>
      </q-card-section>
      <q-card-section v-if="params.type == 'supportchat' && params.card">
        <div v-if="params.type == 'supportchat' && params.height != undefined && params.height != null">
          <MessageWindow :height="params.height" :user_id="session.user_id"/>
        </div>
      </q-card-section>
      <q-card-section v-if="params.type == 'agile' && params.card && Array.isArray(params.slides)">
        <agile>
          <div class="slide" v-for="slide in params.slides" :key="slide">
            <img :src="slide" >
          </div>
        </agile>
      </q-card-section>
    </q-card>
    <div v-if="!params.card" :class="params.content_classes.join(' ')">
      <div v-if="params.type == 'text' && !session.editing" v-html="params.content">
      </div>
      <div v-if="params.type == 'text' && session.editing">
        <TiptapEditor v-model="params.content" />
      </div>
      <div v-if="params.type == 'contactform'">
        <ContactForm />
      </div>
      <div v-if="params.type == 'codeblock' && !session.editing">
        <pre v-highlightjs="params.content"><code :class="params.language"></code></pre>
      </div>
      <div v-if="params.type == 'codeblock' && session.editing">
        <q-input v-model="params.content" outlined type="textarea"/>
      </div>
      <div v-if="params.type == 'image' && params.uri != undefined && params.uri != null">
        <q-img :src="params.uri" :fit="params.fit_type"/>
      </div>
      <div v-if="params.type == 'supportchat' && params.height != undefined && params.height != null">
        <MessageWindow :height="params.height" :user_id="session.user_id"/>
      </div>
      <div v-if="params.type == 'agile' && !params.card && Array.isArray(params.slides)">
        <agile>
          <div class="slide" v-for="slide in params.slides" :key="slide">
            <q-img :src="slide" fit="fill"/>
          </div>
        </agile>
      </div>
    </div>
  </div>
</template>

<script>
import ContactForm from './ContactForm.vue'
import MessageWindow from './MessageWindow.vue'
import TiptapEditor from './TiptapEditor.vue'
import { useSessionStore } from '../stores/session'
import { mapRepos } from 'pinia-orm'
import PageComponent from '../stores/orm/PageComponent'
import MediaAsset from '../stores/orm/MediaAsset'

export default {
  name: 'VuePageComponent',
  setup () {
    const session = useSessionStore();

    return {
      session
    }
  },
  components: {
    TiptapEditor,
    ContactForm,
    MessageWindow
  },
  data: () => ({
    code_languages: [
      'c',
      'cpp',
      'csharp',
      'css',
      'javascript',
      'json',
      'php',
      'python',
      'ruby',
      'sql',
      'xml',
      'yaml'
    ],
    image_fit_types: [
      'cover', 'fill', 'contain', 'none', 'scale-down'
    ],
    component_types: [
      'text',
      'image',
      'agile',
      'codeblock',
      'supportchat',
      'contactform'
    ],
    content_class_options: [
      'q-pa-xs',
      'q-pa-sm',
      'q-pa-md',
      'q-pa-lg',
      'q-ma-xs',
      'q-ma-sm',
      'q-ma-md',
      'q-ma-lg',
      'q-mt-xs',
      'q-mt-sm',
      'q-mt-md',
      'q-mt-lg',
      'q-mb-xs',
      'q-mb-sm',
      'q-mb-md',
      'q-mb-lg'
    ],
    container_class_options: [
      'col-xs-3',
      'col-xs-4',
      'col-xs-6',
      'col-xs-8',
      'col-xs-12',
      'col-sm-3',
      'col-sm-4',
      'col-sm-6',
      'col-sm-8',
      'col-sm-12',
      'col-md-3',
      'col-md-4',
      'col-md-6',
      'col-md-8',
      'col-md-12',
      'col-lg-3',
      'col-lg-4',
      'col-lg-6',
      'col-lg-8',
      'col-lg-12',
      'col-xl-3',
      'col-xl-4',
      'col-xl-6',
      'col-xl-8',
      'col-xl-12'
    ],
    params: {
      container_classes: [],
      content_classes: []
    },
    settings_dialog: false,
    confirm: {
      delete: false
    }
  }),
  methods: {
    set_params(json) {
      let parsed = JSON.parse(json);
      if (parsed == null) {
        parsed = {};
      }
      if (parsed.container_classes == undefined || !Array.isArray(parsed.container_classes)) {
        parsed.container_classes = [];
      }
      if (parsed.content_classes == undefined || !Array.isArray(parsed.content_classes)) {
        parsed.content_classes = [];
      }
      if (parsed.boxed == undefined) {
        parsed.boxed = false;
      }
      if (parsed.card == undefined) {
        parsed.card = false;
      }
      this.params = parsed;
    },
    delete_component() {
      this.confirm.delete = false;
      this.$socket.send(JSON.stringify({
        action: 'delete_page_component',
        data: {
          uuid: this.uuid
        }
      }))
    },
    move_down() {
      this.$socket.send(JSON.stringify({
        action: 'move_component_down',
        data: {
          uuid: this.uuid
        }
      }));
    },
    move_up() {
      this.$socket.send(JSON.stringify({
        action: 'move_component_up',
        data: {
          uuid: this.uuid
        }
      }));
    },
    save_changes() {
      this.$socket.send(JSON.stringify({
        action: 'save_page_component',
        data: {
          uuid: this.uuid,
          sorted_order: this.pc.sorted_order,
          page_id: this.pc.page_id,
          parameters: JSON.stringify(this.params)
        }
      }))
    }
  },
  props: [
    'uuid'
  ],
  computed: {
    ...mapRepos({
      pcRepo: PageComponent,
      maRepo: MediaAsset
    }),
    pc() {
      return this.pcRepo.withAllRecursive().find(this.uuid);
    },
    media_assets() {
      return this.maRepo.all();
    },
    image_names() {
      let a = Array();
      this.media_assets.forEach((ma) => {
        a.push({
          label: ma.filename,
          value: ma.file_uri
        });
      });
      return a;
    }
  },
  mounted() {
    if (this.pc != null) {
      this.set_params(this.pc.parameters);
    }
  },
  watch: {
    pc(_nv) {
      if (_nv != null) {
        this.set_params(_nv.parameters);
      }
    }
  }
}
</script>
