module PageComponentsHelper # :nodoc:

  def interpret_page_component_for_js(page_component)
    presenter = PageComponentPresenter.new( page_component, self )
    interpreter = Interpreter.new(page_component,presenter,self)
    presenter.interpreter = interpreter
    presenter.render_page_component
  end

end