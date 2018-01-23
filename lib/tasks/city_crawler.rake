require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'fileutils'


namespace :crawler do
  desc "crawl "
  task :crawl => :environment do
  
  #支持断点续传，爬去国家统计局的省市县镇4级联动分区的最新信息 

    BASE_URL = "http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/2016"

    # user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_0) AppleWebKit/513.1 (KHTML, like Gecko) Chrome/15.0.104. Safari/423.8"
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/534.34 (KHTML, like Gecko) Chrome/62.0.3249.131 Safari/513.16"


    province_urls = []
    province_infos = []

    city_urls = []
    city_infos = []

    county_infos = []
    county_urls = []

    town_infos = []

      # 31个省
      if City.where(level: 1).count < 31
        puts "finding province"
        # get provinces list
        index_page = Nokogiri::HTML(open(BASE_URL,'User-Agent' => user_agent))
        
        provinces_data = index_page.css("tr.provincetr td")

        # get province info
        provinces_data.each do |province|

          relative_province_page = province.css("a")[0]["href"]
          province_area_code = nil
          province_name =  province.text

          p_url = "#{BASE_URL}/#{relative_province_page}"
          province_code = p_url.split("/").last.delete(".html")

          province_urls  << p_url
          City.find_or_create_by(name: province_name, level: 1, data_url: p_url, area_code: province_code)

        end

      else
        province_urls = City.where(level: 1).pluck(:data_url)
      end
       

      # 344个市

      if City.where(level: 2).count < 344
      # get city info
        province_urls.each do |province_url|
          puts "sleep"
          sleep(1.1)

          # get city's parent province
          acode = province_url.split("/").last.delete(".html")
          parent_province = City.where(level: 1, area_code: "#{acode}%").first
          p_city_count =  parent_province.cities.count
          
          if p_city_count == 0 || p_city_count != parent_province.count
              puts "finding cities"
              # get city list
              city_list_page = Nokogiri::HTML(open(province_url, 'User-Agent' => user_agent))
              city_content = city_list_page.css("tr.citytr")

              # write province's city count to province
              parent_province.update_attributes(count: city_content.count) if parent_province.present?

              city_content.each do |city_info|
                city_area_code = city_info.css("td")[0].text
                city_name =  city_info.css("td")[1].text
                puts city_name
                city_relative_page = city_info.css("td a")[0]['href']
                c_url = "#{BASE_URL}/#{city_relative_page}"
                City.find_or_create_by(name: city_name,level: 2, area_code: city_area_code, parent_id: parent_province.id, data_url: c_url)
              end  
          end
        end
      else
        city_urls = City.where(level: 2).pluck(:data_url)
      end
        

        puts "sleeping"
        sleep 2
        puts "sleep over"
        
      # get county info
      if City.where(level: 3).count < 3089

        city_urls.each do |city_url|
          puts "sleep"
          sleep 1.1
          code = city_url.split("/").last.delete(".html")
          parent_city = City.where("level= ? and area_code like ?", 2, "#{code}%").first

          p_county_count =  parent_city.counties.count
          if p_county_count == 0 || p_county_count != parent_city.count
            puts "finding counties"
            # get count list
            county_list_page = Nokogiri::HTML(open(city_url, 'User-Agent' => user_agent))
            county_content = county_list_page.css("tr.countytr")
            puts "county_content didn't present" unless county_content

            # write city's county count to city
            parent_city.update_attributes(count: county_content.count) if parent_city.present?

            # get county info
            county_content.each do |info|
              begin
                county_area_code = info.css("td")[0].text
                county_name =  info.css("td")[1].text
                puts county_name
                county_relative_page = info.css("td a")[0]['href'] unless info.css("td a").empty?
                county_url =  (county_name == "市辖区" ?   "市辖区" : "#{BASE_URL}/#{city_url.split("/")[-2]}/#{county_relative_page}")
                City.find_or_create_by(name: county_name,level: 3, area_code: county_area_code, parent_id: parent_city.id, data_url: county_url)
              rescue Exception => e
                puts e
              end
            end
          end
        end

      else
        county_urls = City.where(level: 3).pluck(:data_url)
      end

  
        county_urls.each do |county_url|
            next if county_url == "市辖区"
            puts "sleep"
            sleep 1.1
            code = county_url.split("/").last.delete(".html")
            parent_county = City.where("level= ? and area_code like ?", 3, "#{code}%").first

            if parent_county.count != -1
              puts "finding towns"
              begin
                town_list_page = Nokogiri::HTML(open(county_url, 'User-Agent' => user_agent))
                town_content = town_list_page.css("tr.towntr")
                # get county info
                town_content.each do |info|
                  town_area_code = info.css("td")[0].text
                  town_name =  info.css("td")[1].text
                  next if town_name.include? "办事处"
                  next if town_name.include? "委员会"
                  puts town_name
                  City.find_or_create_by(name: town_name, level: 4, area_code: town_area_code, parent_id: parent_county.id)
                end

                #用-1作为爬取过的标记 
                parent_county.update_attributes(count: -1) if parent_county.present?

              rescue Exception => e
                puts e
              end
            end
        end


  end
end






