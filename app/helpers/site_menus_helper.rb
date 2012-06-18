# -*- encoding : utf-8 -*-

module SiteMenusHelper # :nodoc:

  #
  # Detect the root-menu-items including 'path'
  #
  def root_menus_including(menu)
    root_menus = []
    SiteMenu.roots.each do |root|
      root_menus << root if root.current_child?(self)
    end
    root_menus.flatten.uniq.compact
  end

  #
  # Is path included in any current_root's path?
  #
  def current_root_menu_include?(menu)
    begin
      if current_root(self)
        current_root(self).traverse(:depth_first) do |menu_item|
          @current_root = menu_item if menu && menu_item && current_page?(menu_item.site_menu_target) && menu.site_menu_target[0] != '#'
        end
      end
    rescue => e
      Rails.logger.info("** NO ROOT PATH FOUND #{e.inspect}")
      return false
    end
    @current_root != nil
  end

  def current_root_path_include?(menu)
    path_menus = []
    menu.traverse { |m|
      path_menus << m if current_page?(m.site_menu_target) && menu && menu.site_menu_target && menu.site_menu_target[0] != '#'
    }
    menu.ancestors.each do |anc|
      path_menus << anc if current_page?(anc.site_menu_target) && menu.site_menu_target[0] != '#'
    end
    path_menus.compact!
    path_menus.any?
  end

  def current_root_menu_include_path?(path)
    return true if current_page?(path) && path[0] != '#'
    search_item = SiteMenu.where(:site_menu_target => path).first
    current_root_menu_include?(search_item)
  end

  # if the link is a link to the current-page display it with a different
  # css-class to inform the user about 'here you are'.
  def menu_link_to(name,path,options={})
    style = "hmenu"
    style = "hmenu_current" if current_page?(path)
    options.merge!( { :class => style } )
    link_to( name, path, options )
  end

  def build_submenu_box(menu,&block)
    menu = menu.first if menu.is_a?(Mongoid::Criteria)
    if menu && menu.site_menu_target && (menu.role_needed||0) <= current_role
      yield( submenu_header(menu) ) +
      menu.children.map { |child|
        raw( build_submenu_box(child,&block) )
      }.join("") + close_submenu(menu)
    end
  end

  def submenu_margin_left
    margin = 0
    main_menu(false) do |name,html|
      break  if current_root_menu_include_path?(html[/(.*) href=\"(.*)\" (.*)$/,2])
      margin += (strip_links( (html||name||' ') ).length-1)*1.38
    end
    margin.to_i
  end

  def submenus(upto=4)
    rc=(0..upto).to_a.map { |level|
     level if content_for?("submenu_level_#{level}".to_sym)
    }.compact
    Rails.logger.info("==== SUBMENUS #{rc.inspect}")
    rc
  end

  def current_root(view_context)
    SiteMenu.roots.each do |root|
      if root.current_child?(view_context)
        Rails.logger.info("******** CURRENT ROOT = #{root.site_menu_target} ****** ")
        return root
      end
    end
  end

  def submenu_header(menu)
    if current_page?(menu.site_menu_target)
      header = "<div class='hmenu_current'>" + link_to(menu.name,menu.site_menu_target) + "</div>"
    else
      header = link_to(menu.name,menu.site_menu_target)
    end
    header += raw("<ul>") if menu.children.any?
    header
  end

  def close_submenu(menu)
    menu.children.any? ? "</ul>" : ""
  end

  def site_menu_manage_buttons(menu)
    ("<span style='height: 10px; vertical-align: middle;'>" +
    ui_button( 'edit',t(:edit), edit_site_menu_path(menu)) + sc(:nbsp) +
    ui_button( 'delete',t(:delete), menu, :method => :delete, :confirm => t(:are_you_sure)) + sc(:nbsp) +
    ui_button( 'add', t(:add_submenu_item), new_site_menu_path(:parent => menu.to_param)) +
    "</span>").html_safe
  end
  
end