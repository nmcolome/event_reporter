class EventManager
  require 'pry'
  require 'csv'
  require './lib/commands_list.rb'

  def initialize
    @content  = nil
    @queue    = 0
    @results  = nil
    @header   = ["LAST NAME","FIRST NAME","EMAIL","ZIPCODE","CITY","STATE","ADDRESS","PHONE"]
  end

  def load_content
    # CSV.open "./#{file}", headers: true, header_converters: :symbol
    CSV.open "./full_event_attendees.csv", headers: true, header_converters: :symbol
  end

  def find(command)
    @results = @content.find_all do |row|
      row[command[1].to_sym].to_s.downcase == command[2..-1].join(" ").downcase
    end
    @queue = @results.count
  end

  def attributes
    {
      "last_name": 0,
      "first_name": 1,
      "email": 2,
      "zipcode": 3,
      "city": 4,
      "state": 5,
      "address": 6,
      "phone": 7
    }
  end

  def queue_flow(action)
    case action[1]
    when "count"
      p @queue
    when "clear"
      @queue = 0
    when "print"
      print_table(action)
    when "save"
      save_to_csv(action[-1])
    end
  end

  def print_table(action)
    build_table
    if action[2] == "by"
      @table = @table.sort_by { |table_row| table_row[attributes[action[-1].to_sym]] }
    end
    @table.unshift(@header)
    @table.each { |table_row| puts table_row.join("\t") }
  end

  def save_to_csv(filename)
    CSV.open("./#{filename}", "wb") do |csv|
      @table.each { |row| csv << row }
    end
  end

  def build_table
    @table = []
    @results.each do |row|
      @table << [
                  row[:last_name],
                  row[:first_name],
                  row[:email_address],
                  row[:zipcode],
                  row[:city],
                  row[:street],
                  row[:homephone]
                ]
    end
  end

  def help_flow(command)
    text = CommandList.new

    if command.empty?
      puts text.list
    else
      puts text.flow(command.join(" "))
    end
  end

  def flow_control(command)
    case command[0].downcase
    when "load"
      @content = load_content
    when "find"
      find(command)
    when "queue"
      queue_flow(command)
    when "help"
      command.shift
      help_flow(command)
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

