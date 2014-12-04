# encoding: utf-8

# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#última

require_relative "napakalaki"
require_relative "command"
require_relative 'combat_result'
require "singleton"

module Test

class GameTester

  include Singleton
 
  private
  @game
 
  public
  def play(a_game, number_of_players)
    
    @game = a_game
    names = get_player_names(number_of_players)
    @game.init_game(names) 
    
    begin #Mientras dure la partida
      begin #Mientras el jugador se decide a conocer al monstruo
        puts "******* ******* ******* ******* ******* ******* *******"
        puts "\n\n Turno de: " + @game.current_player.to_s
        command = get_command_before_knowing_monster()
        command = process_command(command)        
      end while (command != Command::EXIT && command != Command::SHOWMONSTER)
      if (command == Command::SHOWMONSTER) then
        begin #Mientras el jugador se decida a combatir 
          puts "******* ******* ******* ******* ******* ******* *******"
          puts "\n\n Turno de: " + @game.current_player().to_s()
          command = get_command_before_fighting()
          command = process_command(command)
        end while (command != Command::EXIT && command != Command::COMBAT)
        if (command == Command::COMBAT) then
          combat_result = @game.develop_combat()
          case combat_result
            when Napakalaki::CombatResult::WINANDWINGAME then 
              puts "\n\n       " + @game.current_player().get_name()
              puts "\n\n HAS GANADO LA PARTIDA"
              #break está implícito            
            when Napakalaki::CombatResult::WIN then
              puts "\n\n Ganaste el combate"
            when Napakalaki::CombatResult::LOSE then
              puts "\n\n Has perdido el combate, te toca cumplir el mal rollo"
            when Napakalaki::CombatResult::LOSEANDESCAPE then
              puts "\n\n Perdiste el combate pero has logrado escapar"
            when Napakalaki::CombatResult::LOSEANDDIE then
              puts "\n\n Perdiste el combate y ademas estas muerto"
           end #case
          if (combat_result != Napakalaki::CombatResult::WINANDWINGAME) then
            begin #Hasta que se avance de turno 
              puts "******* ******* ******* ******* ******* ******* *******"
              puts "\n\n Turno de: " + @game.current_player().to_s()
              command = get_command_after_fighting()
              command = process_command(command)
            end while (command != Command::EXIT && command != Command::NEXTTURNALLOWED)
          else 
            command = Command::EXIT;
          end #if WINANDWINGAME  
        end #if COMBAT
    end  #if SHOWMOnSTER
    end while (command != Command::EXIT) #mientras dure la partida

  end
  
  private
  
  def get_command_after_fighting()
      commands = [Command::SHOWMONSTER, Command::SHOWVISIBLETREASURE, Command::SHOWHIDDENTREASURE, 
      Command::DISCARDVISIBLETREASURE, Command::DISCARDHIDDENTREASURE, Command::MAKETREASUREVISIBLE, 
      Command::NEXTTURN, Command::EXIT]
      manage_menu("Opciones antes de pasar turno", commands)
  end
  
  def get_command_before_fighting ()
      commands = [Command::SHOWMONSTER, Command::SHOWVISIBLETREASURE, Command::SHOWHIDDENTREASURE, 
      Command::COMBAT, Command::EXIT]
      manage_menu("Opciones antes de combatir", commands)
  end
  
  def get_command_before_knowing_monster () 
      commands = [Command::SHOWMONSTER,Command::SHOWVISIBLETREASURE, Command::SHOWHIDDENTREASURE, 
      Command::MAKETREASUREVISIBLE,  Command::BUYLEVELS, Command::EXIT]      
      manage_menu("Opciones antes de conocer al monstruo", commands)
  end
  
  def get_player_names (number_of_players) 
    names = Array.new
    for i in 1..number_of_players
      puts "Escribe el nombre del jugador #{i}: "
      names << gets.chomp
    end
    names;
  end

  def get_treasure (how_many) 
    
    begin #Hasta que la entrada sea valida
      valid_input = true
      option = -1
      puts "\n Elige un tesoro: "
      capture = gets.chomp
      
      begin #tratar la excepcion
        option = Integer(capture)
      rescue Exception => e  
        valid_input = false
      end
      
      if valid_input then
        if (option < -1 || option > how_many) then #no se ha escrito un entero en el rango permitido
          valid_input = false
        end
      end  
      if (! valid_input) then
        input_error_message() 
      end
    end while (! valid_input)
    option
  end
  
  def input_error_message () 
    puts "\n\n ERROR !!! \n\n Selección errónea. Inténtalo de nuevo.\n\n"
  end
  
  def manage_buy_levels (a_player) 
    commands = [Command::BUYWITHVISIBLES, Command::BUYWITHHIDDEN, Command::BUYLEVELS]
    
    visible_treasures_to_buy_levels = Array.new (a_player.visible_treasures())
    hidden_treasures_to_buy_levels = Array.new (a_player.hidden_treasures())
    visible_shopping_cart = Array.new
    hidden_shopping_cart = Array.new

    begin #Hasta que se llene el carrito de la compra y se decida comprar niveles
      command = manage_menu("Opciones para comprar niveles", commands)
      case command 
        when Command::BUYWITHVISIBLES then
          manage_treasures_to_buy_levels(visible_shopping_cart, visible_treasures_to_buy_levels)
        when Command::BUYWITHHIDDEN then
          manage_treasures_to_buy_levels(hidden_shopping_cart, hidden_treasures_to_buy_levels)
      end 
    end while (command != Command::BUYLEVELS)
    a_player.buy_levels(visible_shopping_cart, hidden_shopping_cart)
  end
  
  def manage_discard_treasures (visible, a_player)
     
    begin #Se descartan tesoros hasta que se vuelve al menÃº anterior
      if visible then
        how_many = show_treasures("Elige tesoros visibles para descartar", a_player.visible_treasures, true)
      else 
        how_many = show_treasures("Elige tesoros ocultos para descartar", a_player.hidden_treasures, true)
      end
      option = get_treasure (how_many)
      if (option > -1) then 
        if visible then
          a_player.discard_visible_treasures(a_player.visible_treasures[option])
        else
          a_player.discard_hidden_treasures(a_player.hidden_treasures[option])          
        end
      end
    end while (option != -1)  
  end
  
  def manage_make_treasure_visible (a_player)
       
    begin #Se hacen tesoros visibles hasta que se vuelve al menÃº anterior
      how_many = show_treasures("Elige tesoros para intentar hacerlos visibles", a_player.hidden_treasures, true)
      option = get_treasure (how_many);
      if (option > -1) then
        a_player.make_treasure_visible (a_player.hidden_treasures[option])
      end
    end while (option != -1)
  end
  
  def manage_menu (message, menu) 
    menu_check = Hash.new #Para comprobar que se hace una selecciÃ³n vÃ¡lida
    menu.each do |c|
      menu_check [Command.get_menu(c)] = c
    end    
    begin #Hasta que se hace una selecciÃ³n vÃ¡lida
      valid_input = true
      option = -1
      puts ("\n\n------- ------ ------ ------ ------ ------ ------")
      puts "**** " + message + " ****\n"
      menu.each do |c| #se muestran las opciones del menÃº
        puts "#{Command.get_menu(c)}" + " : " + Command.get_text(c)
      end
      puts "\n Elige una opción: "
      capture = gets.chomp
      begin
        option = Integer(capture)
      rescue Exception => e  #No se ha introducido un entero
        valid_input = false
      end  
      
      if valid_input then
        if (! menu_check.has_key?(option)) #No es un entero entre los vÃ¡lidos
          valid_input = false
        end
      end
      if (! valid_input) then
        input_error_message()
      end
    end while (! valid_input)
    menu_check[option]    
  end
  
  def manage_treasures_to_buy_levels (shopping_cart, treasures_to_buy_levels) 
       
    begin #Mientras se aÃ±adan tesoros al carrito de la compra
      how_many = show_treasures("Elige tesoros para comprar niveles", treasures_to_buy_levels, true)
      option = get_treasure (how_many)
      if (option > -1) then
        shopping_cart << treasures_to_buy_levels[option]
        treasures_to_buy_levels.delete_at(option)
      end
    end while (option != -1)
  end
  
  def process_command (command) 
    current_player = @game.current_player
    case command 
      when Command::EXIT then 
        puts "exit"
      when Command::COMBAT then
        puts "combat"
        puts "pulsa enter para seguir"
        gets
      when  Command::SHOWMONSTER then 
        puts "\n------- ------- ------- ------- ------- ------- ------- "
        puts "El monstruo actual es:\n\n" + @game.current_monster().to_s()
        puts "pulsa enter para seguir"
        gets
      when Command::SHOWVISIBLETREASURE then
        show_treasures("Esta es tu lista de tesoros visibles", current_player.visible_treasures, false)
        puts "pulsa enter para seguir"
        gets
      when Command::SHOWHIDDENTREASURE then
        show_treasures("Esta es tu lista de tesoros ocultos", current_player.hidden_treasures, false)
        puts "pulsa enter para seguir"
        gets
      when Command::MAKETREASUREVISIBLE then
        manage_make_treasure_visible (current_player)
        puts "pulsa enter para seguir"
        gets
      when Command::DISCARDVISIBLETREASURE then
        manage_discard_treasures(true, current_player)
        puts "pulsa enter para seguir"
        gets
      when Command::DISCARDHIDDENTREASURE then
        manage_discard_treasures(false, current_player)
        puts "pulsa enter para seguir"
        gets
      when Command::BUYLEVELS then
        manage_buy_levels (current_player)
        puts "pulsa enter para seguir"
        gets
      when Command::NEXTTURN then
        if !@game.next_turn then
          puts "\n\n ERROR \n"
          puts "No cumples las condiciones para pasar de turno."
          puts "O bien tienes más de 4 tesoros ocultos"
          puts "O bien te queda mal rollo por cumplir"
        else 
          command = Command::NEXTTURNALLOWED
        end
        puts "pulsa enter para seguir"
        gets
    end
    command
  end
  
  def show_treasures (message, treasures, menu)
    option_menu = -1

    puts "\n------- ------- ------- ------- ------- ------- -------"
    puts message 
    if menu then
      puts "\n" + Command.get_menu(Command::GOBACK).to_s() + " : " + Command.get_text(Command::GOBACK)
    end
    treasures.each do |t|
      option_menu = option_menu + 1
      if (menu)
         puts "\n" + option_menu.to_s() + ":" + t.to_s
      else 
        puts "\n" + t.to_s
      end
     
    end
    option_menu
  end
 
 end #clase
end #modulo
