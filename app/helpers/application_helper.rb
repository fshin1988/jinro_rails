module ApplicationHelper
  def page_title
    title = 'JinroLite'
    title = @page_title + " | " + title if @page_title
    title
  end
end
