import { Model } from 'pinia-orm'
import User from './User'

export default class SupportMessage extends Model {

  static entity = 'support_messages'
  static primaryKey = 'uuid'

  static fields () {
    return {
      uuid: this.string(null),
      user_id: this.string(null),
      content: this.string(null),
      sent_at: this.attr(null),
      read_at: this.attr(null),
      deleted: this.boolean(false),
      outgoing: this.boolean(null),
      user: this.belongsTo(User, 'user_id')
    }
  }
}
