require_relative 'prize'
require_relative 'bad_consequence'
require_relative 'card_dealer'
require_relative 'player'

module Napakalaki

  class Monster

    attr_accessor :name, :level, :prize, :bad_consequence

    def initialize(name, level, bad_consequence, prize)
      @name = name
      @level = level
      @bad_consequence = bad_consequence
      @prize = prize
    end

    def combat_level
      return @level
    end

    def get_bad_consequence
      return @bad_consequence
    end
    
    #Devuelve el número de niveles ganados proporcionados por su buen rollo.
    def get_levels_gained
      return @prize.level
    end
    
    #Devuelve el número de tesoros ganados proporcionados por su buen rollo.
    def get_treasure_gained
      return @prize.treasures
    end
    
    #Devuelve true cuando el mal rollo del monstruo es muerte 
    #y false en caso contrario.
    def kills
      return @bad_consequence.my_bad_consequence_is_death
    end
    
    def to_s
      "Nombre del monstruo: #{@name}, Nivel: #{@level},\nPremio: #{@prize},\nMal rollo: #{@bad_consequence}"
    end
 
    public :combat_level,:get_bad_consequence,:get_levels_gained,:get_treasure_gained,:kills

  end
end