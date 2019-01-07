class EventManager
  require 'pry'
  require 'csv'

  def initialize
    @content = nil
    @queue_count = 0
  end

  def load_content(file)
    CSV.open "./#{file}", headers: true, header_converters: :symbol
  end

  def queue_flow(action)
    if action == "count"
      p @queue_count
    elsif action == "clear"
      @queue_count = 0
    end
  end

  def flow_control(command)
    if command[0].downcase == "load"
      @content = load_content(command[1])
    elsif command[0].downcase == "find"
      results = @content.find_all do |row|
        first_name = row[:first_name]
        first_name == command[2].capitalize
      end
      @queue_count = results.count
    elsif command[0].downcase == "queue"
      queue_flow(command[1].downcase)
    end
  end
end

event_manager = EventManager.new
command = ""
while command != 'quit' do
  puts "Enter a command:"
  answer = gets.chomp
  command = answer.split(" ")
  event_manager.flow_control(command)
end

