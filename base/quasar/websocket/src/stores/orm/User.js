import { Model } from 'pinia-orm'
import SupportMessage from './SupportMessage'
import Country from './Country'
import Organization from './Organization'

export default class User extends Model {

  static entity = 'users'
  static primaryKey = 'uuid'

  static fields () {
    return {
      uuid: this.string(null),
      organization_id: this.string(null),
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
      organization: this.belongsTo(Organization, 'organization_id'),
      country: this.belongsTo(Country, 'country_code'),
      language: this.belongsTo(Language, 'language_code'),
      support_messages: this.hasMany(SupportMessage, 'user_id')
    }
  }
}
