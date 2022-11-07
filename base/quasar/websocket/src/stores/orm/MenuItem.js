import { Model } from 'pinia-orm'

export default class MenuItem extends Model {

  static entity = 'menu_items'
  static primaryKey = 'uuid'

  static fields () {
    return {
      uuid: this.string(null),
      parent_id: this.string(null),
      uri: this.string(null),
      caption: this.string(null),
      subtitle: this.string(null),
      icon: this.string(null),
      sorted_order: this.number(null),
      public: this.boolean(null),
      children: this.hasMany(MenuItem, 'parent_id'),
      parent: this.belongsTo(MenuItem, 'parent_id')
    }
  }
}
