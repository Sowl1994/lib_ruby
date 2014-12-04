module Napakalaki
  
  class Treasure

    attr_accessor :name, :gold_coins,:min_bonus,:max_bonus, :type

    def initialize(name, gold_coins,min_bonus,max_bonus,type)
      @name=name
      @gold_coins = gold_coins
      @min_bonus = min_bonus
      @max_bonus = max_bonus
      @type = type
    end
  
    def to_s
      "Nombre del tesoro: #{@name}, coste: #{@gold_coins} monedas, tipo: #{@type}"
    end
  
  end
end

