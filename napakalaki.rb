# encoding: utf-8

require_relative 'card_dealer'
require_relative 'player'

module Napakalaki
  
  require "singleton"
  class Napakalaki
    
    include Singleton
    
    attr_accessor :current_player, :players, :dealer, :current_monster
    
    #Inicializa el array de jugadores que contiene Napakalaki, creando tantos 
    #jugadores como elementos haya en names, que es el array de String que 
    #contiene el nombre de los jugadores.
    
    def init_players(names)
      
      
      @dealer = CardDealer.instance
      
      #Inicializamos el array de jugadores
      @players = Array.new
        
      #Recorremos los nombres pasados y creamos tantos jugadores como nombres
      names.each do |s|

        players << Player.new(s)

      end
    end
    
    #Decide qué jugador es el siguiente en jugar. Se pueden dar dos posibilidades para calcular
    #el índice que ocupa dicho jugador en la lista de jugadores:
    #Que sea el primero en jugar, en este caso hay que generar un número aleatorio entre 0 y el numero de jugadores menos 1, este número indicará el índice que ocupa en la lista de jugadores el jugador que comenzará la partida.
    #Que no sea el primero en jugar, en este caso el índice es el del jugador que se encuentra en la siguiente posición al jugador actual. Hay que tener en cuenta que si el jugador actual está en la última posición, el siguiente será el que está en la primera posición.
    #Una vez calculado el índice, devuelve el jugador que ocupa esa posición.
    
    def next_players
      #Obtenemos el numero total de jugadores
        total_players = @players.length #se puede usar size, que es un alias de length

        #Si no está definido el jugador actual es porque es la primera vez
        if (@current_player == nil) then
            
            #Obtenemos un numero aleatorio con tope el índice maximo del 
            #numero de jugadores
            next_index = rand(total_players)
            
        else

            #Obtenemos el índice del jugador actual
            current_player_index = @players.index(@current_player)

            if current_player_index == total_players then
                #Si es el último seleccionamos el primero
                next_index = 0

            else
                #En caso contrario seleccionamos el siguiente
                next_index = current_player_index + 1
            end

        end

        #Obtenemos el jugador correspondiente al índice aleatorio
        next_player = @players.at(next_index)
        
        #Establecemos el siguiente jugador
        @current_player = next_player

        return @current_player
    end
    
    def develop_combat()
      combat = @current_player.combat(@current_monster)
      
      @dealer.give_monster_back(@current_monster)
      return combat
    end
    
    def discard_visible_treasures(treasure)
      #Descartamos los tesoros visibles
      treasure.each do |tr|
        @current_player.discard_visible_treasures(tr)
        @current_player.give_treasure_back(tr)
      end
    end
    
    def discard_hidden_treasures(treasure)
      #Descartamos los tesoros ocultos
       treasure.each do |tr|
        @current_player.discard_hidden_treasures(tr)
        @current_player.give_treasure_back(tr)
      end
    end
    
    def make_treasure_visible(treasure)
      for i in 1..treasure.length
        @current_player.make_treasure_visible(i)
      end
    end
    
    def buy_levels(visible,hidden)
      return @current_player.buy_levels(visible, hidden)
    end
    
    def init_game(players)
     init_players(players)
     @dealer.init_cards()
     next_turn
    end
    
    #Método que comprueba si el jugador activo (currentPlayer) cumple con las reglas del juego para poder terminar su turno.
    # Devuelve false si el jugador activo no puede pasar de turno y true en caso contrario, para ello usa el método de Player: valid_state()
    
    def next_turn_allowed
      
        if @current_player == nil then
            allowed = true #La primera vez current_player está sin asignar
        else
            allowed = @current_player.valid_state #1.1.1
        end

        return allowed
        
    end
    
    
    #Cambio de turno
    def next_turn
      #Comprobamos que se puede cambiar de turno
      state_ok = next_turn_allowed
      if state_ok then
        #Si se puede, pedimos al dealer que nos pase un monstruo nuevo
        #y cambiamos de jugador
        @current_monster = @dealer.next_monster
        @current_player = next_players
        #Si el nuevo jugador esta muerto se inicializan sus tesoros
        dead = @current_player.is_dead?
        if dead then
          @current_player.init_treasures 
        end
      end
      return state_ok
    end
    
    #Devuelve true si result tiene el valor WinAndWinGame del enumerado CombatResult, en
    #caso contrario devuelve false.
  
    def end_of_game(combat_result)
      return combat_result == WINANDWINGAME
    end
  end
end
