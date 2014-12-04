require_relative 'treasure'
require_relative 'monster'
require_relative 'treasure_kind'
require_relative 'combat_result'
require_relative 'dice'

module Napakalaki

  class Player
    
    #Atributos
    
    attr_accessor :name, :dead, :level, :visible_treasures,:hidden_treasures,:pending_bad_consequence
    
    def initialize(name)
      @name = name
      @dead = true
      @level = 1 #inicializamos el nivel a 1
      @visible_treasures = Array.new
      @hidden_treasures = Array.new
    end
    
    #Métodos
    
    #Devuelve el nivel de combate del jugador, que viene dado por su nivel 
    #más los bonus que le proporcionan los tesoros que tenga equipados, según las reglas 
    #del juego.
    
    def get_combat_level
      lvl=@level
      #Primero comprobamos si tenemos el collar
      has_necklace=false
      @visible_treasures.each do |t|
        if t.type==TreasureKind::NECKLACE then
          has_necklace=true
          break
        end
      end
      #Ahora recorro los tesosros para obtener el bonus
      @visible_treasures.each do |t|
        if has_necklace then
          lvl +=t.max_bonus #si tiene el necklace el maximo
        else
          lvl+=t.min_bonus#en caso contrario el minimo
        end
      end
      return lvl
    end
    
    #Devuelve la vida al jugador, modificando el atributo correspondiente.
    def bring_to_life
      @dead=false
    end
    
    #Incrementa el nivel del jugador en i niveles, teniendo en 
    #cuenta las reglas del juego.
    def increment_levels(l)
      @level +=l
    end
    
    #Decrementa el nivel del jugador en i niveles,
    # teniendo en cuenta las reglas de juego.
    def decrement_levels(l)
      @level-=l
      #el nivel minimo siempre sera 1
      if @level <1 then
        @level=1
      end
    end
    
    #Asigna el mal rollo al jugador, dándole valor
    # a su atributo pendingBadConsequence.
    def set_pending_bad_consequence(b)
      @pending_bad_consequence = b
    end
    
    #Devuelve true si con los niveles que 
    #compra no gana la partida y false en caso contrario.
    def can_i_buy_levels(l)
      can_i=false
      #si el nivel del jugador mas los niveles a comprar es menor de 10
      if @level +l < 10 then
        can_i=true
      end
      return can_i
    end
    
    def buy_levels(visible, hidden)
      levels_may_bought = compute_gold_coins_value(visible)
      levels_may_bought += compute_gold_coins_value(hidden)
      can_i = can_i_buy_levels(levels_may_bought/1000)
      if can_i
        increment_levels(levels_may_bought/1000)
      end
      @visible_treasures.delete(visible) #1.1.5
      @hidden_treasures.delete(hidden) #1.1.6
      
      dealer = CardDealer.instance
      for i in 1..visible.length
        dealer.give_treasure_back(i)
      end
      for j in 1..hidden.length
        dealer.give_treasure_back(j)
      end
    end
    
    #Cambia el estado de jugador a muerto si no tiene
    # ni tesoros visibles ni ocultos, modificando el correspondiente atributo.
    def die_if_no_treasures
      if @visible_treasures.empty? && @hidden_treasures.empty?
        @dead = true
      end
    end
    #Devuelve true cuando el jugador no tiene ningún 
    #mal rollo que cumplir (pendingBadSConsequece.isEmpty() == true) y no tiene más de 4 tesoros ocultos y false en caso contrario.
    
    def valid_state
      return @pending_bad_consequence == nil || (@pending_bad_consequence.is_empty? && @hidden_treasures.size <=4)
    end
    
    #Devuelve true cuando el jugador tiene algún 
    #tesoro visible y false en caso contrario.
    def has_visible_treasures
      return !@visible_treasures.empty?
    end
    #Devuelve el número de tesoros visibles que tiene del tipo tKind.
    def how_many_visible_treasures
      i=0
      @visible_treasures.each do |t|
        if t.type==t_kind then
          #Incrementamos el numero 
          i=i+1
        end
      end
      return i
    end
    #Devuelve los niveles del jugador.
    def get_levels
      return @level
    end
    
    #Comprueba si el tesoro (t) se puede pasar de oculto a visible, según las reglas del juego
    
    def can_make_treasure_visible(t)
     
     result = false

     case t.type

      when TreasureKind::ONEHAND #En el caso de los de una mano hay que comprar algunas cosas

        #Si está equipado con dos manos no puede agregar un tesoro de una mano
        if TreasureKind::BOTHHAND then
          result = false
        else

          #Recorremos los tesoros visibles para ver si ya tiene alguno de una mano (0, 1 o 2)
          i = 0
          @visible_treasures.each do |tv|
            if tv.type == TreasureKind::ONEHAND then
              i += 1
            end
                        
          end

          if i == 2 then
            #Si están las dos manos ocupadas no puede
            result = false
          else
            #En caso contrario si que puede
            result = true
          end
        end

      else  #El resto de casos, si esta en uso false, si no true
        result = true

      end

      return result
      
    end
    
    def make_treasure_visible(treasure)
      can_i = can_make_treasure_visible(treasure)
      if can_i
        @visible_treasures << treasure
        @hidden_treasures.delete(treasure)
      end
    end
    
    #Si el jugador tiene equipado el tesoro tipo NECKLACE, se lo pasa al CardDealer y lo elimina de sus tesoros visibles.
    
    def discard_necklace_if_visible
      
      @visible_treasures.each do |t| 
          
        if t.type == TreasureKind::NECKLACE

          #Le pasamos el tesoro al CardDealer
          dealer = CardDealer.instance
          dealer.give_treasure_back(t)

          #Lo eliminamos de nuestros tesoros visibles (equipados)
          @visible_treasures.delete(t)

          #Salimos del bucle
          break
        end

      end

      
    end
    #Calcula y devuelve los niveles que puede comprar el jugador con la lista t de tesoros.
    def compute_gold_coins_value(treasures)
      levels = 0
      coins = 0

      #Obtenemos el total de monedas
      treasures.each do |t|
          
        coins += t.gold_coins

      end

      #Dividimos entre 1000 cogiendo la parte entera, para no devolver cambio
      levels = (coins / 1000).round

      #Devolvemos el valor
      return levels

    end
    
    def combat(monster)
      my_level = get_combat_level #1.1.1

      monster_level = monster.combat_level #1.1.2
      
      if my_level > monster_level
        apply_prize(monster)
        if @level >= 10
          result = :WINANDWINTHEGAME
        else
          result = :WIN
        end
      else
        dice = Dice.instance
        escape = dice.next_number
        if escape < 5
          am_i_dead = monster.kills
          if am_i_dead == true
            die
            result = :LOSEANDDIE
          else
            bad = monster.bad_consequence
            result = :LOSE
            apply_bad_consequence(bad)
          end
        else
          result = :LOSEANDESCAPE
        end
      end
      discard_necklace_if_visible
      return result
    end
    
    def apply_prize(current_monster)
      n_levels = current_monster.get_levels_gained
      increment_levels(n_levels)
      n_treasures = current_monster.get_treasure_gained
      
      if n_treasures > 0
        dealer = CardDealer.instance
        for i in 1..n_treasures
          treasure = dealer.next_treasure
          @hidden_treasures << treasure
        end
      end
    end
    
    
    def die
      @level = 1#1
      dealer = CardDealer.instance#2
      
      for i in 1..@visible_treasures.length#3
        dealer.give_treasure_back(i)#4
      end
      @visible_treasures.clear#5
      
      for j in 1..@hidden_treasures.length#6
        dealer.give_treasure_back(j)#7
      end
      @hidden_treasures.clear#8
      die_if_no_treasures#9
    end
    
    def apply_bad_consequence(bad)
      n_levels = @level
      decrement_levels(n_levels)
      @pending_bad_consequence = bad.adjust_to_fit_treasure_lists(@visible_treasures, @hidden_treasures)
      set_pending_bad_consequence(@pending_bad_consequence)
    end
  
    #inicia los tesoros
    def init_treasures
      dealer = CardDealer.instance
      dice = Dice.instance
      bring_to_life
      treasure = dealer.next_treasure
      @hidden_treasures << treasure

      number = dice.next_number
      if number > 1
        treasure = dealer.next_treasure 
        @hidden_treasures << treasure
      end

      if number == 6
        treasure = dealer.next_treasure 
        @hidden_treasures << treasure
      end
    end

    def discard_visible_treasures(t)
      @visible_treasures.delete(t)
      if @pending_bad_consequence != nil && !@pending_bad_consequence.is_empty? then
        @pending_bad_consequence.substract_visible_treasure(t)
      end
      die_if_no_treasures
    end

    def discard_hidden_treasures(t)
      @hidden_treasures.delete(t)
      if @pending_bad_consequence != nil && !@pending_bad_consequence.is_empty? then
        @pending_bad_consequence.substract_hidden_treasure(t)
      end
      die_if_no_treasures
    end

    def is_dead?
      if(@dead == true)
        return true
      else
        return false
      end
    end

    def to_s
      @name + " Nivel: #{@level}"
    end 
  end
end