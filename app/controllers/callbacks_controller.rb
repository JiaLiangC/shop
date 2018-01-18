class CallbacksController < ApplicationController
    skip_before_filter :verify_authenticity_token
    respond_to :json

    # 七牛图片上传回调
    def image_upload_callback
        upload_info = JSON.parse(params.keys[0])
        imgable_id = upload_info["imgable_id"]
        imgable_type = upload_info["imgable_type"]
        user_id = upload_info["user_id"].present? ? upload_info["user_id"] : nil
        return_url = upload_info["return_url"]
        if imgable_id.present? && imgable_type.present? 
          # 处理图片上传逻辑
          if Enums.permited_imgable_class.include?(imgable_type)
            klass = upload_info["imgable_type"].constantize
            klass = klass.find(imgable_id.to_i)
            Image.create(imgable_id: imgable_id, imgable_type: imgable_type,
                name: upload_info['hash'], user_id: user_id, storage: 'qiniu')
            
          end
        end
        render json: {success: true, file_path: image_path(upload_info['hash'])}
    end

    private
     def permited_params
        params.permit(:imgable_type, :imgable_id)
     end

end
