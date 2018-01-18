path=`pwd`

echo "============================start to upload linked files======================="

scp "${path}/config/database.yml" xu:/var/www/p_shop/production/shared/config/
scp "${path}/config/secrets.yml" xu:/var/www/p_shop/production/shared/config/
scp "${path}/config/application.yml" xu:/var/www/p_shop/production/shared/config/
scp "${path}/public/favicon.ico" xu:/var/www/p_shop/production/shared/public
echo "============================upload linked files end============================"

# cap staging puma:start
# cap staging puma:restart
# cap staging puma:stop