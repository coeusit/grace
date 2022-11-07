import { Model } from 'pinia-orm'
import User from './User'
import Organization from './Organization'

export default class Country extends Model {

  static entity = 'countries'
  static primaryKey = 'code'

  static fields () {
    return {
      code: this.string(null),
      name: this.string(null),
      users: this.hasMany(User, 'country_code'),
      organizations: this.hasMany(Organization, 'country_code')
    }
  }
}
