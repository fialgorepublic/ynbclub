module GroupCategoriesHelper
  def group_categories
    GroupCategory.pluck(:name, :id)
  end
end
