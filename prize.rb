module Napakalaki
  
  class Prize
    
    #Atributos
    attr_accessor :treasures, :level

    #Constructor
    def initialize(treasures,level)
      @treasures = treasures
      @level = level
    end
    
    def to_s
      "Tesoros: #{@treasures}, niveles: #{@level}"
    end

  end
  
end

