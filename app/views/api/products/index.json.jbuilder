

json.data @products do |p|
	json.id p.id
	json.name p.title
end if @products.present?


json.data @categories do |c|
	json.id c.id
	json.name c.title
end if @categories.present?