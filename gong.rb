require 'wavefile'
require 'matrix'
require 'time'

module GongArt
  def self.render
    <<~ART
        .-""""-.
      /        \\
      |   (())   |
      |          |
      \\        /
        '------'
          |  |
          |  |
        /    \\
    ART
  end
end

class GongSound
  SAMPLE_RATE = 44100
  DURATION = 3.0  # Seconds
  
  def initialize
    @samples = []
  end
  
  def generate
    fundamental = 100  # Hz
    harmonics = [1, 1.5, 2.2, 3.1, 4.5]
    amplitudes = [1.0, 0.7, 0.5, 0.3, 0.2]
    
    (0...num_samples).each do |i|
      t = i.to_f / SAMPLE_RATE
      sample = 0.0
      
      harmonics.each_with_index do |harmonic, idx|
        freq = fundamental * harmonic
        envelope = Math.exp(-0.5 * t) * (1 + 0.3 * Math.sin(5 * t))
        wave = Math.sin(2 * Math::PI * freq * t)
        noise = (rand - 0.5) * 0.1 * envelope
        sample += amplitudes[idx] * envelope * (wave + noise)
      end
      
      sample = [[sample, 1.0].min, -1.0].max
      @samples << sample
    end
    
    apply_simple_filter
  end
  
  def save(filename)
    format = WaveFile::Format.new(:mono, :pcm_16, SAMPLE_RATE)
    
    int_samples = @samples.map { |s| (s * 32767).round }
    
    buffer = WaveFile::Buffer.new(int_samples, format)
    
    WaveFile::Writer.new(filename, format) do |writer|
      writer.write(buffer)
    end
  end
  
  def play
    save("gong.wav")
    system("afplay gong.wav")
  end
  
  private
  
  def num_samples
    (SAMPLE_RATE * DURATION).to_i
  end
  
  def apply_simple_filter
    filtered = []
    @samples.each_with_index do |sample, i|
      if i == 0
        filtered << sample
      else
        filtered << (sample * 0.7 + filtered[i-1] * 0.3)
      end
    end
    @samples = filtered
  end
end

class Timer
  def initialize(minutes, language = :en)
    @minutes = minutes
    @language = language
    @gong = GongSound.new
    @gong.generate
  end
  
  def start
    target_time = Time.now + (@minutes * 60)
    formatted_time = target_time.strftime("%H:%M:%S")
    
    if @language == :ja
      puts "⏰ #{@minutes}分のタイマーをセットしました"
      puts "予定時刻: #{formatted_time}"
    else
      puts "⏰ Timer set for #{@minutes} minute#{@minutes > 1 ? 's' : ''}"
      puts "Target time: #{formatted_time}"
    end
    
    remaining = @minutes * 60
    
    while remaining > 0
      sleep 10  # Count down every 10 seconds
      remaining -= 10
      
      # Adjust if we've gone past zero
      if remaining < 0
        remaining = 0
      end
      
      # Report every minute
      if remaining % 60 == 0 && remaining > 0
        mins_left = remaining / 60
        if @language == :ja
          puts "残り#{mins_left}分です"
        else
          puts "#{mins_left} minute#{mins_left > 1 ? 's' : ''} remaining"
        end
      # Report every 10 seconds
      else
        secs_left = remaining
        if @language == :ja
          puts "残り#{secs_left}秒です"
        else
          puts "#{secs_left} second#{secs_left != 1 ? 's' : ''} remaining"
        end
      end
    end
    
    # Display gong art
    gong_art = GongArt.render
    
    if @language == :ja
      puts "\n時間になりました！"
      puts "🎵 ゴ～～～ン..."
    else
      puts "\nTime's up!"
      puts "🎵 Gooooong..."
    end
    
    puts gong_art
    @gong.play
  end
end

if __FILE__ == $0
  if ARGV[0] == "--timer" || ARGV[0] == "-t"
    minutes = ARGV[1]&.to_i || 5
    language = nil
    
    # Check for language option
    if ARGV[2] == "--ja" || ARGV[2] == "-j"
      language = :ja
    elsif ARGV[2] == "--en" || ARGV[2] == "-e"
      language = :en
    else
      language = :en # Default to English
    end
    
    timer = Timer.new(minutes, language)
    timer.start
  else
    gong = GongSound.new
    gong.generate
    gong.save("gong.wav")
    
    puts "🎵 ゴ～～～ン..."
      
    gong_art = GongArt.render
      
    puts gong_art
    gong.play
  end
end
