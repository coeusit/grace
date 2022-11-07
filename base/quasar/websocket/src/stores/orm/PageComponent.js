import { Model } from 'pinia-orm'
import Page from './Page'

export default class PageComponent extends Model {

  static entity = 'page_components'
  static primaryKey = 'uuid'

  static fields () {
    return {
      uuid: this.string(null),
      page_id: this.string(null),
      parameters: this.attr(null),
      sorted_order: this.number(null),
      page: this.belongsTo(Page, 'page_id')
    }
  }
}
