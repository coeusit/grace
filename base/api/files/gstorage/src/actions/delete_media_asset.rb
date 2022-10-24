if @params.has_key?('filename') && @session.is_admin
  _gs_bucket = @gstorage.bucket @config['gcloud_project_bucket']
  _file = _gs_bucket.file @params['filename']
  if _file != nil
    if _file.delete
      @response = {
        :action => 'media_asset_deleted',
        :response => {
          :filename => @params['filename']
        }
      }
    end
  end
end
