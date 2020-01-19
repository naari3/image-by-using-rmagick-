require 'rmagick'
include Magick

def dtext(text, image, x, y, color = "white")
  t= Draw.new

  t.font = 'PressStart2P-vaV7.ttf'
  t.fill = color
  t.pointsize = 8
  t.gravity = NorthWestGravity

  t.annotate(image, 100, 200, 8 * x, 8 * y, text)
end

def draw_table(mod = 1)
  image = Image.new(8 * 0x11 * 5, 8 * 0x11 * 1) do
    self.background_color = "black"
  end

  # draw table
  (1..16).each do |i|
    (1..16).each do |j|
      r = i * j
      color = (r % mod).zero? ? "white" : "#515151"
      dtext("0x#{r.to_s(16).rjust(2, '0')}".ljust(5), image, i * 5, j, color)
    end
  end

  # draw header
  (0..16).each { |i| dtext("0x#{i.to_s(16).rjust(2, '0')}".ljust(5), image, i * 5, 0, "#FB0019") }
  (1..16).each { |i| dtext("0x#{i.to_s(16).rjust(2, '0')}".ljust(5), image, 0,     i, "#FB0019") }

  image
end

gif = ImageList.new

(1..16).each do |i|
  image = draw_table(i)
  image.scale!(3)

  gif << image
end

gif.write("a.gif")
