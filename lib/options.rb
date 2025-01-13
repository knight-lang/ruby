module Knight
  class Options
    def floats? = true
    def list_literal? = true
    def boolean_functions? = true
  end

  module_function

  def options = Options.new
end
