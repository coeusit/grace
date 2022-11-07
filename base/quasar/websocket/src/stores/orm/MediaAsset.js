import { Model } from 'pinia-orm'

export default class MediaAsset extends Model {

  static entity = 'media_assets'

  static fields () {
    return {
      id: this.string(null),
      file_uri: this.string(null),
      filename: this.string(null),
      file_type: this.string(null)
    }
  }
}
