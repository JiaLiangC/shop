module CategoriesHelper
    def root_categories(except_obj: nil)
        return Category.roots.select{|c| c.id != except_obj.id}  if except_obj.present?
        Category.roots
    end
end
