#! ruby -Ku
# encoding: utf-8

# usage: ruby yj.rb ./in ./out [mode]

require "RMagick"

def argv
  @y_dir = ARGV[0]
  @j_dir = ARGV[1]
  @mode = ARGV[2].nil? ? "0" : ARGV[2]  # 0: font only (default), 1: overwrite
end

def load_n
  @names = {}
  names_jp = File.read("./res/coco.names.jp").split("\n")
  File.read("./res/coco.names").split("\n").each_with_index do |name, idx|
    @names[name] = names_jp[idx]
  end
end

def load_y
  @y_paths = Dir.glob("#{@y_dir}/*.png").sort
  @y_results = []
  File.read("#{@y_dir}/result.txt").split("\n").each do |line|
    @y_results << eval(line.tr("()", "[]"))
  end
end

def gen_j
  abort "error" unless @y_paths.length == @y_results.length
  @y_paths.each_with_index do |y_path, idx|
    STDERR.puts y_path
    y_ymg = Magick::ImageList.new(y_path).first
    j_ymg = nil
    if @mode == "0"
      j_ymg = Magick::Image.new(y_ymg.columns, y_ymg.rows) {
        self.background_color = "white"
      }
    else
      j_ymg = y_ymg.copy
    end
    draw = Magick::Draw.new
    @y_results[idx].each do |y_result|
      fill = @mode == "0" ? "black" : "white"
      name_jp = @names[y_result[0]]
      x, y, w, h = y_result[2]
      draw.annotate(j_ymg, w, h, x - w / 2, y - h / 2, name_jp) {
        self.font = "./res/HGRME001.ttf"
        self.fill = fill
        self.stroke = "transparent"
        self.pointsize = [w / name_jp.length, h].min
        self.gravity = Magick::CenterGravity
      }
    end
    j_ymg.write("#{@j_dir}/#{File.basename(y_path)}")
    j_ymg.destroy!
    y_ymg.destroy!
  end
end

def execute
  argv
  load_n
  load_y
  gen_j
end

execute
