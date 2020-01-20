require 'rmagick'
include Magick

class ImgIO
  attr_reader :image

  def initialize(width, height)
    @width = width
    @height = height
    @x = 0
    @y = 0

    @image = Image.new(8 * width, 8 * height) do
      self.background_color = "black"
    end
  end

  def draw_text(text, x, y, color: nil)
    color ||= "white"

    t = Draw.new
  
    t.font = 'PressStart2P-vaV7.ttf'
    t.fill = color
    t.pointsize = 8
    t.gravity = NorthWestGravity
  
    t.annotate(@image, 100, 200, 8 * x, 8 * y, text)
  end

  def write(text, color: nil)
    texts = text.split("\n")
    if @x + texts.first.size > @width
      remains = texts.first.slice!(@width - @x, texts.first.size)
      texts.insert(1, remains)
    end
    texts = texts.map { |t| t.size.zero? ? "" : t.chars.each_slice(@width).map(&:join) }.flatten

    texts.each do |t|
      draw_text(t, @x, @y, color: color)
      @x += t.size
      unless t == texts.last
        @x = 0
        @y += 1
      end
    end
  end
end

imgs = (0..20).map do |j|
  io = ImgIO.new(85, 85)
  354.times do |i|
    if (i % (16 + j)).zero?
      io.write("THISISLONGTEXT", color: "#FB0019")
    else
      io.write("thisislongtext")
    end
  end

  io.image.copy
end

gif = ImageList.new
imgs.each do |img|
  img.scale!(3)
  gif << img
end
gif.write("aa.gif")
