import { Model } from 'pinia-orm'
import SupportMessage from './SupportMessage'
import User from './User'
import Country from './Country'

export default class Organization extends Model {

  static entity = 'organizations'
  static primaryKey = 'uuid'

  static fields () {
    return {
      uuid: this.string(null),
      first_name: this.string(null),
      last_name: this.string(null),
      company: this.string(null),
      email: this.string(null),
      phone: this.string(null),
      address_line_1: this.string(null),
      address_line_2: this.string(null),
      address_line_3: this.string(null),
      city_name: this.string(null),
      region_name: this.string(null),
      country_code: this.string(null),
      language_code: this.string(null),
      avatar: this.string(null),
      otp_enabled: this.boolean(null),
      enabled: this.boolean(null),
      admin: this.boolean(null),
      country: this.belongsTo(Country, 'country_code'),
      language: this.belongsTo(Language, 'language_code'),
      users: this.hasMany(User, 'organization_id'),
      support_messages: this.hasMany(SupportMessage, 'user_id')
    }
  }
}
