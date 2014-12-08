class GetNonogramService
  FILEPATH = 'app/assets/nonograms'

  def initialize(size)
    @size = size
  end

  def call
    nonogram_path = "#{FILEPATH}/#{@size}.nons"
    
    if File.exists?(nonogram_path)
      nonograms = File.read(nonograms_path).split
      nonograms.sample
    else
      false
    end
  end
end