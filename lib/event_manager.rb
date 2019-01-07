class EventManager
  require 'pry'
  require 'csv'
  require './lib/commands_list.rb'

  def initialize
    @content = nil
    @queue_count = 0
    @results = nil
    @header = [["LAST NAME","FIRST NAME","EMAIL","ZIPCODE","CITY","STATE","ADDRESS","PHONE"]]
    @table = []
  end

  def load_content
    # CSV.open "./#{file}", headers: true, header_converters: :symbol
    CSV.open "./full_event_attendees.csv", headers: true, header_converters: :symbol
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
    if action == "count"
      p @queue_count
    elsif action == "clear"
      @queue_count = 0
    elsif action == "print"
      build_table
      @table.unshift(@header)
      @table.each { |table_row| puts table_row.join("\t\t") }
    else
      build_table
      sorted = @table.sort_by { |table_row| table_row[attributes[action.to_sym]]}
      sorted.unshift(@header)
      sorted.each { |table_row| puts table_row.join("\t\t") }
    end
  end

  def build_table
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
    if command[0].downcase == "load"
      @content = load_content
    elsif command[0].downcase == "find"
      @results = @content.find_all do |row|
        first_name = row[:first_name]
        first_name.capitalize.chomp == command[2].capitalize
      end
      @queue_count = @results.count
    elsif command[0].downcase == "queue"
      queue_flow(command[-1].downcase)
    elsif command[0].downcase == "help"
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

