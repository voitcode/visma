# Valid attribute values from Visma
class Visma::Verdier
  class << self
    def enheter
      {
        'STK' => 'Stykk',
        'KG' => 'Kilo'
      }
    end

    def pakningsniva
      {
        'F' => 'FPAK',
        'D' => 'DPAK',
        'T' => 'TPAK'
      }
    end

    def mva_sats
      {
        'L' => 'Lav sats',
        'M' => 'Middels sats',
        'H' => 'Standard sats'
      }
    end
  end
end
