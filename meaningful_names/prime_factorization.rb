class PrimeFactors
  attr_accessor :factors, :ceiling

  def initialize(ceiling = 1_000)
    @factors  = {}
    @ceiling = ceiling
    get_all_prime_factors
  end

  def get_all_prime_factors 
    1.upto(@ceiling) do |i|
      @factors[i] = calculate_prime_factors_for(i)
    end
  end

  def calculate_prime_factors_for(value)
    val_copy = value
    prime_factors = []
    2.upto(value/2) do |potential_prime|#no factor can be bigger than value/2
      while (val_copy % potential_prime).zero?
        prime_factors << potential_prime
        val_copy = val_copy / potential_prime
      end
    end
    prime_factors
  end

  def get_prime_factors_for(i)
    raise 'Value too high!' unless i <= @ceiling
    @factors[i]
  end

  def all
    @factors
  end
end


factors =PrimeFactors.new(100)
puts factors.all
