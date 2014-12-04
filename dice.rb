# encoding: utf-8

module Napakalaki
  require "singleton"
  class Dice
    #hacemos que la clase use el patrón Singleton (única instancia)
    include Singleton
    #genera un numero aleatorio entre 1 y 6
    def next_number
      return 1+rand(6)
    end

  end
end