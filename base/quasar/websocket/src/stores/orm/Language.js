import { Model } from 'pinia-orm'
import User from './User'
import Organization from './Organization'

export default class Language extends Model {

  static entity = 'languages'
  static primaryKey = 'code'

  static fields () {
    return {
      code: this.string(null),
      name: this.string(null),
      users: this.hasMany(User, 'language_code'),
      organizations: this.hasMany(Organization, 'language_code')
    }
  }
}
