class Settings < Settingslogic
    source "#{Rails.root}/config/application.yml"
    # 各种环境变量的配置文件
    namespace Rails.env
end