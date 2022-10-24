if @params.has_key?('filename') && @params.has_key?('content') && @session.is_admin
  _gs_bucket = @gstorage.bucket @config['gcloud_project_bucket']
  _file = _gs_bucket.create_file StringIO.new(Base64.decode64(@params['content'])), @params['filename']
  if _file != nil
    @response = {
      :action => 'set_media_assets',
      :response => {
        :files => [{
          :id => _file.id,
          :filename => _file.name,
          :file_uri => _file.media_url,
          :file_type => _file.content_type
        }]
      }
    }
  end
end
