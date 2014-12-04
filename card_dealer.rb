# encoding: utf-8
module Napakalaki
 
  require "singleton"
  class CardDealer
    #Hacemos que la clase use el patrón Singleton (unica instancia)
    include Singleton
    attr_accessor :used_monsters, :unused_monsters, :used_treasures, :unused_treasures
    

    #Inicializa en mazo de cartas de Tesoros (unusedTreasures) con todas 
    #las cartas de tesoros proporcionadas en el pdf de cartas de tesoros.

    def init_treasure_card_deck()
        @unused_treasures = Array.new
        @used_treasures = Array.new 
        
        @unused_treasures << Treasure.new("Si mi amo!", 0, 4, 7, TreasureKind::HELMET)
        @unused_treasures << Treasure.new("Botas de investigación", 600, 3, 4, TreasureKind::SHOE)
        @unused_treasures << Treasure.new("Capucha de Cthulhu", 500, 3, 5, TreasureKind::HELMET)
        @unused_treasures << Treasure.new("A prueba de babas", 400, 2, 5, TreasureKind::ARMOR)
        @unused_treasures << Treasure.new("Botas de lluvia ácida", 800, 1, 1, TreasureKind::BOTHHAND)
        @unused_treasures << Treasure.new("Casco minero", 400, 2, 4, TreasureKind::HELMET)
        @unused_treasures << Treasure.new("Ametralladora Thompson", 600, 4, 8, TreasureKind::BOTHHAND)
        @unused_treasures << Treasure.new("Camiseta de la UGR", 100, 1, 7, TreasureKind::ARMOR)
        @unused_treasures << Treasure.new("Clavo de rail ferroviario", 400, 3, 6, TreasureKind::ONEHAND)
        @unused_treasures << Treasure.new("Cuchillo de sushi arcano", 300, 2, 3, TreasureKind::ONEHAND)
        @unused_treasures << Treasure.new("Fez alópodo", 700, 3, 5, TreasureKind::HELMET)
        @unused_treasures << Treasure.new("Hacha prehistórica", 500, 2, 5, TreasureKind::ONEHAND)
        @unused_treasures << Treasure.new("El aparato del Pr. Tesla", 900, 4, 8, TreasureKind::ARMOR)
        @unused_treasures << Treasure.new("Gaita", 500, 4, 5, TreasureKind::BOTHHAND)
        @unused_treasures << Treasure.new("Insecticida", 300, 2, 3, TreasureKind::ONEHAND)
        @unused_treasures << Treasure.new("Escopeta de 3 cañones", 700, 4, 6, TreasureKind::BOTHHAND)
        @unused_treasures << Treasure.new("Garabato Mistico", 300, 2, 2, TreasureKind::ONEHAND)
        @unused_treasures << Treasure.new("La fuerza de Mr. T", 1000, 0, 0, TreasureKind::NECKLACE)
        @unused_treasures << Treasure.new("La rebeca metálica", 400, 2, 3, TreasureKind::ARMOR)
        @unused_treasures << Treasure.new("Mazo de los antiguos", 200, 3, 4, TreasureKind::ONEHAND)
        @unused_treasures << Treasure.new("Necro-playboycon", 300, 3, 5, TreasureKind::ONEHAND)
        @unused_treasures << Treasure.new("Lanzallamas", 800, 4, 8, TreasureKind::BOTHHAND)
        @unused_treasures << Treasure.new("Necro-comicón", 100, 1, 1, TreasureKind::ONEHAND)
        @unused_treasures << Treasure.new("Necronomicón", 800, 5, 7, TreasureKind::BOTHHAND)
        @unused_treasures << Treasure.new("Linterna a 2 manos", 400, 3, 6, TreasureKind::BOTHHAND)
        @unused_treasures << Treasure.new("Necro-gnomicón", 200, 2, 4, TreasureKind::ONEHAND)
        @unused_treasures << Treasure.new("Necrotelecom", 300, 2, 3, TreasureKind::HELMET)
        @unused_treasures << Treasure.new("Porra preternatural", 200, 2, 3, TreasureKind::ONEHAND)
        @unused_treasures << Treasure.new("Tentácula de pega", 200, 0, 1, TreasureKind::HELMET)
        @unused_treasures << Treasure.new("Zapato deja-amigos", 500, 0, 1, TreasureKind::SHOE)
        @unused_treasures << Treasure.new("Shogulador", 600, 1, 1, TreasureKind::BOTHHAND)
        @unused_treasures << Treasure.new("Varita de atizamiento", 400, 3, 4, TreasureKind::ONEHAND)

    end

    #Inicializa el mazo de cartas de monstruos (unusedMonsters), con todas las cartas de monstruos 
    #proporcionadas en el pdf de cartas de monstruos. Se recomienda reutilizar el código desarrollado 
    #en la primera práctica para construir las cartas de monstruos.

    def init_monster_card_deck()

      #Definimos un array donde almacenar los monstruos
        @unused_monsters = Array.new
        @used_monsters = Array.new #inicializamos los dos array

        #Creamos los monstruos

        #Monstruo 1
        tvp = [TreasureKind::ARMOR]
        top = [TreasureKind::ARMOR]
        bad_consequence = BadConsequence.new_level_specific_treasures("Pierdes tu armadura visible y otra oculta", 0, tvp, top)
        prize = Prize.new(2, 1)
        @unused_monsters<< Monster.new("3 Byakhees de bonanza", 8, bad_consequence, prize)

        #Monstruo 2
        tvp = [TreasureKind::HELMET]
        top = []
        bad_consequence = BadConsequence.new_level_specific_treasures("Embobados con el lindo primigenio te descartas de tu casco visible", 0, tvp, top)
        prize = Prize.new(1, 1)
        @unused_monsters<< Monster.new("Chibithulhu", 2, bad_consequence, prize)

        #Monstruo 3
        tvp = [TreasureKind::SHOE]
        top = []
        bad_consequence = BadConsequence.new_level_specific_treasures("El primordial bostezo contagioso. Pierdes el calzado visible", 0, tvp, top)
        prize = Prize.new(1, 1)
        @unused_monsters<< Monster.new("El sopor de Dunwich", 2, bad_consequence, prize)

        #Monstruo 4
        tvp = [TreasureKind::ONEHAND]
        top = [TreasureKind::ONEHAND]
        bad_consequence = BadConsequence.new_level_specific_treasures("Te atrapan para llevarte de fiesta y te dejan caer en mitad del vuelo. Descarta 1 mano visible y 1 mano oculta", 0, tvp, top)
        prize = Prize.new(4, 1)
        @unused_monsters<< Monster.new("Ángeles de la noche ibicenca", 14, bad_consequence, prize)


        #Monstruo 5
        tvp = [TreasureKind::SHOE,TreasureKind::ONEHAND,TreasureKind::NECKLACE,TreasureKind::HELMET,TreasureKind::BOTHHAND,TreasureKind::ARMOR]
        top = []
        bad_consequence = BadConsequence.new_level_specific_treasures("Pierdes todos tus tesoros visibles", 0, tvp, top)
        prize = Prize.new(3, 1)
        @unused_monsters<< Monster.new("El gorrón en el umbral", 10, bad_consequence, prize)

        #Monstruo 6
        tvp = [TreasureKind::ARMOR]
        top = []
        bad_consequence = BadConsequence.new_level_specific_treasures("Pierdes la armadura visible", 0, tvp, top)
        prize = Prize.new(2, 1)
        @unused_monsters<< Monster.new("H.P. Munchcraft", 6, bad_consequence, prize)

        #Monstruo 7
        tvp = [TreasureKind::ARMOR]
        top = []
        bad_consequence = BadConsequence.new_level_number_of_treasures("Sientes bichos bajo la ropa. Descarta la armadura visible", 0, tvp, top)
        prize = Prize.new(1, 1)
        @unused_monsters<< Monster.new("Bichgooth", 2, bad_consequence, prize)

        #Monstruo 8
        bad_consequence = BadConsequence.new_level_number_of_treasures("Pierdes 5 niveles", 5, 0, 0)
        prize = Prize.new(4, 2)
        @unused_monsters<< Monster.new("El rey de rosa", 13, bad_consequence, prize)

        #Monstruo 9
        bad_consequence = BadConsequence.new_level_number_of_treasures("Toses los pulmones y pierdes 2 niveles", 2,0,0)
        prize = Prize.new(1, 1)
        @unused_monsters<< Monster.new("La que redacta en las tinieblas", 2, bad_consequence, prize)

        #Monstruo 10
        bad_consequence = BadConsequence.new_death("Estos monstruos resultan bastante superciales y te aburren mortalmente. Estas muerto", true)
        prize = Prize.new(2, 1);
        @unused_monsters<< Monster.new("Los hondos", 8, bad_consequence, prize)

        #Monstruo 11
        bad_consequence = BadConsequence.new_level_number_of_treasures("Pierdes 2 niveles y 2 tesoros ocultos.", 2, 0, 2)
        prize = Prize.new(2, 1)
        @unused_monsters<< Monster.new("Semillas Cthulhu", 4, bad_consequence, prize)

        #Monstruo 12
        tvp = [TreasureKind::ONEHAND]
        top = []
        bad_consequence = BadConsequence.new_level_specific_treasures("Te intentas escaquear. Pierdes una mano visible.", 0, tvp, top)
        prize = Prize.new(2, 1)
        @unused_monsters<< Monster.new("Dameargo", 1, bad_consequence, prize)

        #Monstruo 13
        tvp = []
        top = []
        bad_consequence = BadConsequence.new_level_specific_treasures("Da mucho asquito, Pierdes 3 niveles", 3, tvp, top)
        prize = Prize.new(1, 1)
        @unused_monsters<< Monster.new("Pollipolipo volante", 3, bad_consequence, prize)

        #Monstruo 14
        bad_consequence = BadConsequence.new_death("No le hace gracia que pronuncien mal su nombre. Estas muerto", true)
        prize = Prize.new(3, 1)
        @unused_monsters<< Monster.new("Yskhtihyssg-Goth", 12, bad_consequence, prize)

        #Monstruo 15
        bad_consequence = BadConsequence.new_death("La familia te atrapa. Estas muerto", true)
        prize = Prize.new(4, 1)
        @unused_monsters<< Monster.new("Familia feliz", 1, bad_consequence, prize)

        #Monstruo 16
        tvp = [TreasureKind::BOTHHAND]
        top = []
        bad_consequence = BadConsequence.new_level_specific_treasures("La quinta directiva primaria te obliga a perder 2 niveles y un tesoro 2 manos visible", 2, tvp, top)
        prize = Prize.new(2, 1)
        @unused_monsters<< Monster.new("Roboggoth", 8, bad_consequence, prize)

        #Monstruo 17
        tvp = [TreasureKind::HELMET]
        top = []
        bad_consequence = BadConsequence.new_level_specific_treasures("Te asusta en la noche. Pierdes un casco visible.", 0, tvp, top)
        prize = Prize.new(1, 1)
        @unused_monsters<< Monster.new("El espia", 5, bad_consequence, prize)

        #Monstruo 18
        bad_consequence = BadConsequence.new_level_number_of_treasures("Menudo susto te llevas. Pierdes 2 niveles y 5 tesoros visibles", 2, 5, 0)
        prize = Prize.new(1, 1)
        @unused_monsters<< Monster.new("El lenguas", 20, bad_consequence, prize)

        #Monstruo 19
        tvp = [TreasureKind::BOTHHAND]
        top = []
        bad_consequence = BadConsequence.new_level_specific_treasures("Te faltan manos para tanta cabeza. Pierdes 3 niveles y tus tesoros visibles de las manos.", 3, tvp, top)
        prize = Prize.new(1, 1)
        @unused_monsters<< Monster.new("Bicefalo", 20, bad_consequence, prize)

    end

    #Baraja el mazo de cartas de tesoros unusedTreasures.

    def shuffle_treasures()
      #lo barajo con metodos random, es decir aleatorios
      #a partir de ruby 1.8.7
      @unused_treasures = @unused_treasures.shuffle
      #para los anteriores
      @unusused_treasures = @unused_treasures.sort_by { rand  }
    end
    
    def shuffle_monster()
      #lo barajo con metodos random, es decir aleatorios
      #a partir de ruby 1.8.7
      @unused_monsters = @unused_monsters.shuffle
      #para los anteriores
      @unusused_monsters = @unused_monsters.sort_by { rand  }
    end
    
    #Devuelve el siguiente tesoro que hay en el mazo de tesoros (unusedTreasures) y lo elimina de él. Si el mazo está 
    #vacío, pasa el mazo de descartes (usedTreasures) al mazo de tesoros y lo baraja, 
    #dejando el mazo de descartes vacío.
    
    def next_treasure()
      #Barajamos los tesoros de inicio
      shuffle_treasures
      #Comprobamos si tenemos cartas en el mazo
      if @unused_treasures.empty?
            
        #Recorremos las cartas descartadas
        @used_treasures.each do |t| 
                
          #Las agregamos al mazo sin usar
          @unused_treasures<<t
        
        end
            
        #Las barajamos
        shuffle_treasures
            
        #Limpiamos el mazo de descartes
        @used_treasures.clear
        
      end
        
      #Obtengo la primera carta del mazo
      t = @unused_treasures.at(0)
        
      #La agregamos al mazo de descartes
      @used_treasures<<t
        
      #La eliminamos del mazo
      @unused_treasures.delete(t);
        
      #Devolvemos la carta
      return t

      
    end
    
    #Devuelve el siguiente tesoro que hay en el mazo de tesoros (unusedTreasures) y lo elimina de él. Si el mazo está 
    #vacío, pasa el mazo de descartes (usedTreasures) al mazo de tesoros y lo baraja, 
    #dejando el mazo de descartes vacío.
    #
    #Los argumentos anteriores son los mismos que para este.
    #
    #Igual que la anterior pero con el mazo de monstruos.
    
    def next_monster()
      #Las barajamos de inicio
       shuffle_monster
        
      #Comprobamos si tenemos cartas en el mazo
      if @unused_monsters.empty?
            
        #Recorremos las cartas descartadas
        @used_monsters.each do |m| 
                
          #Las agregamos al mazo sin usar
          @unused_monsters<<m
        
        end
            
        #Las barajamos
        shuffle_monster
            
        #Limpiamos el mazo de descartes
        @used_treasures.clear
        
      end
        
      #Obtengo la primera carta del mazo
      m = @unused_monsters.at(0)
        
      #La agregamos al mazo de descartes
      @used_monsters<<m
        
      #La eliminamos del mazo
      @unused_monsters.delete(m);
        
      #Devolvemos la carta
      return m
      
    end
    
    #Introduce en el mazo de descartes de tesoros (usedTreasures) 
    #el tesoro t.
    def give_treasure_back(treasure)
      @used_treasures << treasure
    end
    
    #Introduce en el mazo de descartes de 
    #monstruos (usedMonsters) al monstruo m.
    def give_monster_back(monster)
      @used_monsters << monster
    end
    
    #inicializacion de las cartas
    def init_cards()
      init_treasure_card_deck
      init_monster_card_deck
    end
    
    private :init_treasure_card_deck,:init_monster_card_deck,:shuffle_monster,:shuffle_treasures
    public :next_treasure,:next_monster,:give_treasure_back,:give_monster_back,:init_cards
  end
end