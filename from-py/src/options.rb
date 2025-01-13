module Knight
  class Options
    def self.floats? = true
    def self.list_literal? = true
  end

  def self.options = Options.new
end
