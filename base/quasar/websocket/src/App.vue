<template>
  <router-view />
</template>

<script>
import { Notify, Cookies } from 'quasar'
import { mapState } from 'pinia'
import { useSocketStore } from 'stores/socket'
import { useSessionStore } from 'stores/session'
import { useRepo } from 'pinia-orm'
import Country from 'stores/orm/Country'
import Language from 'stores/orm/Language'
import MediaAsset from 'stores/orm/MediaAsset'
import PageComponent from 'stores/orm/PageComponent'
import Page from 'stores/orm/Page'
import MenuItem from 'stores/orm/MenuItem'
import SupportMessage from 'stores/orm/SupportMessage'
import User from 'stores/orm/User'
import { defineComponent, getCurrentInstance } from 'vue'

const resource_map = {
  countries: Country,
  languages: Language,
  media_assets: MediaAsset,
  menu_items: MenuItem,
  page_components: PageComponent,
  pages: Page,
  support_messages: SupportMessage,
  users: User
};

export default defineComponent({
  name: 'App',
  computed: {
    ...mapState(useSocketStore, ['message', 'isConnected'])
  },
  watch: {
    isConnected(_status) {
      if (_status) {
        let _d = {};
        if (Cookies.has('session_id') && Cookies.has('session_key')) {
          const _session_id = Cookies.get('session_id');
          const _session_key = Cookies.get('session_key');
          _d = {
            session_id: _session_id,
            session_key: _session_key
          };
        }
        this.$socket.send(JSON.stringify({
          action: 'init',
          data: _d
        }));
      }
    },
    message(_msg) {
      const session = useSessionStore();
      if (process.env.DEV) {
        console.log(`Message received in watch: ${_msg.uuid}: ${_msg.content}`);
      }
      let _content;
      try {
        _content = JSON.parse(_msg.content)
      } catch (e) {
          console.log('Received invalid JSON');
      }
      switch (_content['action']) {
        case 'server_error':
          Notify.create({
            message: `Server error: ${_content['response']}`,
            color: 'red'
          })
          break;
        case 'server_notice':
          Notify.create({
            message: `${_content['response']['msg']}`,
            color: _content['response']['color']
          })
          break;
        case 'delete_page_component':
          useRepo(PageComponent).destroy(_content['response']['uuid']);
          break;
        case 'update_page_component':
          useRepo(PageComponent).save(_content['response']['page_component']);
          break;
        case 'set_otp':
          session.otp_uri = _content['response']['otp_uri'];
          session.otp_secret = _content['response']['otp_secret'];
          break;
        case 'update_blog_post':
          useRepo(BlogPost).save(_content['response']['blog_post']);
          break;
        case 'delete_page':
          useRepo(Page).destroy(_content['response']['uuid']);
          break;
        case 'update_page':
          useRepo(Page).save(_content['response']['page']);
          break;
        case 'update_user':
          useRepo(User).save(_content['response']['user']);
          break;
        case 'delete_menu_item':
          useRepo(MenuItem).destroy(_content['response']['uuid']);
          break;
        case 'media_asset_deleted':
          useRepo(MediaAsset).where('filename',_content['response']['filename']).delete();
          break;
        case 'set_media_assets':
          useRepo(MediaAsset).save(_content['response']['files']);
          break;
        case 'update_menu_item':
          useRepo(MenuItem).save(_content['response']['menu_item']);
          break;
        case 'update_support_message':
          useRepo(SupportMessage).save(_content['response']['support_message']);
          break;
        case 'set_otp':
          session.otp_enabled = _content['response']['otp_enabled'];
          session.otp_passed = _content['response']['otp_passed'];
          this.$socket.send(JSON.stringify({
            action: 'init'
          }));
          break;
        case 'init':
          Cookies.set('session_id', _content['response']['session_id']);
          Cookies.set('session_key', _content['response']['session_key']);
          session.user_id = _content['response']['user_id'];
          session.first_name = _content['response']['first_name'];
          session.email = _content['response']['email'];
          session.locale = _content['response']['locale'];
          session.is_admin = _content['response']['is_admin'];
          session.otp_passed = _content['response']['otp_passed'];
          session.otp_enabled = _content['response']['otp_enabled'];
          useRepo(Country).fresh(_content['response']['countries']);
          useRepo(PageComponent).fresh(_content['response']['page_components']);
          useRepo(Page).fresh(_content['response']['pages']);
          useRepo(MediaAsset).fresh(_content['response']['media_assets']);
          useRepo(MenuItem).fresh(_content['response']['menu_items']);
          useRepo(SupportMessage).fresh(_content['response']['support_messages']);
          useRepo(User).fresh(_content['response']['users']);
          session.initialized = true;
          break;
        case 'update_city_suggestions':
          session.city_suggestions = _content['response'];
          break;
        case 'registration_response':
          if (_content['response']['status']) {
            session.register_status = 2;
          } else {
            session.register_status = 0;
            Notify.create({
              message: `Registration error`,
              color: 'red'
            })
          }
          break;
        case 'authenticate_user':
          session.user_id = _content['response']['user_id'];
          session.first_name = _content['response']['first_name'];
          session.email = _content['response']['email'];
          session.locale = _content['response']['locale'];
          session.is_admin = _content['response']['is_admin'];
          session.otp_passed = _content['response']['otp_passed'];
          session.otp_enabled = _content['response']['otp_enabled'];
          this.$router.push('/')
          this.$socket.send(JSON.stringify({
            action: 'init'
          }));
          break;
        case 'pong':
          if (process.env.DEV) {
            console.log('Received pong');
          }
          break;
      }
    }
  }
})
</script>
