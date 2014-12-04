# encoding: utf-8
require_relative 'treasure_kind'
require_relative 'monster'

module Napakalaki
  class BadConsequence

    attr_accessor :text, :some_levels, :some_visible_treasures, :some_hidden_treasures, :some_specific_visible_treasures, :some_specific_hidden_treasures, :death

    def initialize(text, some_levels = 0, some_visible_treasures = 0, some_hidden_treasures = 0, some_specific_visible_treasures = Array.new, some_specific_hidden_treasures = Array.new, death = false)
      @text = text
      @some_levels = some_levels
      @some_visible_treasures = some_visible_treasures
      @some_hidden_treasures = some_hidden_treasures
      @some_specific_visible_treasures = some_specific_visible_treasures
      @some_specific_hidden_treasures = some_specific_hidden_treasures
      @death = death
    end
    
    def self.new_level_number_of_treasures(text, some_levels, some_visible_treasures, some_hidden_treasures )
      new(text,some_levels, some_visible_treasures, some_hidden_treasures, nil, nil, nil)
    end


    def self.new_level_specific_treasures(text, some_levels, some_specific_visible_treasures, some_specific_hidden_treasures )
      new(text, some_levels, nil ,nil, some_specific_visible_treasures, some_specific_hidden_treasures, nil)
    end

    def self.new_death(text, death)
      new(text, nil, nil, nil, nil, nil, death)
    end
    
    #Actualiza el mal rollo que tiene que cumplir el jugador, en función del tipo de tesoro de t y
    #del tipo de mal rollo que tenga que cumplir el jugador.
    def substract_visible_treasure(treasure)
      @some_specific_visible_treasures.delete(treasure.type);
    end

    #Igual que el anterior, pero para los ocultos.
    
    def substract_hidden_treasure(treasure)
      @some_specific_hidden_treasures.delete(treasure.type);   
    end
    
    def adjust_to_fit_treasure_lists(v,h)
      t_visible = Array.new
      t_hidden = Array.new
        
       #Recorremos los tesoros
        v.each do |t|
        #Si no contiene el TreasureKind lo agregamos
          if t_visible.index(t.type) == nil then
              t_visible << t.type
          end
        end
        
        #Recorremos los tesoros
        h.each do |t|
        #Si no contiene el TreasureKind lo agregamos
          if t_hidden.index(t.type) == nil then
              t_hidden << t.type
          end
        end

        bc = BadConsequence.new_level_specific_treasures(@text, 0, t_visible, t_hidden)

        return bc
    end
    
    #Devuelve true cuando el mal rollo que tiene que cumplir el jugador está vacío, eso significa que el conjunto de atributos 
    #del mal rollo indican que no hay mal rollo que cumplir
    def is_empty?
      empty = false;
        
        if @some_levels == 0 && @death == false && @some_visible_treasures == 0 && @some_hidden_treasures == 0 && @some_specific_visible_treasures.empty? && @some_hidden_treasures.empty?
            empty = true
        else
            empty = false
        end
        
        return empty;
    end
    
    #Devuelve true si es un mal rollo es muerte, false en caso contrario.
    def my_bad_consequence_is_death
      return @death
    end
    
    def to_s
      if @some_visible_treasures == nil || @some_hidden_treasures == nil then
        "#{@text}, Niveles =  #{@some_levels}, Tesoro visible = #{@some_specific_visible_treasures}, Tesoro oculto = #{@some_specific_hidden_treasures}"
      elsif @some_specific_visible_treasures == nil || @some_specific_hidden_treasures == nil then
        "#{@text}, Niveles =  #{@some_levels}, numero de tesoros visibles = #{@some_visible_treasures}, numero de tesoros ocultos = #{@some_hidden_treasures}"
      else
        "#{@text}, muerto=#{@dead}"
      end
    end

    private_class_method :new
    public :substract_visible_treasure,:substract_hidden_treasure, :my_bad_consequence_is_death
  end
end