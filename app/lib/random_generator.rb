module RandomGenerator
  extend self
  attr_accessor :client
  #@client = GenericRandomGenerator.new

  def rand1
      rand(1_000_000_000)
    #client.rand
  end


  class GenericRandomGenerator
    def rand
      rand(1_000_000_000)
    end
  end
end
