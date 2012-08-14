module ApplicationHelper
  
  def link_helper (link_target, link_text, link_class, icon_class)
    
    link_to [content_tag(:i, "", :class => icon_class), link_text].join(" ").html_safe, link_target, :class => 'btn ' + link_class
    # link_to tag("i", 
    
  end

end
