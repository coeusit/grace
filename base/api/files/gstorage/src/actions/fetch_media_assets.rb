_gs_bucket = @gstorage.bucket @config['gcloud_project_bucket']
_files = []
_gs_bucket.files.each do |_f|
  _files << {
    :id => _f.id,
    :filename => _f.name,
    :file_uri => _f.media_url,
    :file_type => _f.content_type
  }
end
@response = {
  :action => 'set_media_assets',
  :response => {
    :files => _files
  }
}
