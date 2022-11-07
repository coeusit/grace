import { Model } from 'pinia-orm'
import PageComponent from './PageComponent'

export default class Page extends Model {

  static entity = 'pages'
  static primaryKey = 'uuid'

  static fields () {
    return {
      uuid: this.string(null),
      uri: this.string(null),
      public: this.boolean(null),
      page_components: this.hasMany(PageComponent, 'page_id'),
    }
  }
}
